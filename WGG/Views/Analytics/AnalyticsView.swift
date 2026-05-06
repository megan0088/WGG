//
//  Analytics.swift
//  WGG
//
//  Created by Filbert Naldo Wijaya on 02/05/26.
//

import SwiftUI
import Charts
import SwiftData

struct AnalyticsView: View {
    @Query(filter: #Predicate<Session> { $0.isCompleted }, sort: \Session.date, order: .forward)
    private var sessions: [Session]
    
    @State private var selectedTime = "All"
    @State private var selectedExercise: String = ""
    
    var exerciseNames: [String] {
        let names = sessions
            .flatMap { $0.sessionExercises }
            .compactMap { $0.exercise?.name }
        return Array(Set(names)).sorted()
    }
    
    // MARK: Get start date (from now) for timeframe filtering
    var startDateFilter: Date {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedTime {
        case "1M": return calendar.date(byAdding: .month, value: -1, to: now) ?? .distantPast
        case "3M": return calendar.date(byAdding: .month, value: -3, to: now) ?? .distantPast
        case "6M": return calendar.date(byAdding: .month, value: -6, to: now) ?? .distantPast
        case "1Y": return calendar.date(byAdding: .year, value: -1, to: now) ?? .distantPast
        default: return .distantPast
        }
    }
    
    // MARK: Get selected exercise history in [(date, [sets]), ...] format
    var exerciseHistory: [(date: Date, sets: [SessionSet])] {
        guard !selectedExercise.isEmpty else { return [] }
        let limitDate = startDateFilter
        
        return sessions
            .filter { $0.date >= limitDate }
            .compactMap { session -> (date: Date, sets: [SessionSet])? in
                guard let sessionEx = session.sessionExercises.first(where: { $0.exercise?.name == selectedExercise })
                else { return nil }
                
                let completedSets = sessionEx.sets
                    .filter { $0.isCompleted }
                    .sorted { $0.setNumber < $1.setNumber }
                
                guard !completedSets.isEmpty else {return nil }
                return (date: session.date, sets: completedSets)
            }
    }
    
    // function to calculate estimated 1RM
    private func estimated1RM(weight: Double, reps: Int) -> Double {
        weight * (1.0 + Double(reps) / 30.0)
    }
    
    // MARK: Get best set data for card
    var bestSet: (weight: Double, reps: Int, date: Date) {
        let allSets = exerciseHistory.flatMap { entry in
            entry.sets.map { (weight: $0.weight, reps: $0.reps, entry.date) }
        }
        
        let best = allSets.max { set1, set2 in
            if set1.weight == set2.weight {
                return set1.reps < set2.reps
            }
            return set1.weight < set2.weight
        }
        
        return best ?? (weight: 0.0, reps: 0, date: Date())
    }
    
    var totalSession: Int { exerciseHistory.count }
    var lastSession: (date: Date, sets: [SessionSet])? { exerciseHistory.last }
    
    // MARK: Get charts data
    var estimated1RMChartData: [ChartData] {
        return exerciseHistory.map { entry in
            var best: Double = 0
            
            for set in entry.sets {
                let value = estimated1RM(weight: set.weight, reps: set.reps)
                
                if value >= best {
                    best = value
                }
            }
            
            return ChartData(x: entry.date, y: best)
        }
    }
    
    var maxWeightChartData: [ChartData] {
        return exerciseHistory.map { entry in
            var maxWeight: Double = 0
            
            for set in entry.sets {
                if set.weight > maxWeight {
                    maxWeight = set.weight
                }
            }
            
            return ChartData(x: entry.date, y: maxWeight)
        }
    }
    
    var volumeChartData: [ChartData] {
        return exerciseHistory.map { entry in
            var volume: Double = 0
            
            for set in entry.sets {
                volume += (Double(set.weight) * Double(set.reps))
            }
            
            return ChartData(x: entry.date, y: volume)
        }
    }
    
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Analytics")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.primaryText)
                    }
                    .padding(.horizontal)
                    
                    // MARK: Time Range Picker
                    CustomSegmentedPicker(selectedTime: $selectedTime)
                    
                    // MARK: Exercise Name Picker
                    Menu {
                        Picker("Select", selection: $selectedExercise) {
                            ForEach(exerciseNames, id: \.self) { name in
                                Text(name)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedExercise)
                                .fontWeight(.bold)
                                .font(.headline)
                            Spacer()
                            Image(systemName: "chevron.up.chevron.down")
                                .opacity(0.5)
                        }
                        .foregroundStyle(.primaryText)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.card)
                        .cornerRadius(15)
                    }
                    .padding()
                    
                    // MARK: Info Cards
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Best Set")
                                .font(.subheadline)
                                .foregroundStyle(.primaryText.opacity(0.5))
                            Text("\(bestSet.weight, specifier: "%.1f") kg x \(bestSet.reps)")
                                .font(.title2)
                                .foregroundStyle(.primaryText)
                                .bold()
                                .padding(.vertical, 1)
                            Text(bestSet.date.formatted(.dateTime.month(.abbreviated).day()))
                                .font(.caption)
                                .foregroundStyle(.primaryText)
                                .opacity(0.5)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.card)
                        .cornerRadius(15)
                        
                        VStack(alignment: .leading) {
                            Text("Total Session")
                                .font(.subheadline)
                                .foregroundStyle(.primaryText.opacity(0.5))
                            Text("\(totalSession)")
                                .font(.title2)
                                .foregroundStyle(.accent)
                                .bold()
                                .padding(.vertical, 1)
                            Text("Last: \(lastSession?.date.formatted(.dateTime.month(.abbreviated).day()) ?? "-")")
                                .font(.caption)
                                .foregroundStyle(.primaryText)
                                .opacity(0.5)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.card)
                        .cornerRadius(15)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // MARK: Estimated 1RM Chart
                    ChartCard(title: "Estimated 1RM", data: estimated1RMChartData, chartType: "Line")
                        .padding(.vertical)
                    
                    // MARK: Max Weight Chart
                    ChartCard(title: "Max Weight", data: maxWeightChartData, chartType: "Bar")
                    
                    // MARK: Volume Chart
                    ChartCard(title: "Volume", data: volumeChartData, chartType: "Bar")
                        .padding(.vertical)
                    
                    // MARK: Last Session Card
                    VStack(alignment: .leading) {
                        Text("Last Session (Benchmark)")
                            .bold()
                            .foregroundStyle(Color.primaryText.opacity(0.5))
                        
                        VStack {
                            HStack {
                                if let lastDate = lastSession?.date {
                                    let exactDate = lastDate.formatted(.dateTime.month(.abbreviated).day().year())
                                    let relativeTime = lastDate.formatted(.relative(presentation: .numeric))
                                    Text("\(exactDate) (\(relativeTime))")
                                } else {
                                    Text("Date: -")
                                }
                                Spacer()
                                if let totalSets = lastSession?.sets.last?.setNumber {
                                    Text("\(totalSets) sets")
                                } else {
                                    Text("0 sets")
                                }
                            }
                            .font(.subheadline)
                            .foregroundStyle(Color.primaryText.opacity(0.5))
                            .padding(8)
                            .padding(.bottom, 8)
                            
                            // MARK: Last Session Table
                            VStack {
                                Grid {
                                    Divider().background(Color.primaryText.opacity(0.5))
                                    
                                    GridRow {
                                        Text("SET").gridCellAnchor(.center)
                                        Text("REPS").gridCellAnchor(.center)
                                        Text("WEIGHT").gridCellAnchor(.center)
                                    }
                                    .font(.subheadline)
                                    .foregroundStyle(Color.primaryText.opacity(0.5))
                                    .padding(.vertical, 4)
                                    
                                    Divider().background(Color.primaryText.opacity(0.5))
                                    
                                    if let lastSessionSets = lastSession?.sets {
                                        ForEach(lastSessionSets, id: \.setNumber) { set in
                                            GridRow {
                                                Text("\(set.setNumber)")
                                                Text("\(set.reps)")
                                                Text("\(set.weight, specifier: "%.1f") kg ")
                                            }
                                            .padding(.vertical, 4)
                                            
                                            if set.setNumber != lastSessionSets.last?.setNumber {
                                                Divider().background(Color.primaryText.opacity(0.5))
                                            }
                                        }
                                    }
                                    else {
                                        GridRow {
                                            Text("No Data")
                                                .foregroundStyle(Color.primaryText.opacity(0.5))
                                                .gridCellColumns(3)
                                                .padding(.vertical, 32)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.card)
                        .cornerRadius(15)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            if selectedExercise.isEmpty {
                selectedExercise = exerciseNames.first ?? ""
            }
        }
    }
}

#Preview {
    AnalyticsView()
        .modelContainer(for: [Session.self, SessionExercise.self, SessionSet.self, Exercise.self, Routine.self], inMemory: true)
}

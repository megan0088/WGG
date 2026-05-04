//
//  Analytics.swift
//  WGG
//
//  Created by Filbert Naldo Wijaya on 02/05/26.
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    @State private var selectedTime = "All"
    @State private var selectedExercise = "Bench Press"
    
    let exercises = ["Bench Press", "Dumbell Fly", "Fufufafa"]
    
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
    
    // MARK: Get selected exercise history in [(date, entry), ...] format
    var exerciseHistory: [(date: Date, entry: ExerciseEntry)] {
        let limitDate = startDateFilter
        
        return MockAnalyticsData.allSessions.compactMap { session in
            guard session.date >= limitDate else { return nil }
            
            if let foundExercise = session.exercises.first(where: { $0.exerciseName == selectedExercise }) {
                return (date: session.date, entry: foundExercise)
            }
            return nil
        }
        .sorted { $0.date < $1.date }
    }
    
    // MARK: Get best set data for card
    var bestSet: (weight: Double, reps: Int, date: Date) {
        let allSets = exerciseHistory.flatMap { session in
            session.entry.sets.map { workoutSet in
                (weight: workoutSet.weight, reps: workoutSet.reps, session.date)
            }
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
    var lastSession: (date: Date, entry: ExerciseEntry)? { exerciseHistory.last }
    
    // MARK: Get charts data
    var estimated1RMChartData: [ChartData] {
        exerciseHistory.map { history in
            ChartData(x: history.date, y: history.entry.estimated1RM)
        }
    }
    
    var maxWeightChartData: [ChartData] {
        exerciseHistory.map { history in
            ChartData(x: history.date, y: history.entry.maxWeight)
        }
    }
    
    var volumeChartData: [ChartData] {
        exerciseHistory.map { history in
            ChartData(x: history.date, y: history.entry.volume)
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
                            .foregroundColor(.primaryText)
                    }
                    .padding()
                    
                    // MARK: Time Range Picker
                    CustomSegmentedPicker(selectedTime: $selectedTime)
                    
                    // MARK: Exercise Name Picker
                    Menu {
                        Picker("Select", selection: $selectedExercise) {
                            ForEach(exercises, id: \.self) { exercise in
                                Text(exercise)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedExercise)
                                .fontWeight(.bold)
                            Spacer()
                            Image(systemName: "chevron.up.chevron.down")
                                .opacity(0.5)
                        }
                        .foregroundColor(.primaryText)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.card)
                        .cornerRadius(15)
                    }
                    .padding()
                    
                    // MARK: Info Cards
                    HStack {
                        VStack(alignment: .leading) {
                            Text("BEST SET")
                                .font(.caption)
                                .foregroundColor(.primaryText.opacity(0.5))
                            Text("\(bestSet.weight, specifier: "%.1f") kg x \(bestSet.reps)")
                                .font(.title2)
                                .foregroundColor(.primaryText)
                                .bold()
                                .padding(.vertical, 1)
                            Text(bestSet.date.formatted(.dateTime.month(.abbreviated).day()))
                                .font(.subheadline)
                                .foregroundColor(.primaryText)
                                .opacity(0.5)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.card)
                        .cornerRadius(15)

                        VStack(alignment: .leading) {
                            Text("TOTAL SESSION")
                                .font(.caption)
                                .foregroundColor(.primaryText.opacity(0.5))
                            Text("\(totalSession)")
                                .font(.title2)
                                .foregroundColor(.accent)
                                .bold()
                                .padding(.vertical, 1)
                            Text("Last: \(lastSession?.date.formatted(.dateTime.month(.abbreviated).day()) ?? "-")")
                                .font(.subheadline)
                                .foregroundColor(.primaryText)
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
                    ChartCard(title: "ESTIMATED 1RM", data: estimated1RMChartData, chartType: "Line")
                        .padding(.vertical)
                    
                    // MARK: Max Weight Chart
                    ChartCard(title: "MAX WEIGHT", data: maxWeightChartData, chartType: "Bar")
                    
                    // MARK: Volume Chart
                    ChartCard(title: "VOLUME", data: volumeChartData, chartType: "Bar")
                        .padding(.vertical)
                    
                    // MARK: Last Session Card
                    VStack(alignment: .leading) {
                        Text("LAST SESSION (BENCHMARK)")
                            .bold()
                            .foregroundStyle(Color.primaryText.opacity(0.5))
                        
                        VStack {
                            HStack {
                                if let lastDate = lastSession?.date {
                                    let exactDate = lastDate.formatted(.dateTime.month(.abbreviated).day().year())
                                    let relativeTime = lastDate.formatted(.relative(presentation: .numeric))
                                    Text("\(exactDate) (\(relativeTime))")
                                } else {
                                    Text("-")
                                }
                                Spacer()
                                if let totalSets = lastSession?.entry.sets.last?.setNumber {
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
                                    
                                    if let lastSessionSets = lastSession?.entry.sets {
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
    }
}

#Preview {
    AnalyticsView()
}

//
//  MuscleFocusCard.swift
//  WGG
//
//  Created by Stepanus Imanuel on 02/05/26.
//

import SwiftUI
import SwiftData

struct MuscleFocusCard: View {
    
    @Query(sort: \Session.date, order: .reverse)
    var sessions: [Session]
    
    let muscleGroups: [String] = [
        "All",
        "Chest",
        "Shoulders",
        "Back",
        "Arms",
        "Legs"
    ]
    let calendar = Calendar.current
    
    var rawData: [String: Double] {
        let thisMonth = calendar.component(.month, from: Date())
        let thisYear = calendar.component(.year, from: Date())
        
        var dict: [String: Double] = [:]
        
        for session in sessions where session.isCompleted {
            let m = calendar.component(.month, from: session.date)
            let y = calendar.component(.year, from: session.date)
            
            if m == thisMonth && y == thisYear {
                for se in session.sessionExercises {
                    guard let exercise = se.exercise else { continue }
                    
                    let volume = se.sets.reduce(0.0) {
                        $0 + ($1.weight * Double($1.reps))
                    }
                    
                    dict[exercise.muscleGroup, default: 0] += volume
                }
            }
        }
        
        let total = dict.values.reduce(0, +)
        
        if total == 0 { return [:] }
        
        return dict.mapValues { ($0 / total) * 100 }
    }
    
    var displayData: [(name: String, value: Double)] {
        muscleGroups.map { ($0, rawData[$0] ?? 0) }
    }
    
    var chartData: [(name: String, value: Double)] {
        displayData.filter { $0.value > 0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleText(text: "Muscle Focus This Month", isUpper: true)
            
            HStack(spacing: 32) {
                
                ZStack {
                    if chartData.isEmpty {
                        Circle()
                            .stroke(Color.white.opacity(0.1), lineWidth: 20)
                    } else {
                        ForEach(Array(chartData.enumerated()), id: \.offset) { index, item in
                            let totalGap: Double = chartData.count > 1 ? 6 : 0
                            let gapPerSegment = totalGap / Double(chartData.count)
                            
                            let startBase = getAngle(for: index)
                            let endBase = getAngle(for: index + 1)
                            
                            let start = startBase + gapPerSegment / 2
                            let end = endBase - gapPerSegment / 2
                            
                            DonutSegment(startAngle: start, endAngle: end)
                                .stroke(color(for: item.name), style: StrokeStyle(lineWidth: 20, lineCap: .butt))
                        }
                    }
                }
                .frame(width: 110, height: 110)
                .rotationEffect(.degrees(-90))
                
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(displayData, id: \.name) { item in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(color(for: item.name))
                                .frame(width: 8, height: 8)
                            
                            Text(item.name)
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.7))
                            
                            Spacer()
                            
                            Text("\(Int(item.value))%")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            .padding(24)
            .background(Color("Card"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    func getAngle(for index: Int) -> Double {
        let totalProgress = chartData.prefix(index).reduce(0) { $0 + $1.value }
        return (totalProgress / 100) * 360
    }
    
    func color(for muscle: String) -> Color {
        switch muscle {
        case "Back": return .back
        case "Chest": return .chest
        case "Leg", "Legs": return .leg
        case "Shoulder", "Shoulders": return .shoulder
        case "Arm", "Arms": return .arm
        default: return .gray
        }
    }
}

#Preview {
    MuscleFocusCard()
}

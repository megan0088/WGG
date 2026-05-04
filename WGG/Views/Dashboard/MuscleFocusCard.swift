//
//  MuscleFocusCard.swift
//  WGG
//
//  Created by Stepanus Imanuel on 02/05/26.
//

import SwiftUI

struct MuscleFocusCard: View {
    let rawData = DashboardData.muscleFocus
    let defaultMuscles = ["Back", "Chest", "Leg", "Shoulder", "Arm"]
    
    var displayData: [(name: String, value: Double)] {
        defaultMuscles.map { ($0, rawData[$0] ?? 0) }
    }
    
    // Data untuk chart (> 0%)
    var chartData: [(name: String, value: Double)] {
        displayData.filter { $0.value > 0 }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TitleText(text: "Muscle Focus This Month", isUpper: true)
            
            HStack(spacing: 32) {
                // MARK: - Chart
                ZStack {
                    if chartData.isEmpty {
                        Circle()
                            .stroke(Color.white.opacity(0.1), lineWidth: 20)
                    } else {
                        ForEach(Array(chartData.enumerated()), id: \.offset) { index, item in
                            let start = getAngle(for: index)
                            let end = getAngle(for: index + 1)
                            
                            // Segmen Warna
                            DonutSegment(startAngle: start, endAngle: end)
                                .stroke(color(for: item.name), style: StrokeStyle(lineWidth: 20, lineCap: .butt))
                            
                            // gap
                            DonutSegment(startAngle: end - 1, endAngle: end + 1)
                                .stroke(Color("Card"), style: StrokeStyle(lineWidth: 20, lineCap: .butt))
                        }
                    }
                }
                .frame(width: 110, height: 110)
                .rotationEffect(.degrees(-90))
                
                // MARK: - Legend
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
    
    // mapping
    func color(for muscle: String) -> Color {
        switch muscle {
        case "Back": return .blue
        case "Chest": return .red
        case "Leg": return .green
        case "Shoulder": return .orange
        case "Arm": return .purple
        default: return .gray
        }
    }
}

#Preview {
    MuscleFocusCard()
}

//
//  MuscleFocusCard.swift
//  WGG
//
//  Created by Stepanus Imanuel on 02/05/26.
//

import SwiftUI

struct MuscleFocusCard: View {
    
    let rawData = DashboardData.muscleFocus
    
    // default muscle list
    let defaultMuscles = ["Back", "Chest", "Leg", "Shoulder", "Arm"]
    
    var isEmpty: Bool {
        rawData.isEmpty
    }
    
    var data: [(String, Double)] {
        defaultMuscles.map { muscle in
            (muscle, rawData[muscle] ?? 0)
        }
    }
    
    var chartData: [(String, Double)] {
        data.filter {$0.1 > 0}
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            TitleText(text: "Muscle Focus this month", isUpper: true)
            HStack(spacing: 32) {
                
                // chart
                ZStack {
                    
                    if isEmpty {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 12)
                    } else {
                        ForEach(Array(chartData.enumerated()), id: \.offset) { index, item in
                            
                            let start = startAngle(for: index)
                            let end = endAngle(for: index)
                            
                            DonutSegment(startAngle: start, endAngle: end)
                                .stroke(
                                    color(for: item.0),
                                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                                )
                            
                        }
                    }
                }
                .frame(width: 120, height: 120)
                
                // legend
                VStack(alignment: .leading, spacing: 10) {
                    
                    ForEach(data, id: \.0) { item in
                        HStack {
                            
                            Circle()
                                .fill(color(for: item.0))
                                .frame(width: 8, height: 8)
                            
                            Text(item.0)
                                .foregroundStyle(Color("BrandSecondary"))
                                .font(.subheadline)
                            
                            Spacer()
                            
                            Text("\(Int(item.1))%")
                                .foregroundStyle(Color("BrandSecondary"))
                        }
                    }
                }
            }
            .padding(24)
            .background(Color(#colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    // MARK: - Angles
    
    func startAngle(for index: Int) -> Double {
        let prev = chartData.prefix(index).reduce(0) { $0 + $1.1 }
        return (prev / 100) * 360 - 90 + 7
    }
    
    func endAngle(for index: Int) -> Double {
        let sum = chartData.prefix(index + 1).reduce(0) { $0 + $1.1 }
        return (sum / 100) * 360 - 90 - 7
    }
    
    // MARK: Map color
    
    func color(for muscle: String) -> Color {
        switch muscle {
        case "Back": return .back
        case "Chest": return .chest
        case "Leg": return .leg
        case "Shoulder": return .shoulder
        case "Arm": return .arm
        default: return .gray
        }
    }
}

#Preview {
    MuscleFocusCard()
}

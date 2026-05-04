//
//  Estimated1RMCard.swift
//  WGG
//
//  Created by Filbert Naldo Wijaya on 02/05/26.
//

import SwiftUI
import Charts

struct ChartCard: View {
    let title: String
    let data: [ChartData]
    let chartType: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(title)")
                    .bold()
                    .foregroundStyle(Color.primaryText.opacity(0.5))
                
                Spacer()
                
                HStack {
                    Text("\(data.map({$0.y}).max() ?? 0, specifier: "%.1f") kg")
                        .foregroundStyle(Color.accent)
                        .fontWeight(.black)
                    
                    let firstY: Double? = data.first?.y
                    let lastY: Double? = data.last?.y
                    var percentChange: String {
                        guard let first = firstY, let last = lastY, first != 0 else { return "0" }
                        let change = ((last - first)/first) * 100
                        let formatted = String(format: "%.0f", change)
                        return change >= 0 ? "+" + formatted : formatted
                    }
                    
                    Text("\(percentChange)%")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .foregroundStyle(Color.accent)
                        .fontWeight(.bold)
                        .background(Color.accent.opacity(0.1))
                        .cornerRadius(5)
                }
            }
            .padding(.bottom)
            
            Chart {
                ForEach(data) { item in
                    let dateString = item.x.formatted(.dateTime.day(.twoDigits).month(.twoDigits))
                    
                    if (chartType == "Line") {
                        LineMark(
                            x: .value("Date", dateString),
                            y: .value("Max Weight", item.y)
                        )
                        .foregroundStyle(Color.accent)
                        
                        PointMark(
                            x: .value("Date", dateString),
                            y: .value("Max Weight", item.y)
                        )
                        .foregroundStyle(Color.accent)
                    }
                    else if (chartType == "Bar") {
                        BarMark(
                            x: .value("Date", dateString),
                            y: .value("Max Weight", item.y),
                            width: .ratio(0.8)
                        )
                        .foregroundStyle(item.id == data.last?.id ? Color.accent : Color(red: 42/255, green: 42/255, blue: 42/255))
                        .cornerRadius(4)
                    }
                }
            }
            .frame(height: 200)
            .chartYAxis {
                AxisMarks(position: .leading) {
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [8, 4])).foregroundStyle(Color.primaryText.opacity(0.125))
                    AxisValueLabel().foregroundStyle(Color.primaryText.opacity(0.5))
                }
            }
            .chartXAxis {
                AxisMarks {
                    AxisValueLabel()
                        .foregroundStyle(Color.primaryText.opacity(0.5))
                }
            }
        }
        .padding()
        .background(Color.card)
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

#Preview {
    let now = Date()
    let sample: [ChartData] = [
        ChartData(x: Calendar.current.date(byAdding: .day, value: -6, to: now)!, y: 23),
        ChartData(x: Calendar.current.date(byAdding: .day, value: -5, to: now)!, y: 26),
        ChartData(x: Calendar.current.date(byAdding: .day, value: -4, to: now)!, y: 26),
        ChartData(x: Calendar.current.date(byAdding: .day, value: -3, to: now)!, y: 35),
        ChartData(x: Calendar.current.date(byAdding: .day, value: -2, to: now)!, y: 37.5),
        ChartData(x: Calendar.current.date(byAdding: .day, value: -1, to: now)!, y: 39),
        ChartData(x: now, y: 40)
    ]
    return ChartCard(
        title: "ESTIMATED 1RM",
        data: sample,
        chartType: "Bar"
    )
}

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
    
    @State private var selectedDate: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(title)")
                    .bold()
                    .foregroundStyle(Color.primaryText.opacity(0.5))
                
                Spacer()
                
                HStack {
                    Text("\(data.map({$0.y}).last ?? 0, specifier: "%.1f") kg")
                        .foregroundStyle(Color.accent)
                        .fontWeight(.black)
                    
                    let firstY: Double? = data.first?.y
                    let lastY: Double? = data.last?.y
                    
                    var percentChangeValue: Double {
                        guard let first = firstY, let last = lastY, first != 0 else { return 0 }
                        return ((last - first) / first) * 100
                    }
                    
                    var percentChange: String {
                        let formatted = String(format: "%.0f", percentChangeValue)
                        return percentChangeValue >= 0 ? "+" + formatted : formatted
                    }
                    
                    Text("\(percentChange)%")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .foregroundStyle(
                            percentChangeValue >= 0 ? Color.accent : Color.red
                        )
                        .fontWeight(.bold)
                        .background(
                            (percentChangeValue >= 0 ? Color.accent : Color.red)
                            .opacity(0.1)
                        )
                        .cornerRadius(5)
                }
            }
            .padding(.bottom)
            
            if data.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: chartType == "Line" ? "chart.xyaxis.line" : "chart.bar.fill")
                        .font(.title2)
                    Text("Not enough data")
                }
                .foregroundStyle(Color.primaryText.opacity(0.5))
                .frame(maxWidth: .infinity)
                .frame(height: 200)
            }
            else {
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
                    
                    if let selectedDate, let selectedItem = data.first(where: { $0.x.formatted(.dateTime.day(.twoDigits).month(.twoDigits)) == selectedDate}) {
                        RuleMark(
                            x: .value("Date", selectedDate)
                        )
                        .lineStyle(StrokeStyle(lineWidth: 1.5))
                        .foregroundStyle(Color.primaryText)
                        
                        PointMark(
                            x: .value("Date", selectedDate),
                            y: .value("Max Weight", selectedItem.y)
                        )
                        .foregroundStyle(Color.accent)
                        .annotation(position: .top, spacing: 0, overflowResolution: .init(x: .fit, y: .disabled)) {
                            VStack {
                                Text(selectedItem.x.formatted(.dateTime.month(.abbreviated).day()))
                                    .font(.caption)
                                    .foregroundStyle(Color.brandSecondary)
                                Text("\(selectedItem.y, specifier: "%.1f") kg")
                                    .font(.subheadline)
                                    .fontWeight(.black)
                                    .foregroundStyle(Color.accent)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.card)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.primaryText.opacity(0.1), lineWidth: 1)
                            )
                        }
                    }
                }
                .chartXScale(range: .plotDimension(padding: 5))
                .frame(height: 200)
                .chartXSelection(value: $selectedDate)
                .chartYAxis {
                    AxisMarks(position: .leading) {
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [8, 4])).foregroundStyle(Color.primaryText.opacity(0.125))
                        AxisValueLabel().foregroundStyle(Color.primaryText.opacity(0.5))
                    }
                }
                .chartXAxis {
                    let stride = max(1, Int(ceil(Double(data.count) / 6.0)))
                    let xAxisValues = data.enumerated().compactMap { index, item -> String? in
                        if index % stride == 0 {
                            return item.x.formatted(.dateTime.day(.twoDigits).month(.twoDigits))
                        }
                        return nil
                    }
                    AxisMarks(values: xAxisValues) {
                        AxisValueLabel()
                            .foregroundStyle(Color.primaryText.opacity(0.5))
                    }
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

//
//  WeeklyVolumeCard.swift
//  WGG
//
//  Created by Stepanus Imanuel on 01/05/26.
//

import SwiftUI

struct WeeklyVolumeCard: View {
    let volumes = DashboardData.weeklyVolume
    let lastWeek = DashboardData.lastWeekVolume
    
    @State private var selectedIndex: Int? = nil
        
    var totalThisWeek: Double {
        volumes.reduce(0, +)
    }
    
    var totalLastWeek: Double {
        lastWeek.reduce(0, +)
    }
    
    var diff: Double {
        totalThisWeek - totalLastWeek
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
                    
            // title
            TitleText(text: "Weekly Volume", isUpper: true)
            
            // total volume this week
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                
                Text("\(Int(totalThisWeek))")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text(" kg this week")
                    .font(.subheadline)
                    .foregroundStyle(Color("BrandSecondary"))
                
            }
            
            // percentage vs last week
            HStack(spacing: 2) {
                
                Image(systemName:
                    diff >= 0 ? "chart.line.uptrend.xyaxis" : "chart.line.downtrend.xyaxis")
                    .foregroundStyle(
                        diff >= 0 ? Color.accent : Color.red
                    )
                Text("\(diff >= 0 ? "+" : "")\(Int(toPercentage(num: diff)))% vs last week")
                    .fontWeight(.semibold)
                    .foregroundStyle(diff >= 0 ? .green : .red)
            }
            .font(.footnote)
            .fontWeight(.light)
            
            // chart
            HStack(alignment: .bottom, spacing: 24) {
                
                ForEach(volumes.indices, id: \.self) { i in
                    
                    let maxValue = (volumes + lastWeek).max() ?? 1
                    let height = CGFloat(volumes[i] / maxValue) * 120
                    
                    VStack(spacing: 6) {
                        
                        // value ketika diklik
                        if selectedIndex == i {
                            Text("\(Int(volumes[i]))")
                                .font(.caption2)
                                .foregroundStyle(.white)
                        }
                        
                        // bar
                        RoundedRectangle(cornerRadius: 6)
                            .fill(i == todayIndex() ? Color("Accent") : Color.gray.opacity(0.4))
                            .frame(height: max(height/2, 4))
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedIndex = (selectedIndex == i ? nil : i)
                                }
                            }
                        
                        // hari
                        Text(dayLabel(i))
                            .font(.caption2)
                            .foregroundStyle(Color("BrandSecondary"))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 26)
                }
            }
        }
        .padding(24)
        .background(Color(#colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    func dayLabel(_ index: Int) -> String {
        let days = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        return days[index]
    }
    
    func todayIndex() -> Int {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return weekday - 1
    }
    
    func toPercentage(num: Double) -> Double {
        return num.isZero ? 0 : (num / totalLastWeek) * 100
    }
}

#Preview {
    WeeklyVolumeCard()
}

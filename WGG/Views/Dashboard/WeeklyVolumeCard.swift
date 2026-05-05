//
//  WeeklyVolumeCard.swift
//  WGG
//
//  Created by Stepanus Imanuel on 01/05/26.
//

import SwiftUI
import SwiftData

struct WeeklyVolumeCard: View {
    
    @Query(sort: \Session.date, order: .reverse)
    var sessions: [Session]
    
    @State private var selectedIndex: Int? = nil
    
    let calendar = Calendar.current
    
    var thisWeekDates: [Date] {
        let start = calendar.dateInterval(of: .weekOfYear, for: Date())!.start
        return (0..<7).map { calendar.date(byAdding: .day, value: $0, to: start)! }
    }
    
    var lastWeekDates: [Date] {
        let start = calendar.dateInterval(of: .weekOfYear, for: Date())!.start
        let lastWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: start)!
        
        return (0..<7).map {
            calendar.date(byAdding: .day, value: $0, to: lastWeekStart)!
        }
    }
    
    var volumes: [Double] {
        thisWeekDates.map { date in
            sessions
                .filter {
                    $0.isCompleted &&
                    calendar.isDate($0.date, inSameDayAs: date)
                }
                .reduce(0.0) { total, session in
                    total + totalVolume(session: session)
                }
        }
    }
    
    var lastWeek: [Double] {
        lastWeekDates.map { date in
            sessions
                .filter {
                    $0.isCompleted &&
                    calendar.isDate($0.date, inSameDayAs: date)
                }
                .reduce(0.0) { total, session in
                    total + totalVolume(session: session)
                }
        }
    }
    
    var totalThisWeek: Double {
        volumes.reduce(0, +)
    }
    
    var totalLastWeek: Double {
        lastWeek.reduce(0, +)
    }
    
    var diff: Double {
        totalThisWeek - totalLastWeek
    }
    
    var percentage: Double {
        if totalLastWeek == 0 {
            return totalThisWeek == 0 ? 0 : 100
        }
        return (diff / totalLastWeek) * 100
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
                    .foregroundStyle(diff >= 0 ? Color("Accent") : Color.red)
                
                Text("\(diff >= 0 ? "+" : "")\(Int(percentage))% vs last week")
                    .fontWeight(.semibold)
                    .foregroundStyle(diff >= 0 ? Color("Accent") : .red)
            }
            .font(.footnote)
            .fontWeight(.light)
            
            // chart
            HStack(alignment: .bottom, spacing: 24) {
                
                ForEach(volumes.indices, id: \.self) { i in
                    
                    let maxValue = (volumes + lastWeek).max() ?? 1
                    let height = CGFloat(volumes[i] / maxValue) * 120
                    
                    VStack(spacing: 6) {
                        
                        if selectedIndex == i {
                            Text("\(Int(volumes[i]))")
                                .font(.caption2)
                                .foregroundStyle(.white)
                        }
                        
                        RoundedRectangle(cornerRadius: 6)
                            .fill(i == todayIndex() ? Color("Accent") : Color.gray.opacity(0.4))
                            .frame(height: height / 2)
                            .onTapGesture {
                                withAnimation(.easeInOut) {
                                    selectedIndex = (selectedIndex == i ? nil : i)
                                }
                            }
                        
                        Text(dayLabel(i))
                            .font(.caption2)
                            .foregroundStyle(i == todayIndex() ? Color("Accent") : Color("BrandSecondary"))
                            .fontWeight(i == todayIndex() ? .semibold : .regular)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 26)
                    .padding(.top, 12)
                }
            }
        }
        .padding(24)
        .background(Color(#colorLiteral(red: 0.0784, green: 0.0784, blue: 0.0784, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    func totalVolume(session: Session) -> Double {
        session.sessionExercises
            .flatMap { $0.sets }
            .reduce(0.0) { $0 + ($1.weight * Double($1.reps)) }
    }
    
    func dayLabel(_ index: Int) -> String {
        let days = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        return days[index]
    }
    
    func todayIndex() -> Int {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return weekday - 1
    }
}

#Preview {
    WeeklyVolumeCard()
}

//
//  WeekStreak.swift
//  WGG
//
//  Created by Stepanus Imanuel on 01/05/26.
//

import SwiftUI
import _SwiftData_SwiftUI

import SwiftUI
import _SwiftData_SwiftUI

struct WeekStreak: View {
    
    @Binding var selectedTab: Tab
    
    @Query(sort: \Session.date, order: .reverse)
    var sessions: [Session]
    
    let calendar = Calendar.current
    
    var dates: [Date] {
        let start = calendar.dateInterval(of: .weekOfYear, for: Date())!.start
        return (0..<7).map {
            calendar.date(byAdding: .day, value: $0, to: start)!
        }
    }
    
    var totalMinutes: Int {
        let interval = calendar.dateInterval(of: .weekOfYear, for: Date())!
        
        let totalSeconds = sessions
            .filter {
                $0.isCompleted &&
                $0.date >= interval.start &&
                $0.date < interval.end
            }
            .flatMap { $0.sessionExercises }
            .flatMap { $0.sets }
            .reduce(0) { partial, set in
                partial + (set.setDuration ?? 0) + (set.restDuration ?? 0)
            }
        
        return totalSeconds / 60
    }
    
    var currentStreak: Int {
        var streak = 0
        var currentWeek = Date()
        
        while true {
            let interval = calendar.dateInterval(of: .weekOfYear, for: currentWeek)!
            
            let hasWorkout = sessions.contains {
                $0.isCompleted &&
                $0.date >= interval.start &&
                $0.date < interval.end
            }
            
            if hasWorkout {
                streak += 1
                
                currentWeek = calendar.date(
                    byAdding: .weekOfYear,
                    value: -1,
                    to: currentWeek
                )!
            } else {
                break
            }
        }
        
        return streak
    }
    
    var body: some View {
        
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            Button {
                selectedTab = .calendar
            } label: {
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    HStack {
                        
                        Text("My Week")
                            .fontWeight(.bold)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(.bottom, 6)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.subheadline)
                            .foregroundStyle(Color("BrandSecondary"))
                    }
                    
                    HStack(spacing: 0) {
                        
                        ForEach(
                            Array(dates.enumerated()),
                            id: \.offset
                        ) { _, date in
                            
                            let isToday = calendar.isDateInToday(date)
                            
                            let sessionsForDate = sessions.filter {
                                $0.isCompleted &&
                                calendar.isDate($0.date, inSameDayAs: date)
                            }
                            
                            let lastSession = sessionsForDate.sorted {
                                $0.date < $1.date
                            }.last
                            
                            let highlightColor =
                                lastSession?.routine?.themeColor ??
                                lastSession?.sessionExercises.first?.exercise?.themeColor
                            
                            let sessionColors: [Color] = sessionsForDate.compactMap {
                                $0.routine?.themeColor ??
                                $0.sessionExercises.first?.exercise?.themeColor
                            }
                            
                            VStack(spacing: 6) {
                                
                                Text(dayString(from: date))
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color("BrandSecondary"))
                                
                                VStack(spacing: 4) {
                                    
                                    ZStack {

                                        if isToday {

                                            Circle()
                                                .fill(Color("Accent"))
                                                .frame(width: 36, height: 36)

                                        } else {

                                            if let highlightColor {
                                                Circle()
                                                    .fill(highlightColor.opacity(0.22))
                                                    .frame(width: 36, height: 36)
                                            }

                                            Circle()
                                                .stroke(
                                                    highlightColor ?? Color.clear,
                                                    lineWidth: 2
                                                )
                                                .frame(width: 36, height: 36)
                                        }

                                        Text("\(dayNumber(from: date))")
                                            .font(.footnote)
                                            .fontWeight(isToday ? .bold : .regular)
                                            .foregroundStyle(
                                                isToday
                                                ? .black
                                                : (
                                                    highlightColor ??
                                                    Color(
                                                        #colorLiteral(
                                                            red: 0.3364,
                                                            green: 0.3364,
                                                            blue: 0.3364,
                                                            alpha: 1
                                                        )
                                                    )
                                                )
                                            )
                                    }
                                    
                                    HStack(spacing: 3) {
                                        
                                        ForEach(
                                            Array(sessionColors.prefix(4).enumerated()),
                                            id: \.offset
                                        ) { _, color in
                                            
                                            Circle()
                                                .fill(color)
                                                .frame(width: 5, height: 5)
                                        }
                                    }
                                    .frame(height: 6)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
                    HStack {
                        
                        HStack {
                            
                            Image(systemName: "bolt.fill")
                                .fontWeight(.bold)
                                .foregroundStyle(Color("Accent"))
                            
                            VStack(alignment: .leading) {
                                
                                Text("\(currentStreak) weeks")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                
                                Text("current streak")
                                    .font(.caption)
                                    .foregroundStyle(Color("BrandSecondary"))
                            }
                        }
                        
                        Spacer()
                        
                        HStack {
                            
                            Image(systemName: "clock")
                                .fontWeight(.bold)
                                .foregroundStyle(Color("Accent"))
                            
                            VStack(alignment: .leading) {
                                
                                Text("\(totalMinutes)")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                
                                Text("minutes")
                                    .font(.caption)
                                    .foregroundStyle(Color("BrandSecondary"))
                            }
                        }
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(
                                Color(
                                    #colorLiteral(
                                        red: 0.1777858436,
                                        green: 0.1777858436,
                                        blue: 0.1777858436,
                                        alpha: 1
                                    )
                                )
                            ),
                        
                        alignment: .top
                    )
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            Color("Accent").opacity(0.15),
                            lineWidth: 2.5
                        )
                )
            }
        }
    }
    
    func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    func dayNumber(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}

#Preview {
    WeekStreak(selectedTab: .constant(.home))
}

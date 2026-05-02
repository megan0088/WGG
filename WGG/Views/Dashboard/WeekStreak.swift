//
//  WeekStreak.swift
//  WGG
//
//  Created by Stepanus Imanuel on 01/05/26.
//

import SwiftUI

struct WeekStreak: View {
    let dates = DashboardData.thisWeekDates
    let workouts = DashboardData.workoutDates
    
    let calendar = Calendar.current
    
    var body: some View {
        
        ZStack {
            // background
            Color.black
                .ignoresSafeArea()
            
            NavigationLink(destination: CalendarView()) {
                VStack(alignment: .leading, spacing: 12) {
                    //title
                    HStack {
                        Text("My Week")
                            .fontWeight(.bold)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(.bottom, 6)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.subheadline)
                            .foregroundStyle(Color("Secondary"))
                    }
                    
                    // calendar
                    HStack(spacing: 0) {
                        ForEach(dates, id: \.self) { date in
                            
                            let isToday = calendar.isDateInToday(date)
                            let workoutType = workouts.first {
                                calendar.isDate($0.key, inSameDayAs: date)
                            }?.value
                            
                            
                            VStack(spacing: 6) {
                                
                                // hari
                                Text(dayString(from: date))
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color("Secondary"))
                                
                                // tanggal
                                ZStack {
                                    Circle()
                                        .stroke(
                                            workoutType != nil ? Color("Accent") : Color.clear,
                                            lineWidth: 2
                                        )
                                        .frame(width: 36, height: 36)
                                    
                                    if isToday {
                                        Circle()
                                            .fill(Color("Accent").opacity(0.2))
                                            .frame(width: 36, height: 36)
                                    }
                                    
                                    Text("\(dayNumber(from: date))")
                                        .font(.footnote)
                                        .foregroundStyle(
                                            workoutType != nil || isToday ? Color("Accent") : Color(#colorLiteral(red: 0.3364975452, green: 0.3364975452, blue: 0.3364975452, alpha: 1))
                                        )
                                        .fontWeight(isToday ? .bold : .semibold)
                                }
                                
                                // label
                                if let type = workoutType {
                                    Text(type)
                                        .font(.caption2)
                                        .fontWeight(.medium)
                                        .foregroundStyle(Color("Accent"))
                                } else {
                                    Text(" ")
                                        .font(.caption2)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
                    // stats
                    HStack {
                        // week streak
                        HStack {
                            Image(systemName: "bolt.fill")
                                .fontWeight(.bold)
                                .foregroundStyle(Color("Accent"))
                            VStack(alignment: .leading) {
                                Text("\(DashboardData.currentStreakWeeks) weeks")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                Text("current streak")
                                    .font(.caption)
                                    .foregroundStyle(Color("Secondary"))
                            }
                        }
                        
                        Spacer()
                        
                        // workout duration
                        HStack {
                            Image(systemName: "clock")
                                .fontWeight(.bold)
                                .foregroundStyle(Color("Accent"))
                            VStack(alignment: .leading) {
                                Text("\(DashboardData.totalMinutes)")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                Text("minutes")
                                    .font(.caption)
                                    .foregroundStyle(Color("Secondary"))
                            }
                        }
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(Color(#colorLiteral(red: 0.1777858436, green: 0.1777858436, blue: 0.1777858436, alpha: 1))),
                        
                        alignment: .top
                    )
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color("Accent").opacity(0.15), lineWidth: 2.5)
                )
            }
        }
    }
    
    // MARK: - Helpers
        
    // get day name
    func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E" // mon tue dst
        return formatter.string(from: date)
    }
    
    // get day number
    func dayNumber(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d" // 1-31
        return formatter.string(from: date)
    }
}

#Preview {
    WeekStreak()
}

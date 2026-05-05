//
//  WeekStreak.swift
//  WGG
//
//  Created by Stepanus Imanuel on 01/05/26.
//

import SwiftUI
import _SwiftData_SwiftUI

struct WeekStreak: View {
    
    @Binding var selectedTab: Tab
    
    @Query(sort: \Session.date, order: .reverse)
    var sessions: [Session]
    
    let calendar = Calendar.current
    
    var dates: [Date] {
        let start = calendar.dateInterval(of: .weekOfYear, for: Date())!.start
        return (0..<7).map { calendar.date(byAdding: .day, value: $0, to: start)! }
    }
    
    var workouts: [Date: (title: String, color: Color)] {
        var dict: [Date: (String, Color)] = [:]
        
        for session in sessions where session.isCompleted {
            let key = calendar.startOfDay(for: session.date)
            
            let title = session.routine?.title
                .components(separatedBy: " ")
                .first ?? "Workout"
            
            let color =
                session.routine?.themeColor ??
                session.sessionExercises.first?.exercise?.themeColor ??
                .gray
            
            dict[key] = (title, color)
        }
        
        return dict
    }
    
    var totalMinutes: Int {
        let interval = calendar.dateInterval(of: .weekOfYear, for: Date())!
        
        let totalSeconds = sessions
            .filter { $0.isCompleted && $0.date >= interval.start && $0.date < interval.end }
            .flatMap { $0.sessionExercises }
            .flatMap { $0.sets }
            .reduce(0) { partial, set in
                partial + (set.setDuration ?? 0) + (set.restDuration ?? 0)
            }
        
        return Int(totalSeconds / 60)
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
                currentWeek = calendar.date(byAdding: .weekOfYear, value: -1, to: currentWeek)!
            } else {
                break
            }
        }
        
        return streak
    }
    
    var body: some View {
        
        ZStack {
            // background
            Color.black
                .ignoresSafeArea()
            
            Button {
                selectedTab = .calendar
            } label: {
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
                            .foregroundStyle(Color("BrandSecondary"))
                    }
                    
                    // calendar
                    HStack(spacing: 0) {
                        ForEach(dates, id: \.self) { date in
                            
                            let isToday = calendar.isDateInToday(date)
                            let workoutData = workouts.first {
                                calendar.isDate($0.key, inSameDayAs: date)
                            }?.value
                            
                            VStack(spacing: 6) {
                                
                                // hari
                                Text(dayString(from: date))
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color("BrandSecondary"))
                                
                                // tanggal
                                ZStack {
                                    
                                    if let data = workoutData {
                                        Circle()
                                            .fill(data.color.opacity(0.25))
                                            .frame(width: 36, height: 36)
                                    }
                                    
                                    Circle()
                                        .stroke(
                                            workoutData != nil ? (workoutData?.color ?? Color("Accent")) : Color.clear,
                                            lineWidth: 2
                                        )
                                        .frame(width: 36, height: 36)
                                    
                                    if isToday {
                                        Circle()
                                            .fill(workoutData?.color.opacity(0.2) ?? Color("Accent").opacity(0.2))
                                            .frame(width: 36, height: 36)
                                    }
                                    
                                    Text("\(dayNumber(from: date))")
                                        .font(.footnote)
                                        .foregroundStyle(
                                            workoutData != nil || isToday
                                            ? (workoutData?.color ?? Color("Accent"))
                                            : Color(#colorLiteral(red: 0.3364, green: 0.3364, blue: 0.3364, alpha: 1))
                                        )
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
                                Text("\(currentStreak) weeks")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                Text("current streak")
                                    .font(.caption)
                                    .foregroundStyle(Color("BrandSecondary"))
                            }
                        }
                        
                        Spacer()
                        
                        // workout duration
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
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
    
    // get day number
    func dayNumber(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}

#Preview {
    WeekStreak(selectedTab: .constant(.home))
}

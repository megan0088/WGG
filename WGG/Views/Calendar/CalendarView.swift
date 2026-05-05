//
//  CalendarView.swift
//  WGG
//
//  Created by Stepanus Imanuel on 02/05/26.
//

import SwiftUI
import _SwiftData_SwiftUI

struct CalendarView: View {
    
    let calendar = Calendar.current
    
    @Query(sort: \Session.date, order: .reverse)
    var sessions: [Session]
    
    @State private var currentMonth = Date()
    @State private var selectedDate: Date = Date()
    
    var filteredSessions: [Session] {
        sessions.filter{
            calendar.isDate($0.date, equalTo: currentMonth, toGranularity: .month) && $0.isCompleted
        }
    }
    
    var totalVolume: String {
        let volume = filteredSessions.reduce(0.0) { sessionSum, session in
            sessionSum + session.sessionExercises
                .flatMap {$0.sets}
                .reduce(0.0)
            { $0 + (Double($1.reps) * $1.weight) }
        }
        
        return volume >= 1000 ? String(format: "%.1fk", volume / 1000) : "\(Int(volume))"
    }
    
    var avgDuration: String {
        guard !filteredSessions.isEmpty else { return "0m" }
        // durasi latihan + rest
        let totalMinutes = filteredSessions.reduce(0) {
            sum, session in
            
            let seconds = session.sessionExercises
                .flatMap{$0.sets}
                .reduce(0) {
                    $0 + ($1.setDuration ?? 0) +
                    ($1.restDuration ?? 0)
                }
            
            return sum + Int(seconds) / 60
        }
            
        let avg = totalMinutes / filteredSessions.count
        let hours = avg / 60
        let minutes = avg % 60
        return hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 22) {
                    // Header
                    HStack {
                        Button {
                            currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth)!
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .background(Color(white: 0.15))
                                .clipShape(Circle())
                        }
                        .buttonStyle(.plain)
                        
                        Spacer()
                        
                        Text(monthYearString(currentMonth))
                            .font(.title3)
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button {
                            currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth)!
                        } label: {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .background(Color(white: 0.15))
                                .clipShape(Circle()) // Membuat tombol bulat
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical)
                    
                    // stats
                    HStack(spacing: 28) {
                        VStack(spacing: 8) {
                            Text("\(filteredSessions.count)")
                            Text("Sessions")
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundStyle(Color("BrandSecondary"))
                        }
                        Divider()
                                .frame(height: 64)
                                .background(Color("BrandSecondary"))
                        
                        VStack(spacing: 8) {
                            Text(totalVolume)
                            Text("kg total")
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundStyle(Color("BrandSecondary"))
                        }
                        Divider()
                                .frame(height: 64)
                                .background(Color("BrandSecondary"))
                        VStack(spacing: 8) {
                            Text(avgDuration)
                            Text("avg session")
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundStyle(Color("BrandSecondary"))
                        }
                    }
                    .padding(.horizontal, 36)
                    .padding(.vertical, 16)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .font(.title2)
                    .background(Color(#colorLiteral(red: 0.1013579145, green: 0.1013579145, blue: 0.1013579145, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // kalender
                    VStack {
                        // day header
                        HStack {
                            let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                            ForEach(weekdays, id: \.self) { day in
                                Text(day)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Color("BrandSecondary"))
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .padding(.vertical, 8)

                        // grid
                        ZStack(alignment: .top) {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                                let days = daysInMonth()
                                ForEach(0..<days.count, id: \.self) { index in
                                    if let date = days[index] {
                                        let sessionForDate = sessions.first {
                                            $0.isCompleted &&
                                            calendar.isDate($0.date, inSameDayAs: date)
                                        }

                                        let color =
                                            sessionForDate?.routine?.themeColor ??
                                            sessionForDate?.sessionExercises.first?.exercise?.themeColor

                                        DayCell(
                                            date: date,
                                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                                            workoutColor: color

                                        )
                                        .onTapGesture {
                                            selectedDate = date
                                        }
                                    } else {
                                        Color.clear.frame(height: 52)
                                    }
                                }
                            }
                        }
                        .frame(height: 340)
                    }

                    // List Session
                    SessionListView(date: selectedDate)
                }
                .padding(.horizontal)
            }
        }
    }
        
    // format bulan tahun
    func monthYearString(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "MMMM yyyy"
        return f.string(from: date)
    }
    
    //
    func daysInMonth() -> [Date?] {
        // 1 bulan
        let interval = calendar.dateInterval(of: .month, for: currentMonth)!
        
        // tgl 1 hari ke berapa (sun = 1)
        let firstWeekday = calendar.component(.weekday, from: interval.start)
        
        // range hari 1...30/31
        let days = calendar.range(of: .day, in: .month, for: currentMonth)!
        
        // isi kosong di awal sebelum tgl 1
        var result: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        // fill tanggal
        for day in days {
            let date = calendar.date(byAdding: .day, value: day - 1, to: interval.start)!
            result.append(date)
        }
        
        
        return result
    }
    
    // ada workout hari ini?
    func hasWorkout(on date: Date) -> Bool {
        sessions.contains {
            $0.isCompleted && calendar.isDate($0.date, inSameDayAs: date)
        }
    }
}

#Preview {
    CalendarView()
}

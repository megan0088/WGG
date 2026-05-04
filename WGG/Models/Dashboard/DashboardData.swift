//
//  DashboardData.swift
//  WGG
//
//  Created by Stepanus Imanuel on 01/05/26.
//

import Foundation

struct DashboardData {
    static let calendar = Calendar.current
    
    // MARK: - Sessions
    static let sessions: [WorkoutSession] = generateDummySessions()
    
    static func generateDummySessions() -> [WorkoutSession] {
        var all: [WorkoutSession] = []
        
        let today = Date()
        
        // 4 minggu ke belakang
        for weekOffset in 0..<4 {
            
            let baseDate = calendar.date(byAdding: .weekOfYear, value: -weekOffset, to: today)!
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: baseDate)!.start
            
            // PUSH
            all.append(makeSession(
                title: "Push Day",
                date: calendar.date(byAdding: .day, value: 5, to: startOfWeek)!,
                exercises: [
                    makeExercise("Bench Press", "Chest", base: 80 + Double(weekOffset * 2)),
                    makeExercise("Shoulder Press", "Shoulder", base: 40 + Double(weekOffset * 2))
                ]
            ))
            
            // PULL
            all.append(makeSession(
                title: "Pull Day",
                date: calendar.date(byAdding: .day, value: 6, to: startOfWeek)!,
                exercises: [
                    makeExercise("Deadlift", "Back", base: 100 + Double(weekOffset * 5)),
                    makeExercise("Barbell Row", "Back", base: 60 + Double(weekOffset * 3))
                ]
            ))
            
            // LEG
            all.append(makeSession(
                title: "Leg Day",
                date: calendar.date(byAdding: .day, value: 7, to: startOfWeek)!,
                exercises: [
                    makeExercise("Squat", "Leg", base: 80 + Double(weekOffset * 4)),
                    makeExercise("Leg Press", "Leg", base: 120 + Double(weekOffset * 5))
                ]
            ))
            
//            all.append(makeSession(
//                title: "Leg Day",
//                date: calendar.date(byAdding: .day, value: 6, to: startOfWeek)!,
//                exercises: [
//                    makeExercise("Squat", "Leg", base: 80 + Double(weekOffset * 4)),
//                    makeExercise("Lunges", "Leg", base: 10 + Double(weekOffset * 5))
//                ]
//            ))
        }
        
        // cek bolong 1 minggu latihan
//        let intervalMingguKedua = calendar.dateInterval(of: .weekOfYear, for: calendar.date(byAdding: .weekOfYear, value: -1, to: today)!)!
//
//        all.removeAll { session in
//            session.date >= intervalMingguKedua.start && session.date < intervalMingguKedua.end
//        }
//        
//        print(all)
        
        return all
    }
    
    static func makeSession(title: String, date: Date, exercises: [ExerciseDetail]) -> WorkoutSession {
        WorkoutSession(title: title, date: date, exercises: exercises)
    }
    
    static func makeExercise(_ name: String, _ muscle: String, base: Double) -> ExerciseDetail {
        ExerciseDetail(
            name: name,
            muscle: muscle,
            sets: [
                ExerciseSet(reps: 10, weight: base, rest: 60),
                ExerciseSet(reps: 8, weight: base + 5, rest: 75),
                ExerciseSet(reps: 6, weight: base + 10, rest: 90)
            ],
            duration: Int.random(in: 20...50)
        )
    }
    
    // MARK: - Week Dates (current week)
    static var thisWeekDates: [Date] {
        let start = calendar.dateInterval(of: .weekOfYear, for: Date())!.start
        return (0..<7).map { calendar.date(byAdding: .day, value: $0, to: start)! }
    }
    
    // MARK: - Workout per Date
    static var workoutDates: [Date: String] {
        var dict: [Date: String] = [:]
        
        for s in sessions {
            let key = calendar.startOfDay(for: s.date)
            dict[key] = s.title.components(separatedBy: " ").first
        }
        
        return dict
    }
    
    // MARK: - Last Session
    static var lastSession: WorkoutSession? {
        sessions.sorted { $0.date > $1.date }.first
    }
    
    // MARK: - Calculations
    static func totalVolume(session: WorkoutSession) -> Double {
        session.exercises.flatMap { $0.sets }
            .reduce(0) { $0 + ($1.weight * Double($1.reps)) }
    }
    
    static func totalSets(session: WorkoutSession) -> Int {
        session.exercises.reduce(0) { $0 + $1.sets.count }
    }
    
    static func totalDuration(session: WorkoutSession) -> Int {
        session.exercises.reduce(0) { $0 + $1.duration }
    }
    
    // MARK: - Weekly Volume (current week)
    static var weeklyVolume: [Double] {
        thisWeekDates.map { date in
            sessions
                .filter { calendar.isDate($0.date, inSameDayAs: date) }
                .reduce(0) { $0 + totalVolume(session: $1) }
        }
    }
    
    // MARK: - Last Week Volume
    static var lastWeekDates: [Date] {
        let start = calendar.dateInterval(of: .weekOfYear, for: Date())!.start
        let lastWeekStart = calendar.date(byAdding: .weekOfYear, value: -1, to: start)!
        
        return (0..<7).map {
            calendar.date(byAdding: .day, value: $0, to: lastWeekStart)!
        }
    }

    static var lastWeekVolume: [Double] {
        lastWeekDates.map { date in
            sessions
                .filter { calendar.isDate($0.date, inSameDayAs: date) }
                .reduce(0) { $0 + totalVolume(session: $1) }
        }
    }
    
    // MARK: - Total Minutes (all sessions)
    static var totalMinutes: Int {
        sessions.reduce(0) { $0 + totalDuration(session: $1) }
    }
    
    // MARK: - Week Streak
    static var currentStreakWeeks: Int {
        
        var streak = 0
        var currentWeek = Date()
        
        while true {
            let interval = calendar.dateInterval(of: .weekOfYear, for: currentWeek)!
            
            let hasWorkout = sessions.contains {
                $0.date >= interval.start && $0.date < interval.end
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
    
    // MARK: - Muscle Focus
    
    static var muscleFocus: [String: Double] {
        
        let thisMonth = calendar.component(.month, from: Date())
        let thisYear = calendar.component(.year, from: Date())
        
        var dict: [String: Double] = [:]
        
        for session in sessions {
            let m = calendar.component(.month, from: session.date)
            let y = calendar.component(.year, from: session.date)
            
            if m == thisMonth && y == thisYear {
                for ex in session.exercises {
                    let volume = ex.sets.reduce(0) { $0 + ($1.weight * Double($1.reps)) }
                    dict[ex.muscle, default: 0] += volume
                }
            }
        }
        
        let total = dict.values.reduce(0, +)
        
        return dict.mapValues { ($0 / total) * 100 }
    }
    
    // MARK: - recent PRs
    static var recentPRRecords: [(name: String, weight: Double, diff: Double, daysAgo: Int)] {
        let allExerciseNames = Set(sessions.flatMap { $0.exercises.map { $0.name } })
        
        return allExerciseNames.compactMap { name in
            // 1. Ambil semua set dan tanggal sesi untuk exercise ini
            let exerciseOccurrences = sessions.flatMap { session in
                session.exercises
                    .filter { $0.name == name }
                    .map { (date: session.date, weights: $0.sets.map { $0.weight }) }
            }
            
            // 2. Dapatkan semua list berat badan dan urutkan untuk cari 2 terbaik
            let allWeights = exerciseOccurrences.flatMap { $0.weights }.sorted(by: >)
            guard let best = allWeights.first else { return nil }
            let secondBest = allWeights.count > 1 ? allWeights[1] : best
            
            // 3. Cari tanggal terbaru exercise ini dilakukan untuk 'daysAgo'
            let latestDate = exerciseOccurrences.map { $0.date }.max() ?? Date()
            let diffDays = calendar.dateComponents([.day], from: latestDate, to: Date()).day ?? 0
            
            return (name: name, weight: best, diff: best - secondBest, daysAgo: abs(diffDays))
        }
    }
}

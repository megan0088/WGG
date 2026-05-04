//
//  MockAnalyticsData.swift
//  WGG
//
//  Created by Filbert Naldo Wijaya on 03/05/26.
//

import Foundation

struct MockAnalyticsData {
    static let calendar = Calendar.current
    
    static func createDate(day: Int, month: Int, year: Int) -> Date {
        return calendar.date(from: DateComponents(year: year, month: month, day: day)) ?? Date()
    }
    
    static let allSessions: [WorkoutSession2] = [
        WorkoutSession2(date: createDate(day: 15, month: 10, year: 2025), exercises: [
            ExerciseEntry(exerciseName: "Bench Press", sets: [
                WorkoutSet(setNumber: 1, reps: 8, weight: 12.5),
                WorkoutSet(setNumber: 2, reps: 10, weight: 15),
                WorkoutSet(setNumber: 3, reps: 10, weight: 15),
                WorkoutSet(setNumber: 4, reps: 12, weight: 17.5),
            ]),
            ExerciseEntry(exerciseName: "Dumbell Fly", sets: [
                WorkoutSet(setNumber: 1, reps: 8, weight: 12.5),
                WorkoutSet(setNumber: 2, reps: 10, weight: 15),
                WorkoutSet(setNumber: 3, reps: 10, weight: 15),
                WorkoutSet(setNumber: 4, reps: 12, weight: 17.5),
            ])
        ]),
        WorkoutSession2(date: createDate(day: 2, month: 3, year: 2026), exercises: [
            ExerciseEntry(exerciseName: "Bench Press", sets: [
                WorkoutSet(setNumber: 1, reps: 8, weight: 22.5),
                WorkoutSet(setNumber: 2, reps: 10, weight: 25),
                WorkoutSet(setNumber: 3, reps: 10, weight: 25),
                WorkoutSet(setNumber: 4, reps: 12, weight: 27.5),
            ]),
            ExerciseEntry(exerciseName: "Dumbell Fly", sets: [
                WorkoutSet(setNumber: 1, reps: 8, weight: 22.5),
                WorkoutSet(setNumber: 2, reps: 10, weight: 25),
                WorkoutSet(setNumber: 3, reps: 10, weight: 25),
                WorkoutSet(setNumber: 4, reps: 12, weight: 27.5),
            ])
        ]),
        WorkoutSession2(date: createDate(day: 7, month: 4, year: 2026), exercises: [
            ExerciseEntry(exerciseName: "Bench Press", sets: [
                WorkoutSet(setNumber: 1, reps: 8, weight: 22.5),
                WorkoutSet(setNumber: 2, reps: 10, weight: 25),
                WorkoutSet(setNumber: 3, reps: 10, weight: 25),
                WorkoutSet(setNumber: 4, reps: 12, weight: 27.5),
            ]),
            ExerciseEntry(exerciseName: "Dumbell Fly", sets: [
                WorkoutSet(setNumber: 1, reps: 8, weight: 25),
                WorkoutSet(setNumber: 2, reps: 10, weight: 25),
                WorkoutSet(setNumber: 3, reps: 10, weight: 30),
                WorkoutSet(setNumber: 4, reps: 12, weight: 30),
            ])
        ]),
        WorkoutSession2(date: createDate(day: 12, month: 4, year: 2026), exercises: [
            ExerciseEntry(exerciseName: "Bench Press", sets: [
                WorkoutSet(setNumber: 1, reps: 8, weight: 32.5),
                WorkoutSet(setNumber: 2, reps: 10, weight: 35),
                WorkoutSet(setNumber: 3, reps: 10, weight: 35),
                WorkoutSet(setNumber: 4, reps: 12, weight: 37.5),
            ]),
            ExerciseEntry(exerciseName: "Dumbell Fly", sets: [
                WorkoutSet(setNumber: 1, reps: 8, weight: 25),
                WorkoutSet(setNumber: 2, reps: 10, weight: 25),
                WorkoutSet(setNumber: 3, reps: 10, weight: 30),
                WorkoutSet(setNumber: 4, reps: 12, weight: 30),
            ])
        ]),
        WorkoutSession2(date: createDate(day: 17, month: 4, year: 2026), exercises: [
            ExerciseEntry(exerciseName: "Bench Press", sets: [
                WorkoutSet(setNumber: 1, reps: 8, weight: 42.5),
                WorkoutSet(setNumber: 2, reps: 10, weight: 45),
                WorkoutSet(setNumber: 3, reps: 10, weight: 45),
                WorkoutSet(setNumber: 4, reps: 12, weight: 47.5),
            ]),
            ExerciseEntry(exerciseName: "Dumbell Fly", sets: [
                WorkoutSet(setNumber: 1, reps: 8, weight: 32.5),
                WorkoutSet(setNumber: 2, reps: 10, weight: 35),
                WorkoutSet(setNumber: 3, reps: 10, weight: 35),
                WorkoutSet(setNumber: 4, reps: 12, weight: 37.5),
            ])
        ]),
        WorkoutSession2(date: createDate(day: 23, month: 4, year: 2026), exercises: [
            ExerciseEntry(exerciseName: "Bench Press", sets: [
                WorkoutSet(setNumber: 1, reps: 8, weight: 42.5),
                WorkoutSet(setNumber: 2, reps: 10, weight: 45),
                WorkoutSet(setNumber: 3, reps: 10, weight: 45),
                WorkoutSet(setNumber: 4, reps: 12, weight: 47.5),
            ]),
            ExerciseEntry(exerciseName: "Dumbell Fly", sets: [
                WorkoutSet(setNumber: 1, reps: 8, weight: 22.5),
                WorkoutSet(setNumber: 2, reps: 10, weight: 45),
                WorkoutSet(setNumber: 3, reps: 10, weight: 45),
                WorkoutSet(setNumber: 4, reps: 12, weight: 47.5),
            ])
        ]),
        WorkoutSession2(date: createDate(day: 27, month: 4, year: 2026), exercises: [
            ExerciseEntry(exerciseName: "Bench Press", sets: [
                WorkoutSet(setNumber: 1, reps: 8, weight: 52.5),
                WorkoutSet(setNumber: 2, reps: 10, weight: 55),
                WorkoutSet(setNumber: 3, reps: 10, weight: 55),
                WorkoutSet(setNumber: 4, reps: 12, weight: 57.5),
            ])
        ]),
        WorkoutSession2(date: createDate(day: 29, month: 4, year: 2026), exercises: [
            ExerciseEntry(exerciseName: "Bench Press", sets: [
                WorkoutSet(setNumber: 1, reps: 8, weight: 52.5),
                WorkoutSet(setNumber: 2, reps: 10, weight: 55),
                WorkoutSet(setNumber: 3, reps: 10, weight: 55),
                WorkoutSet(setNumber: 4, reps: 14, weight: 57.5),
            ])
        ])
    ]
}

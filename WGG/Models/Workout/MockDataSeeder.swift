//
//  MockDataSeeder.swift
//  WGG
//
//  Created by Filbert Naldo Wijaya on 05/05/26.
//

import Foundation
import SwiftData

struct MockDataSeeder {

    // One time seeder initialization
    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Session>()
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }

        seed(context: context)
    }

    // Seeder
    private static func seed(context: ModelContext) {
        let calendar = Calendar.current
        let today = Date()

        // Exercise
        let pullUp         = Exercise(name: "Pull Up",                muscleGroup: "Back")
        let bentOverRow    = Exercise(name: "Bent Over Row",          muscleGroup: "Back")
        let latPulldown    = Exercise(name: "Lat Pulldown",           muscleGroup: "Back")
        let dumbbellRow    = Exercise(name: "Dumbbell Row",           muscleGroup: "Back")

        let benchPress     = Exercise(name: "Bench Press",            muscleGroup: "Chest")
        let inclinePress   = Exercise(name: "Incline Dumbbell Press", muscleGroup: "Chest")
        let dumbbellFly    = Exercise(name: "Dumbbell Fly",           muscleGroup: "Chest")

        let overheadPress  = Exercise(name: "Overhead Press",         muscleGroup: "Shoulders")
        let lateralRaises  = Exercise(name: "Lateral Raises",         muscleGroup: "Shoulders")
        let dumbShoulderP  = Exercise(name: "Dumbbell Shoulder Press",muscleGroup: "Shoulders")

        let barbellCurl    = Exercise(name: "Barbell Curl",           muscleGroup: "Arms")
        let dumbbellCurl   = Exercise(name: "Dumbbell Curl",          muscleGroup: "Arms")
        let dumbbellBicep  = Exercise(name: "Dumbbell Bicep Curl",    muscleGroup: "Arms")

        let squat          = Exercise(name: "Squat",                  muscleGroup: "Legs")
        let legPress       = Exercise(name: "Leg Press",              muscleGroup: "Legs")
        let legCurl        = Exercise(name: "Leg Curl",               muscleGroup: "Legs")
        let legExtension   = Exercise(name: "Leg Extension",          muscleGroup: "Legs")

        let allExercises: [Exercise] = [
            pullUp, bentOverRow, latPulldown, dumbbellRow,
            benchPress, inclinePress, dumbbellFly,
            overheadPress, lateralRaises, dumbShoulderP,
            barbellCurl, dumbbellCurl, dumbbellBicep,
            squat, legPress, legCurl, legExtension
        ]
        allExercises.forEach { context.insert($0) }

        // Routine
        let pullRoutine = Routine(title: "Pull Day", exercises: [pullUp, bentOverRow, latPulldown, dumbbellRow])
        let pushRoutine = Routine(title: "Push Day", exercises: [benchPress, inclinePress, dumbbellFly, overheadPress, lateralRaises])
        let legRoutine  = Routine(title: "Leg Day", exercises: [squat, legPress, legCurl, legExtension])
        let armRoutine  = Routine(title: "Arm Day", exercises: [barbellCurl, dumbbellCurl, dumbbellBicep])

        [pullRoutine, pushRoutine, legRoutine, armRoutine].forEach { context.insert($0) }

        // Session
        for weekOffset in (0..<12).reversed() {
            let baseProgress = Double(11 - weekOffset)
            let randomFluctuation = Double.random(in: -1.5...2.0)
            let progressFactor = max(0, (baseProgress * 0.8) + randomFluctuation)

            guard let baseDate = calendar.date(byAdding: .weekOfYear, value: -weekOffset, to: today),
                  let weekStart = calendar.dateInterval(of: .weekOfYear, for: baseDate)?.start
            else { continue }

            let day: (Int) -> Date = { offset in
                calendar.date(byAdding: .day, value: offset, to: weekStart) ?? weekStart
            }

            // Pull day
            let pullPlan: [MockDataSeeder.ExercisePlan] = [
                ExercisePlan(exercise: pullUp, sets: [
                    (reps: 8,  weight: 0),
                    (reps: 8,  weight: 0),
                    (reps: 7,  weight: 0),
                    (reps: 6,  weight: 0)
                ]),
                ExercisePlan(exercise: bentOverRow, sets: [
                    (reps: 10, weight: 50 + progressFactor * 2.5),
                    (reps: 8,  weight: 55 + progressFactor * 2.5),
                    (reps: 8,  weight: 60 + progressFactor * 2.5),
                    (reps: 6,  weight: 62.5 + progressFactor * 2.5)
                ]),
                ExercisePlan(exercise: latPulldown, sets: [
                    (reps: 12, weight: 45 + progressFactor * 2),
                    (reps: 10, weight: 50 + progressFactor * 2),
                    (reps: 8,  weight: 55 + progressFactor * 2)
                ]),
                ExercisePlan(exercise: dumbbellRow, sets: [
                    (reps: 12, weight: 20 + progressFactor * 1),
                    (reps: 10, weight: 22.5 + progressFactor * 1),
                    (reps: 8,  weight: 25 + progressFactor * 1)
                ])
            ]
            makeSession(routine: pullRoutine, date: day(1), plans: pullPlan, context: context)

            // Push day
            let pushPlan: [MockDataSeeder.ExercisePlan] = [
                ExercisePlan(exercise: benchPress, sets: [
                    (reps: 10, weight: 60 + progressFactor * 3),
                    (reps: 8,  weight: 65 + progressFactor * 3),
                    (reps: 6,  weight: 70 + progressFactor * 3),
                    (reps: 6,  weight: 72.5 + progressFactor * 3)
                ]),
                ExercisePlan(exercise: inclinePress, sets: [
                    (reps: 12, weight: 20 + progressFactor * 1),
                    (reps: 10, weight: 22.5 + progressFactor * 1),
                    (reps: 8,  weight: 25 + progressFactor * 1)
                ]),
                ExercisePlan(exercise: dumbbellFly, sets: [
                    (reps: 12, weight: 12.5 + progressFactor * 0.5),
                    (reps: 10, weight: 15 + progressFactor * 0.5),
                    (reps: 8,  weight: 17.5 + progressFactor * 0.5)
                ]),
                ExercisePlan(exercise: overheadPress, sets: [
                    (reps: 10, weight: 35 + progressFactor * 1.5),
                    (reps: 8,  weight: 37.5 + progressFactor * 1.5),
                    (reps: 8,  weight: 40 + progressFactor * 1.5)
                ]),
                ExercisePlan(exercise: lateralRaises, sets: [
                    (reps: 15, weight: 8 + progressFactor * 0.5),
                    (reps: 12, weight: 10 + progressFactor * 0.5),
                    (reps: 10, weight: 12 + progressFactor * 0.5)
                ])
            ]
            makeSession(routine: pushRoutine, date: day(3), plans: pushPlan, context: context)

            // Leg day
            let legPlan: [MockDataSeeder.ExercisePlan] = [
                ExercisePlan(exercise: squat, sets: [
                    (reps: 10, weight: 70 + progressFactor * 4),
                    (reps: 8,  weight: 80 + progressFactor * 4),
                    (reps: 6,  weight: 90 + progressFactor * 4),
                    (reps: 6,  weight: 92.5 + progressFactor * 4)
                ]),
                ExercisePlan(exercise: legPress, sets: [
                    (reps: 12, weight: 100 + progressFactor * 5),
                    (reps: 10, weight: 110 + progressFactor * 5),
                    (reps: 8,  weight: 120 + progressFactor * 5)
                ]),
                ExercisePlan(exercise: legCurl, sets: [
                    (reps: 12, weight: 30 + progressFactor * 1),
                    (reps: 10, weight: 35 + progressFactor * 1),
                    (reps: 8,  weight: 40 + progressFactor * 1)
                ]),
                ExercisePlan(exercise: legExtension, sets: [
                    (reps: 12, weight: 35 + progressFactor * 1),
                    (reps: 10, weight: 40 + progressFactor * 1),
                    (reps: 8,  weight: 45 + progressFactor * 1)
                ])
            ]
            makeSession(routine: legRoutine, date: day(5), plans: legPlan, context: context)

            // Arm day
            if weekOffset % 2 == 0 {
                let armPlan: [MockDataSeeder.ExercisePlan] = [
                    ExercisePlan(exercise: barbellCurl, sets: [
                        (reps: 10, weight: 25 + progressFactor * 1),
                        (reps: 8,  weight: 27.5 + progressFactor * 1),
                        (reps: 8,  weight: 30 + progressFactor * 1)
                    ]),
                    ExercisePlan(exercise: dumbbellCurl, sets: [
                        (reps: 12, weight: 10 + progressFactor * 0.5),
                        (reps: 10, weight: 12 + progressFactor * 0.5),
                        (reps: 8,  weight: 14 + progressFactor * 0.5)
                    ]),
                    ExercisePlan(exercise: dumbbellBicep, sets: [
                        (reps: 12, weight: 8 + progressFactor * 0.5),
                        (reps: 10, weight: 10 + progressFactor * 0.5),
                        (reps: 8,  weight: 12 + progressFactor * 0.5)
                    ])
                ]
                makeSession(routine: armRoutine, date: day(4), plans: armPlan, context: context)
            }
        }

        try? context.save()
    }

    // Helper
    private static func makeSession(routine: Routine, date: Date, plans: [ExercisePlan], context: ModelContext) {
        // Prevent creating future session
        guard date <= Date() else { return }

        let session = Session(date: date, routine: routine)
        session.isCompleted = true
        context.insert(session)

        for plan in plans {
            let sessionEx = SessionExercise(session: session, exercise: plan.exercise)
            context.insert(sessionEx)
            session.sessionExercises.append(sessionEx)

            for (index, spec) in plan.sets.enumerated() {
                let set = SessionSet(setNumber: index + 1, reps: spec.reps, weight: spec.weight)
                set.isCompleted = true
                set.setDuration = Double.random(in: 30...90)
                set.restDuration = Double.random(in: 60...120)
                context.insert(set)
                sessionEx.sets.append(set)
            }
        }
    }

    private struct ExercisePlan {
        let exercise: Exercise
        let sets: [(reps: Int, weight: Double)]
    }
}

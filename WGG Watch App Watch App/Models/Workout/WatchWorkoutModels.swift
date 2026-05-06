import Foundation

struct WatchExercise: Identifiable {
    let id = UUID()
    let name: String
    let muscleGroup: String
    var targetWeight: Double = 0
    var targetReps: Int = 8
}

struct WatchRoutine: Identifiable {
    let id = UUID()
    let name: String
    let exercises: [WatchExercise]
}

struct WatchLoggedSet {
    var setNumber: Int
    var reps: Int
    var weight: Double
    var setDuration: Double = 0
    var restDuration: Double = 0
}

struct WatchLoggedExercise: Identifiable {
    let id = UUID()
    var name: String
    var muscleGroup: String
    var sets: [WatchLoggedSet]
}

extension WatchRoutine {
    static let mock = WatchRoutine(
        name: "Pull Day",
        exercises: [
            WatchExercise(name: "Pull Up", muscleGroup: "Back"),
            WatchExercise(name: "Bent Over Row", muscleGroup: "Back"),
            WatchExercise(name: "Lat Pulldown", muscleGroup: "Back"),
            WatchExercise(name: "Dumbbell Row", muscleGroup: "Back")
        ]
    )

    static let mockRoutines: [WatchRoutine] = [
        WatchRoutine(name: "Pull Day", exercises: [
            WatchExercise(name: "Pull Up", muscleGroup: "Back"),
            WatchExercise(name: "Bent Over Row", muscleGroup: "Back"),
            WatchExercise(name: "Lat Pulldown", muscleGroup: "Back"),
            WatchExercise(name: "Dumbbell Row", muscleGroup: "Back")
        ]),
        WatchRoutine(name: "Push Day", exercises: [
            WatchExercise(name: "Bench Press", muscleGroup: "Chest"),
            WatchExercise(name: "Incline Dumbbell Press", muscleGroup: "Chest"),
            WatchExercise(name: "Dumbbell Fly", muscleGroup: "Chest"),
            WatchExercise(name: "Overhead Press", muscleGroup: "Shoulders"),
            WatchExercise(name: "Lateral Raises", muscleGroup: "Shoulders")
        ]),
        WatchRoutine(name: "Leg Day", exercises: [
            WatchExercise(name: "Squat", muscleGroup: "Legs"),
            WatchExercise(name: "Leg Press", muscleGroup: "Legs"),
            WatchExercise(name: "Leg Curl", muscleGroup: "Legs"),
            WatchExercise(name: "Leg Extension", muscleGroup: "Legs")
        ]),
        WatchRoutine(name: "Arm Day", exercises: [
            WatchExercise(name: "Barbell Curl", muscleGroup: "Arms"),
            WatchExercise(name: "Dumbbell Curl", muscleGroup: "Arms"),
            WatchExercise(name: "Dumbbell Bicep Curl", muscleGroup: "Arms")
        ])
    ]
}

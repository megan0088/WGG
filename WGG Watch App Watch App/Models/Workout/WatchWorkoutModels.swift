//
//  WorkoutWatc.swift
//  WGG
//
//  Created by Muhamad Ega Nugraha on 03/05/26.
//

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

extension WatchRoutine {
    static let mock = WatchRoutine(
        name: "Pull Day",
        exercises: [
            WatchExercise(name: "Pull Up", muscleGroup: "Back"),
            WatchExercise(name: "Bent Over Row", muscleGroup: "Back"),
            WatchExercise(name: "Lat Pulldown", muscleGroup: "Back"),
            WatchExercise(name: "Cable Row", muscleGroup: "Back")
        ]
    )
}

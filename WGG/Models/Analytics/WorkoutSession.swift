//
//  ExerciseSession.swift
//  WGG
//
//  Created by Filbert Naldo Wijaya on 03/05/26.
//

import Foundation

struct WorkoutSession: Identifiable {
    let id = UUID()
    let date: Date
    let exercises: [ExerciseEntry]
}

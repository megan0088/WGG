//
//  Exercise.swift
//  WGG
//
//  Created by George Maximillian Theodore on 02/05/26.
//

import Foundation
import SwiftUI

struct Exercise: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let muscleGroup: String
    
    var themeColor: Color {
        switch muscleGroup {
        case "Back":
            return .red
        case "Chest":
            return .blue
        case "Shoulders":
            return .yellow
        case "Arms":
            return .orange
        case "Legs":
            return .green
        default:
            return .gray
        }
    }
}

extension Exercise {
    static let exerciseList: [Exercise] = [
        Exercise(name: "Pull Up", muscleGroup: "Back"),
        Exercise(name: "Bent Over Row", muscleGroup: "Back"),
        Exercise(name: "Incline Dumbbell Press", muscleGroup: "Chest"),
        Exercise(name: "Overhead Press", muscleGroup: "Shoulders"),
        Exercise(name: "Lateral Raises", muscleGroup: "Shoulders"),
        Exercise(name: "Barbell Curl", muscleGroup: "Arms"),
        Exercise(name: "Dumbbell Curl", muscleGroup: "Arms"),
        Exercise(name: "Dumbbell Row", muscleGroup: "Back"),
        Exercise(name: "Dumbbell Shoulder Press", muscleGroup: "Shoulders"),
        Exercise(name: "Dumbbell Bicep Curl", muscleGroup: "Arms"),
        Exercise(name: "Leg Press", muscleGroup: "Legs"),
        Exercise(name: "Leg Curl", muscleGroup: "Legs"),
        Exercise(name: "Leg Extension", muscleGroup: "Legs")
    ]
}

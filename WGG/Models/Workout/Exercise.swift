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
            return Color(#colorLiteral(red: 0.3566055894, green: 0.8337495923, blue: 0.8115138412, alpha: 1))
        case "Chest":
            return Color(#colorLiteral(red: 1, green: 0.5114634037, blue: 0.4935014248, alpha: 1))
        case "Shoulders":
            return Color(#colorLiteral(red: 0.7158692479, green: 0.6330819726, blue: 0.9852458835, alpha: 1))
        case "Arms":
            return Color(#colorLiteral(red: 0.9893369079, green: 0.5322159529, blue: 0.1008731201, alpha: 1))
        case "Legs":
            return Color(#colorLiteral(red: 1, green: 0.9019607843, blue: 0.4274509804, alpha: 1))
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

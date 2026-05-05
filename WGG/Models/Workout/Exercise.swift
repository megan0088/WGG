//
//  Exercise.swift
//  WGG
//
//  Created by George Maximillian Theodore on 02/05/26.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Exercise: Identifiable {
    var id: UUID = UUID()
    var name: String
    var muscleGroup: String
    
    var routines: [Routine] = []
    
    var sessionExercises: [SessionExercise] = []
    
    init(name: String, muscleGroup: String) {
        self.name = name
        self.muscleGroup = muscleGroup
    }
    
    @Transient
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

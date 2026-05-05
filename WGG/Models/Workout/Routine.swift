//
//  Routine.swift
//  WGG
//
//  Created by George Maximillian Theodore on 02/05/26.
//

import SwiftUI
import Foundation
import SwiftData

@Model
class Routine: Identifiable {
    var id: UUID = UUID()
    var title: String
    
    var sessions: [Session] = []
    
    @Relationship(inverse: \Exercise.routines)
    var exercises: [Exercise] = []
    
    init(title: String, exercises: [Exercise] = []) {
        self.title = title
        self.exercises = exercises
    }
    
    @Transient
    var themeColor: Color {
        if exercises.isEmpty {
            return .gray
        }
        
        var groupCounts: [String: Int] = [:]
        for exercise in exercises {
            groupCounts[exercise.muscleGroup, default: 0] += 1
        }
        
        let dominantGroup = groupCounts.max { a, b in a.value < b.value }?.key
        
        let dominantExercise = exercises.first { $0.muscleGroup == dominantGroup }
        
        return dominantExercise?.themeColor ?? .gray
    }
    
    @Transient
    var exercisesCount: Int {
        return exercises.count
    }
    
    @Transient
    var muscleGroups: [String] {
        let allGroups = exercises.map{ $0.muscleGroup }
        let uniqueGroups = Array(Set(allGroups)).sorted()
        return uniqueGroups
    }
    
    @Transient
    var subtitle: String {
        if exercises.isEmpty {
            return "No exercises yet"
        }
        let groupsText = muscleGroups.joined(separator: " · ")
        return "\(groupsText) · \(exercisesCount) exercises"
    }
}

//extension Routine {
//    static let dummyRoutine: [Routine] = [
//        Routine(
//            title: "Pull Day",
//            themeColorName: "red",
//            exercises: [
//                Exercise(name: "Pull Up", muscleGroup: "Back"),
//                Exercise(name: "Bent Over Row", muscleGroup: "Back"),
//                Exercise(name: "Lat Pulldown", muscleGroup: "Back"),
//                Exercise(name: "Cable Row", muscleGroup: "Back")
//            ]
//        ),
//        Routine(
//            title: "Push Day",
//            themeColorName: "blue"
//        ),
//        Routine(
//            title: "Leg Day",
//            themeColorName: "green"
//        ),
//        Routine(
//            title: "Full Body",
//            themeColorName: "orange"
//        )
//    ]
//}

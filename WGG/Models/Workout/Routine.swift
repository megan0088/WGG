//
//  Routine.swift
//  WGG
//
//  Created by George Maximillian Theodore on 02/05/26.
//

import SwiftUI
import Foundation

@Observable
class Routine: Identifiable {
    let id = UUID()
    var title: String
    var themeColor: Color
    
    var exercises: [Exercise] = []
    
    init(title: String, themeColor: Color, exercises: [Exercise] = []) {
        self.title = title
        self.themeColor = themeColor
        self.exercises = exercises
    }
    
    var exercisesCount: Int {
        return exercises.count
    }
    
    var muscleGroups: [String] {
        let allGroups = exercises.map{ $0.muscleGroup }
        let uniqueGroups = Array(Set(allGroups)).sorted()
        return uniqueGroups
    }
    
    var subtitle: String {
        if exercises.isEmpty {
            return "No exercises yet"
        }
        let groupsText = muscleGroups.joined(separator: " · ")
        return "\(groupsText) · \(exercisesCount) exercises"
    }
}

extension Routine {
    static let dummyRoutine: [Routine] = [
        Routine(
            title: "Pull Day",
            themeColor: .red,
            exercises: [
                Exercise(name: "Pull Up", muscleGroup: "Back"),
                Exercise(name: "Bent Over Row", muscleGroup: "Back"),
                Exercise(name: "Lat Pulldown", muscleGroup: "Back"),
                Exercise(name: "Cable Row", muscleGroup: "Back")
            ]
        ),
        Routine(
            title: "Push Day",
            themeColor: .blue
        ),
        Routine(
            title: "Leg Day",
            themeColor: .green
        ),
        Routine(
            title: "Full Body",
            themeColor: .orange
        )
    ]
}

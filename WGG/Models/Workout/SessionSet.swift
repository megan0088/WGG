//
//  SessionSet.swift
//  WGG
//
//  Created by George Maximillian Theodore on 05/05/26.
//

import Foundation
import SwiftData

@Model
class SessionSet {
    var id: UUID = UUID()
    var setNumber: Int
    var reps: Int
    var weight: Double
    var setDuration: Int?
    var restDuration: Int?
    
    var isCompleted: Bool = false
    
    var sessionExercise: SessionExercise?
    
    init(setNumber: Int, reps: Int = 0, weight: Double = 0.0) {
        self.setNumber = setNumber
        self.reps = reps
        self.weight = weight
    }
}

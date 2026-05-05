//
//  SessionExercise.swift
//  WGG
//
//  Created by George Maximillian Theodore on 05/05/26.
//

import Foundation
import SwiftData

@Model
class SessionExercise {
    var id: UUID = UUID()
    var isFinished: Bool = false
    
    var session: Session?
    
    @Relationship(inverse: \Exercise.sessionExercises)
    var exercise: Exercise?
    
    @Relationship(deleteRule: .cascade, inverse: \SessionSet.sessionExercise)
    var sets: [SessionSet] = []
    
    init(session: Session? = nil, exercise: Exercise? = nil) {
        self.session = session
        self.exercise = exercise
    }
}

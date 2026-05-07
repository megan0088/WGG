//
//  Session.swift
//  WGG
//
//  Created by George Maximillian Theodore on 05/05/26.
//

import Foundation
import SwiftData

@Model
class Session {
    var id: UUID = UUID()
    var date: Date
    var isCompleted: Bool = false
    var watchSessionId: String? = nil

    @Relationship(inverse: \Routine.sessions)
    var routine: Routine?

    @Relationship(deleteRule: .cascade, inverse: \SessionExercise.session)
    var sessionExercises: [SessionExercise] = []

    init(date: Date = Date(), routine: Routine? = nil) {
        self.date = date
        self.routine = routine
    }
}

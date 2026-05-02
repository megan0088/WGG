//
//  WorkoutSession.swift
//  WGG
//
//  Created by Stepanus Imanuel on 01/05/26.
//

import Foundation

class WorkoutSession: Identifiable {
    let id = UUID()
    
    let title: String
    let date: Date
    var exercises: [Exercise]
    
    init(title: String, date: Date, exercises: [Exercise]) {
        self.title = title
        self.date = date
        self.exercises = exercises
    }
}

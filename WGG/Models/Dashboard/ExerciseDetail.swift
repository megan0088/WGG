//
//  Exercise.swift
//  WGG
//
//  Created by Stepanus Imanuel on 01/05/26.
//

import Foundation
internal import Combine

class ExerciseDetail: Identifiable, ObservableObject {
    let id = UUID()
    
    let name: String
    let muscle: String
    
    @Published var sets: [ExerciseSet]
    let duration: Int
    
    init(name: String, muscle: String, sets: [ExerciseSet], duration: Int) {
        self.name = name
        self.muscle = muscle
        self.sets = sets
        self.duration = duration
    }
}

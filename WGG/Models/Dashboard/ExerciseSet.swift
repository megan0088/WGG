//
//  ExerciseSet.swift
//  WGG
//
//  Created by Stepanus Imanuel on 01/05/26.
//

import Foundation
internal import Combine

class ExerciseSet: Identifiable, ObservableObject {
    let id = UUID()
    
    @Published var reps: Int
    @Published var weight: Double
    @Published var rest: Int // seconds
    
    init(reps: Int, weight: Double, rest: Int) {
        self.reps = reps
        self.weight = weight
        self.rest = rest
    }
}

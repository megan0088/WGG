//
//  WorkoutSet.swift
//  WGG
//
//  Created by Filbert Naldo Wijaya on 03/05/26.
//

import Foundation

struct WorkoutSet: Identifiable {
    let id = UUID()
    let setNumber: Int
    let reps: Int
    let weight: Double
    
    var estimated1RM: Double {
        return weight * (1.0 + Double(reps) / 30.0)
    }
}

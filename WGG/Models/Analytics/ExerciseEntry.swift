//
//  ExerciseEntry.swift
//  WGG
//
//  Created by Filbert Naldo Wijaya on 03/05/26.
//

import Foundation

struct ExerciseEntry: Identifiable {
    let id = UUID()
    let exerciseName: String
    let sets: [WorkoutSet]
    
    var estimated1RM: Double {
        var est: Double = 0.0
        
        for set in sets {
            if set.estimated1RM > est {
                est = set.estimated1RM
            }
        }
        
        return est
    }
    var maxWeight: Double {
        var max: Double = 0.0
        
        for set in sets {
            if set.weight > max {
                max = set.weight
            }
        }
        
        return max
    }
    var volume: Double {
        var total: Double = 0.0
        
        for set in sets {
            let setVolume = Double(set.reps) * Double(set.weight)
            total += setVolume
        }
        
        return total
    }
}

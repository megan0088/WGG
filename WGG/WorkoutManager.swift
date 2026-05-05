//
//  WorkoutManager.swift
//  WGG
//
//  Created by George Maximillian Theodore on 05/05/26.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class WorkoutManager {
    var activeSession: Session?
    
    var currentExercise: SessionExercise?
    
    var showRestTimer: Bool = false
    
    // MARK: - 1. Start Workout
    func startWorkout(from routine: Routine, context: ModelContext) {
        let newSession = Session(routine: routine)
        
        for masterEx in routine.exercises {
            let sessionEx = SessionExercise(session: newSession, exercise: masterEx)
            
            // Otomatis buatkan Set ke-1 yang masih kosong
            let firstSet = SessionSet(setNumber: 1, reps: 0, weight: 0.0)
            sessionEx.sets.append(firstSet)
            
            newSession.sessionExercises.append(sessionEx)
        }
        
        context.insert(newSession)
        
        self.activeSession = newSession
        self.currentExercise = newSession.sessionExercises.first
    }
    
    // MARK: - 2. Log Set
    func completeActiveSet(weight: Double, reps: Int) {
        guard let currentEx = currentExercise else { return }
        
        if let activeSet = currentEx.sets.sorted(by: { $0.setNumber < $1.setNumber }).first(where: { !$0.isCompleted }) {
            
            activeSet.weight = weight
            activeSet.reps = reps
            activeSet.isCompleted = true
            
            showRestTimer = true
        }
    }
    
    // MARK: - 3. Next Set
    func addNextSet() {
        guard let currentEx = currentExercise else { return }
        
        if !currentEx.isFinished {
            let nextSetNumber = currentEx.sets.count + 1
            let newSet = SessionSet(setNumber: nextSetNumber, reps: 0, weight: 0.0)
            currentEx.sets.append(newSet)
        }
        
        showRestTimer = false
    }
    
    // MARK: - 4. Finish Exercise
    func finishCurrentExercise() {
        currentExercise?.isFinished = true
        showRestTimer = false
    }
    
    // MARK: - 5. Finish Workout
    func finishWorkout() {
        if let sessionExercises = activeSession?.sessionExercises {
            for ex in sessionExercises {
                ex.sets.removeAll { !$0.isCompleted }
            }
        }
        
        activeSession?.isCompleted = true
        
        activeSession = nil
        currentExercise = nil
    }
}


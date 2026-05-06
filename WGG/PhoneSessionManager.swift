//
//  PhoneSessionManager.swift
//  WGG
//

import Foundation
import WatchConnectivity
import SwiftData

@Observable
class PhoneSessionManager: NSObject {

    var lastReceivedSession: Session?

    private var modelContext: ModelContext?

    // MARK: - Setup

    func configure(with context: ModelContext) {
        self.modelContext = context
    }

    func activate() {
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    // MARK: - Parse & Save

    private func handleReceivedWorkout(_ message: [String: Any]) {
        guard let context = modelContext else { return }

        let newSession = Session(date: Date())
        newSession.isCompleted = true

        if let exercisesData = message["exercises"] as? [[String: Any]] {
            for exData in exercisesData {
                let sessionExercise = SessionExercise()
                sessionExercise.isFinished = true

                // Cari exercise yang sudah ada di database, kalau tidak ada buat baru
                let name = exData["name"] as? String ?? "Unknown"
                let muscleGroup = exData["muscleGroup"] as? String ?? ""

                let descriptor = FetchDescriptor<Exercise>(
                    predicate: #Predicate { $0.name == name }
                )
                if let existing = try? context.fetch(descriptor).first {
                    sessionExercise.exercise = existing
                } else {
                    let newExercise = Exercise(name: name, muscleGroup: muscleGroup)
                    context.insert(newExercise)
                    sessionExercise.exercise = newExercise
                }

                // Parse setiap set
                if let setsData = exData["sets"] as? [[String: Any]] {
                    for setData in setsData {
                        let setNumber = setData["setNumber"] as? Int ?? 0
                        let reps     = setData["reps"] as? Int ?? 0
                        let weight   = setData["weight"] as? Double ?? 0.0

                        let sessionSet = SessionSet(setNumber: setNumber, reps: reps, weight: weight)
                        sessionSet.setDuration = setData["setDuration"] as? Int
                        sessionSet.restDuration = setData["restDuration"] as? Int
                        sessionSet.isCompleted = true
                        sessionSet.sessionExercise = sessionExercise
                        sessionExercise.sets.append(sessionSet)
                        context.insert(sessionSet)
                    }
                }

                sessionExercise.session = newSession
                newSession.sessionExercises.append(sessionExercise)
                context.insert(sessionExercise)
            }
        }

        context.insert(newSession)
        try? context.save()

        self.lastReceivedSession = newSession
    }
}

// MARK: - WCSessionDelegate

extension PhoneSessionManager: WCSessionDelegate {

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {}

    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {
        // Re-activate setelah handoff ke iPhone baru
        WCSession.default.activate()
    }

    // Dipanggil saat Watch mengirim data (iPhone foreground)
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            self.handleReceivedWorkout(message)
        }
    }

    // Dipanggil saat Watch mengirim via transferUserInfo (iPhone background/closed)
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        DispatchQueue.main.async {
            self.handleReceivedWorkout(userInfo)
        }
    }
}

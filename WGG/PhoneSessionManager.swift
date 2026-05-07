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
    // In-memory map: Watch sessionId → SwiftData Session (for incremental updates)
    private var activeSessions: [UUID: Session] = [:]

    // MARK: - Setup

    func configure(with context: ModelContext) {
        self.modelContext = context
    }

    func activate() {
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    // MARK: - Dispatch

    private func dispatch(_ message: [String: Any]) {
        let type = message["type"] as? String ?? "legacy"
        switch type {
        case "exerciseUpdate":
            handleExerciseUpdate(message)
        case "sessionComplete":
            handleSessionComplete(message)
        default:
            handleLegacyWorkout(message)
        }
    }

    // MARK: - Incremental exercise update (called per exercise on Watch finish)

    private func handleExerciseUpdate(_ message: [String: Any]) {
        guard let context = modelContext,
              let sessionIdStr = message["sessionId"] as? String,
              let sessionId = UUID(uuidString: sessionIdStr),
              let exData = message["exercise"] as? [String: Any] else { return }

        let routineName = message["routineName"] as? String
        let session = findOrCreateSession(id: sessionId, routineName: routineName, context: context)

        let name = exData["name"] as? String ?? "Unknown"
        let muscleGroup = exData["muscleGroup"] as? String ?? ""

        // Skip if this exercise was already added (duplicate delivery guard)
        guard !session.sessionExercises.contains(where: { $0.exercise?.name == name }) else { return }

        let exercise = findOrCreateExercise(name: name, muscleGroup: muscleGroup, context: context)
        let sessionExercise = SessionExercise(session: session, exercise: exercise)
        sessionExercise.isFinished = true

        if let setsData = exData["sets"] as? [[String: Any]] {
            for setData in setsData {
                let set = SessionSet(
                    setNumber: setData["setNumber"] as? Int ?? 0,
                    reps: setData["reps"] as? Int ?? 0,
                    weight: setData["weight"] as? Double ?? 0.0
                )
                // Cast via NSNumber to handle both Int and Double from Watch
                set.setDuration = (setData["setDuration"] as? NSNumber)?.intValue
                set.restDuration = (setData["restDuration"] as? NSNumber)?.intValue
                set.isCompleted = true
                set.sessionExercise = sessionExercise
                sessionExercise.sets.append(set)
                context.insert(set)
            }
        }

        session.sessionExercises.append(sessionExercise)
        context.insert(sessionExercise)
        try? context.save()
        print("[Phone] Exercise '\(name)' saved (sessionId: \(sessionId))")
    }

    // MARK: - Session complete signal

    private func handleSessionComplete(_ message: [String: Any]) {
        guard let context = modelContext,
              let sessionIdStr = message["sessionId"] as? String,
              let sessionId = UUID(uuidString: sessionIdStr) else { return }

        // First try in-memory map, then fall back to SwiftData (covers app-restart case)
        let session = activeSessions[sessionId] ?? fetchSession(watchSessionId: sessionIdStr, context: context)

        if let session {
            session.isCompleted = true
            try? context.save()
            lastReceivedSession = session
            activeSessions.removeValue(forKey: sessionId)
            print("[Phone] Session complete (sessionId: \(sessionId))")
        } else {
            print("[Phone] sessionComplete: no session found for id \(sessionId)")
        }
    }

    // MARK: - Legacy format (old Watch app without type field)

    private func handleLegacyWorkout(_ message: [String: Any]) {
        guard let context = modelContext else { return }

        let newSession = Session(date: Date())
        newSession.isCompleted = true

        if let exercisesData = message["exercises"] as? [[String: Any]] {
            for exData in exercisesData {
                let name = exData["name"] as? String ?? "Unknown"
                let muscleGroup = exData["muscleGroup"] as? String ?? ""
                let exercise = findOrCreateExercise(name: name, muscleGroup: muscleGroup, context: context)

                let sessionExercise = SessionExercise(session: newSession, exercise: exercise)
                sessionExercise.isFinished = true

                if let setsData = exData["sets"] as? [[String: Any]] {
                    for setData in setsData {
                        let set = SessionSet(
                            setNumber: setData["setNumber"] as? Int ?? 0,
                            reps: setData["reps"] as? Int ?? 0,
                            weight: setData["weight"] as? Double ?? 0.0
                        )
                        set.setDuration = (setData["setDuration"] as? NSNumber)?.intValue
                        set.restDuration = (setData["restDuration"] as? NSNumber)?.intValue
                        set.isCompleted = true
                        set.sessionExercise = sessionExercise
                        sessionExercise.sets.append(set)
                        context.insert(set)
                    }
                }

                newSession.sessionExercises.append(sessionExercise)
                context.insert(sessionExercise)
            }
        }

        context.insert(newSession)
        try? context.save()
        lastReceivedSession = newSession
    }

    // MARK: - Helpers

    private func findOrCreateSession(id: UUID, routineName: String?, context: ModelContext) -> Session {
        if let existing = activeSessions[id] { return existing }
        let idStr = id.uuidString
        if let existing = fetchSession(watchSessionId: idStr, context: context) {
            activeSessions[id] = existing
            return existing
        }
        let session = Session(date: Date())
        session.watchSessionId = idStr
        // Link to matching Routine so title and color appear correctly in Calendar/Analytics
        if let name = routineName, !name.isEmpty {
            let descriptor = FetchDescriptor<Routine>(predicate: #Predicate { $0.title == name })
            session.routine = try? context.fetch(descriptor).first
        }
        context.insert(session)
        activeSessions[id] = session
        return session
    }

    private func fetchSession(watchSessionId: String, context: ModelContext) -> Session? {
        let all = (try? context.fetch(FetchDescriptor<Session>())) ?? []
        return all.first { $0.watchSessionId == watchSessionId && !$0.isCompleted }
    }

    private func findOrCreateExercise(name: String, muscleGroup: String, context: ModelContext) -> Exercise {
        let descriptor = FetchDescriptor<Exercise>(predicate: #Predicate { $0.name == name })
        if let existing = try? context.fetch(descriptor).first { return existing }
        let exercise = Exercise(name: name, muscleGroup: muscleGroup)
        context.insert(exercise)
        return exercise
    }
}

// MARK: - WCSessionDelegate

extension PhoneSessionManager: WCSessionDelegate {

    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {}

    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            self.dispatch(message)
        }
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        DispatchQueue.main.async {
            self.dispatch(userInfo)
        }
    }
}

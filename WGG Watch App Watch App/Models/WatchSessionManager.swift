import WatchConnectivity
import Observation

@Observable
class WatchSessionManager: NSObject, WCSessionDelegate {

    enum SendStatus {
        case idle, sending, sent, queued, failed
    }

    var loggedExercises: [WatchLoggedExercise] = []
    var sendStatus: SendStatus = .idle
    var isWorkoutActive: Bool = false
    var currentRoutineName: String = ""
    var finishedExerciseNames: [String] = []
    var sessionId: UUID = UUID()

    func activate() {
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    func logSet(exercise: WatchExercise, weight: Double, reps: Int, setDuration: Double) {
        if let index = loggedExercises.firstIndex(where: { $0.name == exercise.name }) {
            let setNumber = loggedExercises[index].sets.count + 1
            loggedExercises[index].sets.append(
                WatchLoggedSet(setNumber: setNumber, reps: reps, weight: weight, setDuration: setDuration)
            )
        } else {
            loggedExercises.append(WatchLoggedExercise(
                name: exercise.name,
                muscleGroup: exercise.muscleGroup,
                sets: [WatchLoggedSet(setNumber: 1, reps: reps, weight: weight, setDuration: setDuration)]
            ))
        }
        print("[Session] Logged \(reps) reps @ \(weight)kg for \(exercise.name), duration: \(Int(setDuration))s")
    }

    func updateLastRestDuration(_ seconds: Double) {
        guard !loggedExercises.isEmpty else { return }
        let exIndex = loggedExercises.count - 1
        guard !loggedExercises[exIndex].sets.isEmpty else { return }
        let setIndex = loggedExercises[exIndex].sets.count - 1
        loggedExercises[exIndex].sets[setIndex].restDuration = seconds
    }

    func finishExercise(_ name: String) {
        if !finishedExerciseNames.contains(name) {
            finishedExerciseNames.append(name)
            sendExerciseToPhone(name: name)
        }
    }

    private func sendExerciseToPhone(name: String) {
        guard let ex = loggedExercises.first(where: { $0.name == name }),
              WCSession.default.activationState == .activated else { return }

        let sets = ex.sets.map { s -> [String: Any] in
            ["setNumber": s.setNumber, "reps": s.reps, "weight": s.weight,
             "setDuration": s.setDuration, "restDuration": s.restDuration]
        }
        let payload: [String: Any] = [
            "type": "exerciseUpdate",
            "sessionId": sessionId.uuidString,
            "routineName": currentRoutineName,
            "exercise": ["name": ex.name, "muscleGroup": ex.muscleGroup, "sets": sets] as [String: Any]
        ]

        if WCSession.default.isReachable {
            WCSession.default.sendMessage(payload, replyHandler: nil) { _ in
                WCSession.default.transferUserInfo(payload)
            }
        } else {
            WCSession.default.transferUserInfo(payload)
        }
        print("[Session] Exercise '\(name)' sent to phone (sessionId: \(sessionId))")
    }

    func setNumber(for exercise: WatchExercise) -> Int {
        (loggedExercises.first(where: { $0.name == exercise.name })?.sets.count ?? 0) + 1
    }

    func sendToPhone() {
        guard WCSession.default.activationState == .activated else {
            print("[Session] WCSession not activated")
            sendStatus = .failed
            return
        }

        sendStatus = .sending
        let payload: [String: Any] = [
            "type": "sessionComplete",
            "sessionId": sessionId.uuidString
        ]

        if WCSession.default.isReachable {
            WCSession.default.sendMessage(payload, replyHandler: nil) { [weak self] error in
                print("[Session] sendMessage failed: \(error.localizedDescription), falling back to transferUserInfo")
                WCSession.default.transferUserInfo(payload)
                DispatchQueue.main.async { self?.sendStatus = .queued }
            }
            sendStatus = .sent
            print("[Session] sessionComplete sent (sessionId: \(sessionId))")
        } else {
            WCSession.default.transferUserInfo(payload)
            sendStatus = .queued
            print("[Session] sessionComplete queued (sessionId: \(sessionId))")
        }
    }

    func reset() {
        loggedExercises = []
        sendStatus = .idle
        isWorkoutActive = false
        finishedExerciseNames = []
        currentRoutineName = ""
        sessionId = UUID()
    }

    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("[Session] Watch WCSession activated: \(activationState.rawValue)")
    }
}

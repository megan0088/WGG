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

    func sendToPhone() {
        guard WCSession.default.activationState == .activated else {
            print("[Session] WCSession not activated")
            sendStatus = .failed
            return
        }

        sendStatus = .sending
        let payload = buildPayload()

        if WCSession.default.isReachable {
            // iPhone app sedang terbuka — kirim langsung
            WCSession.default.sendMessage(payload, replyHandler: nil) { [weak self] error in
                print("[Session] sendMessage failed: \(error.localizedDescription), falling back to transferUserInfo")
                // Fallback jika sendMessage gagal
                WCSession.default.transferUserInfo(payload)
                DispatchQueue.main.async { self?.sendStatus = .queued }
            }
            sendStatus = .sent
            print("[Session] Sent via sendMessage")
        } else {
            // iPhone app tidak terbuka — antri, kirim otomatis saat app dibuka
            WCSession.default.transferUserInfo(payload)
            sendStatus = .queued
            print("[Session] Queued via transferUserInfo (iPhone app not in foreground)")
        }
    }

    func reset() {
        loggedExercises = []
        sendStatus = .idle
        isWorkoutActive = false
    }

    private func buildPayload() -> [String: Any] {
        [
            "exercises": loggedExercises.map { ex -> [String: Any] in
                [
                    "name": ex.name,
                    "muscleGroup": ex.muscleGroup,
                    "sets": ex.sets.map { s -> [String: Any] in
                        [
                            "setNumber": s.setNumber,
                            "reps": s.reps,
                            "weight": s.weight,
                            "setDuration": s.setDuration,
                            "restDuration": s.restDuration
                        ]
                    }
                ]
            }
        ]
    }

    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("[Session] Watch WCSession activated: \(activationState.rawValue)")
    }
}

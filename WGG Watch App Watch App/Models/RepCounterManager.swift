import Foundation
import CoreMotion

// MARK: - RepCounterManager
// Handles real-time rep counting via accelerometer peak detection.
// CoreML exercise classification is wired but dormant until ExerciseClassifier.mlmodel
// is added to the project (see MARK: CoreML below).

@Observable
class RepCounterManager {

    // MARK: Published state
    var repCount: Int = 0
    var detectedExercise: String = "Unknown"
    var confidence: Double = 0.0
    var isActive: Bool = false

    // MARK: Private
    private let motionManager = CMMotionManager()
    private let sampleRate: Double = 50.0         // Hz
    private let windowSize: Int = 100              // 2 sec at 50Hz
    private var sensorBuffer: [[Float]] = []

    // Peak detection state
    private var smoothedMag: Double = 0.0
    private var wasAboveThreshold = false
    private var samplesSinceLastRep: Int = 0
    private let repThreshold: Double = 0.8        // g (user acceleration)
    private let minSamplesBetweenReps: Int = 20   // 0.4 sec debounce

    // MARK: - Control

    func start() {
        guard motionManager.isDeviceMotionAvailable, !isActive else { return }
        isActive = true
        motionManager.deviceMotionUpdateInterval = 1.0 / sampleRate
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let self, let motion else { return }
            self.process(motion: motion)
        }
    }

    func stop() {
        motionManager.stopDeviceMotionUpdates()
        isActive = false
    }

    func reset() {
        repCount = 0
        detectedExercise = "Unknown"
        confidence = 0.0
        smoothedMag = 0.0
        wasAboveThreshold = false
        samplesSinceLastRep = 0
        sensorBuffer.removeAll()
    }

    // MARK: - Signal Processing

    private func process(motion: CMDeviceMotion) {
        let acc = motion.userAcceleration
        let gyro = motion.rotationRate

        // Build 6-channel sample for CoreML window
        let sample: [Float] = [
            Float(acc.x), Float(acc.y), Float(acc.z),
            Float(gyro.x), Float(gyro.y), Float(gyro.z)
        ]
        sensorBuffer.append(sample)
        if sensorBuffer.count > windowSize { sensorBuffer.removeFirst() }

        // Rep counting: peak detection on user-acceleration magnitude
        let mag = (acc.x * acc.x + acc.y * acc.y + acc.z * acc.z).squareRoot()
        countRep(magnitude: mag)

        // Exercise classification: run every full window
        if sensorBuffer.count == windowSize {
            classifyExercise()
        }

        samplesSinceLastRep += 1
    }

    private func countRep(magnitude: Double) {
        // Exponential moving average smoothing
        smoothedMag = 0.7 * smoothedMag + 0.3 * magnitude

        if !wasAboveThreshold && smoothedMag > repThreshold {
            wasAboveThreshold = true
        } else if wasAboveThreshold && smoothedMag < repThreshold * 0.65 {
            wasAboveThreshold = false
            if samplesSinceLastRep >= minSamplesBetweenReps {
                repCount += 1
                samplesSinceLastRep = 0
            }
        }
    }

    // MARK: - CoreML Classification
    // Step 1: Train model with Python script (see project README / Colab link)
    // Step 2: Add ExerciseClassifier.mlmodel to the Watch app target in Xcode
    // Step 3: Uncomment the block below

    private func classifyExercise() {
        /*
        guard let classifier = try? ExerciseClassifier() else { return }

        // Flatten [100][6] buffer → MLMultiArray
        guard let input = try? MLMultiArray(shape: [1, 100, 6] as [NSNumber], dataType: .float32) else { return }
        for (t, sample) in sensorBuffer.enumerated() {
            for (c, value) in sample.enumerated() {
                input[[0, t, c] as [NSNumber]] = NSNumber(value: value)
            }
        }

        if let output = try? classifier.prediction(sensorWindow: input) {
            DispatchQueue.main.async {
                self.detectedExercise = output.exerciseLabel
                self.confidence = output.exerciseLabelProbability[output.exerciseLabel] ?? 0
            }
        }
        */

        // Placeholder until model is added
        if confidence == 0.0 {
            detectedExercise = "Detecting..."
            confidence = 0.0
        }
    }
}

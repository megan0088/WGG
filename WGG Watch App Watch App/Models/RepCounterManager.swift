import Foundation
import CoreMotion

// Handle real-time rep counting via accelerometer peak detection.

@Observable
class RepCounterManager {

    var repCount: Int = 0
    var isActive: Bool = false
    
    private let motionManager = CMMotionManager()
    private let sampleRate: Double = 50.0 // Hz - read sensor 50x per second

    // Signal Smoothing
    private let emaAlpha: Double = 0.3
    private var smoothedMag: Double = 0.0

    // Adaptive Threshold - if user move slowly, threshold follows down (vice versa)
    private let kSigma: Double = 0.8 // how far above "normal" until considered "active"
    private let adaptAlpha: Double = 0.02 // how fast threshold adapts
    private let warmupSamples: Int = 75 // 1.5 sec - first calibration

    private var rollingMean: Double = 0.0 // mean of movement strength
    private var rollingVariance: Double = 0.0 // movement variance
    private var totalSamples: Int = 0

    // Scales automatically to how hard/soft the user moves
    private var adaptiveThreshold: Double {
        rollingMean + kSigma * rollingVariance.squareRoot()
    }

    // After downward movement, must drop far enough before ready to count next rep -> prevent 1 rep counted as 2 due to around-top consolidation
    private let hysteresisRatio: Double = 0.65

    // Minimum number of samples (total of 0.24 second) the movement signal must stay above threshold to be counted as rep
    private let minDurationAbove: Int = 12 // (12/50 Hz = 0.24 s)
    
    // Minimal pause between reps -> prevent 1 rep counted as 2
    private let minSamplesBetweenReps: Int = 20 // (20/50 Hz = 0.4 s)

    private var wasAboveThreshold: Bool = false
    private var samplesAboveThreshold: Int = 0
    private var samplesSinceLastRep: Int = 0

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

        smoothedMag = 0.0
        rollingMean = 0.0
        rollingVariance = 0.0
        totalSamples = 0

        wasAboveThreshold = false
        samplesAboveThreshold = 0
        samplesSinceLastRep = 0
    }

    // MARK: - Signal Processing

    private func process(motion: CMDeviceMotion) {
        let acc = motion.userAcceleration
        
        // Calculate total movement strength
        let mag = (acc.x * acc.x + acc.y * acc.y + acc.z * acc.z).squareRoot()

        // Update baseline -> calculate adaptive threshold
        updateRollingStats(magnitude: mag)
        totalSamples += 1
        samplesSinceLastRep += 1

        // Rep counting (only after warmup)
        if totalSamples > warmupSamples {
            countRep(magnitude: mag)
        }
    }

    // MARK: - Adaptive Stats

    private func updateRollingStats(magnitude: Double) {
        // Update movement strength mean and variance over time
        rollingMean = (1 - adaptAlpha) * rollingMean + adaptAlpha * magnitude
        let diff = magnitude - rollingMean
        rollingVariance = (1 - adaptAlpha) * rollingVariance + adaptAlpha * diff * diff
    }

    // MARK: - Rep Counter

    private func countRep(magnitude: Double) {

        // Signal smoothing to eliminate small spikes
        smoothedMag = (1 - emaAlpha) * smoothedMag + emaAlpha * magnitude

        let threshold = adaptiveThreshold

        // If crossing up (rising), flag as active -> count how many samples above threshold
        if smoothedMag > threshold {
            if !wasAboveThreshold {
                wasAboveThreshold = true
                samplesAboveThreshold = 0
            }
            samplesAboveThreshold += 1

        // If crossing down (falling) -> flag as inactive and evaluate if it's valid
        } else if wasAboveThreshold && smoothedMag < threshold * hysteresisRatio {
            wasAboveThreshold = false

            let hadEnoughDuration = samplesAboveThreshold >= minDurationAbove
            let hadEnoughGap = samplesSinceLastRep >= minSamplesBetweenReps

            if hadEnoughDuration && hadEnoughGap {
                // if valid -> count as rep
                repCount += 1
                samplesSinceLastRep = 0
                print("[Rep] ✓ Rep #\(repCount) — duration: \(samplesAboveThreshold) samples, threshold: \(String(format: "%.3f", threshold))g")
            } else {
                // If not valid -> log reason for debugging
                if !hadEnoughDuration {
                    print("[Rep] ✗ Jerk filtered — duration \(samplesAboveThreshold) < \(minDurationAbove) samples")
                }
                if !hadEnoughGap {
                    print("[Rep] ✗ Debounce — gap \(samplesSinceLastRep) < \(minSamplesBetweenReps) samples")
                }
            }

            samplesAboveThreshold = 0
        }
    }
}

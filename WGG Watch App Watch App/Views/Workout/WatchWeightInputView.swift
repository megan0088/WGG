import SwiftUI

struct WatchWeightInputView: View {
    let exercise: WatchExercise
    let exercises: [WatchExercise]
    let initialWeight: Double

    @Environment(WatchSessionManager.self) private var sessionManager
    private let weights: [Double] = stride(from: 0.0, through: 300.0, by: 0.25).map { $0 }
    @State private var selectedIndex: Int

    init(exercise: WatchExercise, exercises: [WatchExercise], initialWeight: Double = 20.0) {
        self.exercise = exercise
        self.exercises = exercises
        self.initialWeight = initialWeight
        // Find nearest index to initialWeight
        let weights = stride(from: 0.0, through: 300.0, by: 0.25).map { $0 }
        let nearestIndex = weights.enumerated().min(by: { abs($0.element - initialWeight) < abs($1.element - initialWeight) })?.offset ?? 80
        self._selectedIndex = State(initialValue: nearestIndex)
    }

    var selectedWeight: Double { weights[selectedIndex] }

    var currentSetNumber: Int {
        sessionManager.setNumber(for: exercise)
    }

    func ordinal(_ n: Int) -> String {
        switch n % 10 {
        case 1 where n % 100 != 11: return "\(n)st"
        case 2 where n % 100 != 12: return "\(n)nd"
        case 3 where n % 100 != 13: return "\(n)rd"
        default: return "\(n)th"
        }
    }

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 1) {
                    Text(sessionManager.currentRoutineName)
                        .font(.caption2)
                        .foregroundStyle(Color.brandSecondary)
                        .lineLimit(1)
                    Text(exercise.name)
                        .font(.caption2)
                        .foregroundStyle(Color.brandSecondary)
                        .lineLimit(1)
                }
                .padding(.top, 4)

                // Drum roll picker
                Picker("Weight", selection: $selectedIndex) {
                    ForEach(0..<weights.count, id: \.self) { i in
                        Text(weightLabel(weights[i]))
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .foregroundStyle(Color.brandPrimaryText)
                            .tag(i)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 90)

                // Start button
                NavigationLink {
                    WatchCountdownView(exercise: exercise, exercises: exercises, weight: selectedWeight)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 10))
                        Text("Start \(ordinal(currentSetNumber)) Set")
                            .font(.footnote.bold())
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.black)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.brandAccent)
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
        }
        .navigationTitle("Weight")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func weightLabel(_ value: Double) -> String {
        let kg = Int(value)
        let dec = Int(round((value - Double(kg)) * 100))
        return String(format: "%d,%02d kg", kg, dec)
    }
}

#Preview {
    NavigationStack {
        WatchWeightInputView(
            exercise: WatchExercise(name: "Chest Dip", muscleGroup: "Chest"),
            exercises: WatchRoutine.mock.exercises
        )
        .environment({
            let m = WatchSessionManager()
            m.currentRoutineName = "Pull Day"
            return m
        }())
    }
}

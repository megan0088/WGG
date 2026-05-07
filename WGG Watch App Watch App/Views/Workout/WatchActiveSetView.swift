import SwiftUI
import Combine

struct WatchActiveSetView: View {
    let exercise: WatchExercise
    let exercises: [WatchExercise]
    let weight: Double

    @Environment(WatchSessionManager.self) private var sessionManager
    @State private var manager = RepCounterManager()
    @State private var goToSetDone = false
    @State private var elapsedSeconds = 0

    let setTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // "● Counting Reps" indicator
                HStack(spacing: 5) {
                    Circle()
                        .fill(Color.brandAccent)
                        .frame(width: 7, height: 7)
                        .scaleEffect(manager.isActive ? 1.3 : 1.0)
                        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: manager.isActive)
                    Text("Counting Reps")
                        .font(.system(size: 11, weight: .semibold, design: .default))
                        .foregroundStyle(Color.brandAccent)
                }
                .padding(.top, 8)

                // Routine + Exercise name
                VStack(spacing: 1) {
                    Text(sessionManager.currentRoutineName)
                        .font(.caption2)
                        .foregroundStyle(Color.brandSecondary)
                    Text(exercise.name)
                        .font(.caption2)
                        .foregroundStyle(Color.brandSecondary)
                }
                .padding(.top, 2)

                Spacer()

                // Rep count
                Text("\(manager.repCount)")
                    .font(.system(size: 64, weight: .black, design: .default))
                    .foregroundStyle(Color.brandPrimaryText)
                    .contentTransition(.numericText())
                    .animation(.spring(duration: 0.2), value: manager.repCount)

                // Weight
                Text(weightLabel(weight))
                    .font(.caption)
                    .foregroundStyle(Color.brandSecondary)
                    .padding(.top, 2)

                Spacer()

                // Done button
                Button {
                    manager.stop()
                    goToSetDone = true
                } label: {
                    Label("Done", systemImage: "checkmark")
                        .font(.footnote.bold())
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.brandAccent)
                .padding(.horizontal, 12)
                .padding(.top, 6)
                .padding(.bottom, 8)
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(
            NavigationLink(isActive: $goToSetDone) {
                WatchSetDoneView(
                    exercise: exercise,
                    exercises: exercises,
                    weight: weight,
                    reps: manager.repCount,
                    setDuration: Double(elapsedSeconds)
                )
            } label: { EmptyView() }
        )
        .onAppear { manager.start() }
        .onDisappear { manager.stop() }
        .onReceive(setTimer) { _ in elapsedSeconds += 1 }
    }

    private func weightLabel(_ value: Double) -> String {
        let kg = Int(value)
        let dec = Int(round((value - Double(kg)) * 100))
        return String(format: "%d,%02d kg", kg, dec)
    }
}

#Preview {
    NavigationStack {
        WatchActiveSetView(
            exercise: WatchExercise(name: "Chest Dip", muscleGroup: "Chest"),
            exercises: WatchRoutine.mock.exercises,
            weight: 15.25
        )
        .environment({
            let m = WatchSessionManager()
            m.currentRoutineName = "Pull Day"
            return m
        }())
    }
}

import SwiftUI
import Combine

struct WatchActiveSetView: View {
    let exercise: WatchExercise
    let exercises: [WatchExercise]
    let weight: Double

    @State private var manager = RepCounterManager()
    @State private var goToSetDone = false
    @State private var elapsedSeconds = 0

    let setTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var timeString: String {
        let m = elapsedSeconds / 60
        let s = elapsedSeconds % 60
        return String(format: "%d:%02d", m, s)
    }

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            VStack(spacing: 0) {

                Text(exercise.name.uppercased())
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.brandSecondary)
                    .lineLimit(1)
                    .padding(.top, 8)

                Spacer()

                VStack(spacing: 2) {
                    Text("\(manager.repCount)")
                        .font(.system(size: 60, weight: .black, design: .rounded))
                        .foregroundStyle(Color.brandAccent)
                        .contentTransition(.numericText())
                        .animation(.spring(duration: 0.2), value: manager.repCount)

                    HStack(spacing: 6) {
                        Text("\(weight, specifier: "%.1f") kg")
                        Text("·")
                        Text(timeString)
                    }
                    .font(.caption)
                    .foregroundStyle(Color.brandSecondary)
                }

                Spacer()

                // Live counting indicator
                HStack(spacing: 5) {
                    Circle()
                        .fill(manager.isActive ? Color.brandAccent : Color.brandSecondary)
                        .frame(width: 6, height: 6)
                        .scaleEffect(manager.isActive ? 1.3 : 1.0)
                        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                                   value: manager.isActive)
                    Text(manager.isActive ? "Counting..." : "Starting...")
                        .font(.caption2)
                        .foregroundStyle(Color.brandSecondary)
                }

                Button {
                    manager.stop()
                    goToSetDone = true
                } label: {
                    Image(systemName: "checkmark")
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
        .onAppear { manager.start() }
        .onDisappear { manager.stop() }
        .onReceive(setTimer) { _ in
            elapsedSeconds += 1
        }
        .navigationDestination(isPresented: $goToSetDone) {
            WatchSetDoneView(
                exercise: exercise,
                exercises: exercises,
                weight: weight,
                reps: manager.repCount,
                setDuration: Double(elapsedSeconds)
            )
        }
    }
}

#Preview {
    NavigationStack {
        WatchActiveSetView(
            exercise: WatchExercise(name: "Pull Up", muscleGroup: "Back"),
            exercises: WatchRoutine.mock.exercises,
            weight: 60.0
        )
    }
}

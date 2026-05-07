import SwiftUI

struct WatchExerciseBreakdownView: View {
    let exercise: WatchExercise
    let exercises: [WatchExercise]

    @Environment(WatchSessionManager.self) private var sessionManager
    @State private var goToNextExercise = false

    var loggedExercise: WatchLoggedExercise? {
        sessionManager.loggedExercises.first(where: { $0.name == exercise.name })
    }

    var totalSets: Int { loggedExercise?.sets.count ?? 0 }
    var totalReps: Int { loggedExercise?.sets.reduce(0) { $0 + $1.reps } ?? 0 }
    var totalSetSeconds: Double { loggedExercise?.sets.reduce(0) { $0 + $1.setDuration } ?? 0 }
    var totalVolume: Double {
        loggedExercise?.sets.reduce(0) { $0 + $1.weight * Double($1.reps) } ?? 0
    }

    func timeString(_ seconds: Double) -> String {
        let t = Int(seconds)
        return String(format: "%d:%02d", t / 60, t % 60)
    }

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // Exercise name
                Text(exercise.name)
                    .font(.system(size: 16, weight: .black, design: .default))
                    .foregroundStyle(Color.brandAccent)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .padding(.top, 8)
                    .padding(.horizontal, 8)

                // Volume
                HStack(spacing: 2) {
                    Text("\(Int(totalVolume))")
                        .font(.system(size: 32, weight: .black, design: .default))
                        .foregroundStyle(Color.brandPrimaryText)
                    Text("kg")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.brandSecondary)
                        .padding(.top, 10)
                }

                // Stat badges
                HStack(spacing: 8) {
                    statBadge(value: String(format: "%02d", totalSets), label: "Sets", useRing: false)
                    statBadge(value: String(format: "%02d", totalReps), label: "Reps", useRing: false)
                    timeBadge(seconds: totalSetSeconds)
                }
                .padding(.horizontal, 6)
                .padding(.top, 6)

                Spacer(minLength: 4)

                // Next Exercise button
                Button {
                    goToNextExercise = true
                } label: {
                    Label("Next Exercise", systemImage: "arrow.up.arrow.down")
                        .font(.caption.bold())
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.brandAccent)
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(
            NavigationLink(isActive: $goToNextExercise) {
                WatchExercisePickerView(exercises: exercises)
            } label: { EmptyView() }
        )
    }

    @ViewBuilder
    private func statBadge(value: String, label: String, useRing: Bool) -> some View {
        ZStack {
            Circle()
                .stroke(Color.brandAccent, lineWidth: 2)
            VStack(spacing: 0) {
                Text(value)
                    .font(.system(size: 16, weight: .black, design: .default))
                    .foregroundStyle(Color.brandAccent)
                Text(label)
                    .font(.system(size: 7))
                    .foregroundStyle(Color.brandSecondary)
            }
        }
        .frame(width: 52, height: 52)
    }

    @ViewBuilder
    private func timeBadge(seconds: Double) -> some View {
        let progress = min(seconds / 600.0, 1.0)
        ZStack {
            Circle()
                .stroke(Color.brandSecondary.opacity(0.25), lineWidth: 2)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.brandAccent, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .rotationEffect(.degrees(-90))
            VStack(spacing: 0) {
                Text(timeString(seconds))
                    .font(.system(size: 13, weight: .black, design: .default))
                    .foregroundStyle(Color.brandPrimaryText)
                Text("Time")
                    .font(.system(size: 7))
                    .foregroundStyle(Color.brandSecondary)
            }
        }
        .frame(width: 52, height: 52)
    }
}

#Preview {
    NavigationStack {
        WatchExerciseBreakdownView(
            exercise: WatchExercise(name: "Chest Dip", muscleGroup: "Chest"),
            exercises: WatchRoutine.mock.exercises
        )
        .environment({
            let m = WatchSessionManager()
            m.logSet(exercise: WatchExercise(name: "Chest Dip", muscleGroup: "Chest"), weight: 15.25, reps: 7, setDuration: 50)
            m.logSet(exercise: WatchExercise(name: "Chest Dip", muscleGroup: "Chest"), weight: 15.25, reps: 8, setDuration: 52)
            m.finishExercise("Chest Dip")
            return m
        }())
    }
}

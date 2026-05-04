import SwiftUI

struct WatchActiveSetView: View {
    let exercise: WatchExercise
    let weight: Double

    @State private var manager = RepCounterManager()
    @State private var goToDetection = false

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

                    Text("\(weight, specifier: "%.1f") kg")
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
                    goToDetection = true
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
        .navigationDestination(isPresented: $goToDetection) {
            WatchDetectionView(
                exercise: exercise,
                weight: weight,
                reps: manager.repCount,
                detectedName: manager.detectedExercise == "Unknown" || manager.detectedExercise == "Detecting..."
                    ? exercise.name
                    : manager.detectedExercise,
                confidence: manager.confidence > 0 ? manager.confidence : 0.87
            )
        }
    }
}

#Preview {
    NavigationStack {
        WatchActiveSetView(
            exercise: WatchExercise(name: "Pull Up", muscleGroup: "Back"),
            weight: 60.0
        )
    }
}

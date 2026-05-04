import SwiftUI
import Combine

struct WatchRestTimerView: View {
    let exercise: WatchExercise
    let weight: Double
    let completedReps: Int

    @State private var secondsLeft: Int = 60
    @State private var goToNextSet = false
    @State private var goToHome = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var progress: Double {
        1.0 - (Double(secondsLeft) / 60.0)
    }

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            VStack(spacing: 6) {

                Text("REST")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.brandSecondary)
                    .padding(.top, 6)

                // Circular timer with dashed background
                ZStack {
                    Circle()
                        .stroke(
                            Color.brandSecondary.opacity(0.25),
                            style: StrokeStyle(lineWidth: 5, dash: [4, 4])
                        )

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            Color.brandAccent,
                            style: StrokeStyle(lineWidth: 5, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: secondsLeft)

                    VStack(spacing: 0) {
                        Text("\(secondsLeft)")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .foregroundStyle(Color.brandPrimaryText)
                            .contentTransition(.numericText())
                        Text("secs")
                            .font(.caption2)
                            .foregroundStyle(Color.brandSecondary)
                    }
                }
                .frame(width: 90, height: 90)

                Button("Skip") {
                    goToNextSet = true
                }
                .buttonStyle(.bordered)
                .tint(Color.brandAccent)
                .font(.caption2.bold())
                .padding(.bottom, 8)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onReceive(timer) { _ in
            if secondsLeft > 0 {
                secondsLeft -= 1
            } else {
                goToNextSet = true
            }
        }
        .navigationDestination(isPresented: $goToNextSet) {
            WatchActiveSetView(exercise: exercise, weight: weight)
        }
        .navigationDestination(isPresented: $goToHome) {
            WatchWorkoutView()
        }
    }
}

#Preview {
    NavigationStack {
        WatchRestTimerView(
            exercise: WatchExercise(name: "Pull Up", muscleGroup: "Back"),
            weight: 60.0,
            completedReps: 8
        )
    }
}

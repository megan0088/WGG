import SwiftUI
import Combine
import WatchKit

struct WatchRestTimerView: View {
    let exercise: WatchExercise
    let exercises: [WatchExercise]
    let weight: Double
    let completedReps: Int

    @Environment(WatchSessionManager.self) private var sessionManager
    @State private var timeRemaining: Double = 75
    @State private var isBlinking = false
    @State private var goToNextSet = false
    @State private var goToBreakdown = false

    let totalTime: Double = 75
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var isOvertime: Bool { timeRemaining < 0 }
    var progress: Double { max(timeRemaining, 0) / totalTime }
    var totalRestDuration: Double { totalTime - timeRemaining }

    func timeString(_ time: Double) -> String {
        if time > 0 && time < 60 {
            return "\(Int(ceil(time)))s"
        }
        let absTime = Int(ceil(abs(time)))
        let minutes = absTime / 60
        let seconds = absTime % 60
        let sign = time < 0 ? "-" : ""
        return String(format: "%@%02d:%02d", sign, minutes, seconds)
    }

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            VStack(spacing: 4) {
                // Title
                Text("Rest Time")
                    .font(.system(size: 13, weight: .semibold, design: .default))
                    .foregroundStyle(isOvertime ? Color.red : Color.brandAccent)
                    .padding(.top, 6)

                // Circle timer
                ZStack {
                    Circle()
                        .stroke(
                            isOvertime
                                ? Color.red.opacity(isBlinking ? 0.5 : 0.1)
                                : Color.teal.opacity(0.2),
                            lineWidth: 6
                        )
                        .animation(.easeInOut(duration: 0.5), value: isBlinking)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            isOvertime ? Color.red : Color.teal,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.05), value: timeRemaining)
                        .animation(.easeInOut, value: isOvertime)

                    Text(timeString(timeRemaining))
                        .font(.system(size: 28, weight: .black, design: .default))
                        .foregroundStyle(isOvertime ? Color.red : Color.brandPrimaryText)
                        .contentTransition(.numericText())
                }
                .frame(width: 88, height: 88)

                Spacer(minLength: 4)

                // Buttons — stacked vertically
                VStack(spacing: 6) {
                    Button {
                        sessionManager.updateLastRestDuration(totalRestDuration)
                        goToNextSet = true
                    } label: {
                        Label("Next Set", systemImage: "arrow.up.arrow.down")
                            .font(.caption.bold())
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.black)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.teal)

                    Button {
                        sessionManager.updateLastRestDuration(totalRestDuration)
                        sessionManager.finishExercise(exercise.name)
                        goToBreakdown = true
                    } label: {
                        Label("Finish Exercise", systemImage: "checkmark")
                            .font(.caption.bold())
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.brandPrimaryText)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.brandSecondary.opacity(0.2))
                }
                .padding(.horizontal, 6)
                .padding(.bottom, 8)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onReceive(timer) { _ in
            timeRemaining -= 0.05
            if timeRemaining < 0 && !isBlinking {
                WKInterfaceDevice.current().play(.notification)
                withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                    isBlinking = true
                }
            }
        }
        .navigationDestination(isPresented: $goToNextSet) {
            WatchWeightInputView(exercise: exercise, exercises: exercises, initialWeight: weight)
        }
        .navigationDestination(isPresented: $goToBreakdown) {
            WatchExerciseBreakdownView(exercise: exercise, exercises: exercises)
        }
    }
}

#Preview {
    NavigationStack {
        WatchRestTimerView(
            exercise: WatchExercise(name: "Chest Dip", muscleGroup: "Chest"),
            exercises: WatchRoutine.mock.exercises,
            weight: 15.25,
            completedReps: 7
        )
        .environment(WatchSessionManager())
    }
}

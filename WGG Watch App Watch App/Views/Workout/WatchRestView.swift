import SwiftUI
import Combine
import WatchKit

struct WatchRestTimerView: View {
    let exercise: WatchExercise
    let exercises: [WatchExercise]
    let weight: Double
    let completedReps: Int

    @Environment(WatchSessionManager.self) private var sessionManager
    @State private var timeRemaining: Double = 60
    @State private var isBlinking = false
    @State private var goToNextSet = false
    @State private var goToExercisePicker = false
    @State private var goToSummary = false

    let totalTime: Double = 60
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var isOvertime: Bool { timeRemaining < 0 }
    var progress: Double { max(timeRemaining, 0) / totalTime }
    var totalRestDuration: Double { totalTime - timeRemaining }

    func timeString(_ time: Double) -> String {
        let displayTime = Int(ceil(time))
        let absTime = abs(displayTime)
        let minutes = absTime / 60
        let seconds = absTime % 60
        let sign = time <= -1 ? "-" : ""
        return String(format: "%@%02d:%02d", sign, minutes, seconds)
    }

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            VStack(spacing: 3) {
                // Exercise name
                Text(exercise.name)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.brandSecondary)
                    .lineLimit(1)
                    .padding(.top, 4)

                // Last logged set
                HStack(spacing: 3) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 9, weight: .bold))
                    Text("\(String(format: "%.1f", weight)) kg × \(completedReps) reps")
                        .font(.system(size: 10, weight: .medium))
                }
                .foregroundStyle(Color.brandAccent)

                // Circle timer
                ZStack {
                    Circle()
                        .stroke(
                            isOvertime
                                ? Color.red.opacity(isBlinking ? 0.6 : 0.05)
                                : Color.brandSecondary.opacity(0.15),
                            lineWidth: 8
                        )
                        .animation(.easeInOut(duration: 0.5), value: isBlinking)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            isOvertime ? Color.red : Color.brandAccent,
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 0.05), value: timeRemaining)
                        .animation(.easeInOut, value: isOvertime)

                    VStack(spacing: 0) {
                        Text(timeString(timeRemaining))
                            .font(.system(size: 26, weight: .black, design: .rounded))
                            .foregroundStyle(isOvertime ? Color.red : Color.brandPrimaryText)
                            .contentTransition(.numericText())
                        Text("rest time")
                            .font(.system(size: 9))
                            .foregroundStyle(Color.brandSecondary)
                    }
                }
                .frame(width: 90, height: 90)

                // Buttons
                Button("Next Set") {
                    sessionManager.updateLastRestDuration(totalRestDuration)
                    goToNextSet = true
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.brandAccent)
                .font(.caption2.bold())

                HStack(spacing: 6) {
                    Button("Next Ex.") {
                        sessionManager.updateLastRestDuration(totalRestDuration)
                        goToExercisePicker = true
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.brandSecondary)
                    .font(.system(size: 9, weight: .medium))

                    Button("Finish") {
                        sessionManager.updateLastRestDuration(totalRestDuration)
                        goToSummary = true
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.brandSecondary)
                    .font(.system(size: 9, weight: .medium))
                }
                .padding(.bottom, 4)
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
            WatchActiveSetView(exercise: exercise, exercises: exercises, weight: weight)
        }
        .navigationDestination(isPresented: $goToExercisePicker) {
            WatchExercisePickerView(exercises: exercises)
        }
        .navigationDestination(isPresented: $goToSummary) {
            WatchSummaryView()
        }
    }
}

#Preview {
    NavigationStack {
        WatchRestTimerView(
            exercise: WatchExercise(name: "Pull Up", muscleGroup: "Back"),
            exercises: WatchRoutine.mock.exercises,
            weight: 60.0,
            completedReps: 8
        )
        .environment(WatchSessionManager())
    }
}

import SwiftUI
import Combine

struct WatchCountdownView: View {
    let exercise: WatchExercise
    let weight: Double

    @State private var count = 3
    @State private var goToActive = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            VStack(spacing: 4) {
                Text(exercise.name)
                    .font(.caption2)
                    .foregroundStyle(Color.brandSecondary)
                    .lineLimit(1)

                Spacer()

                Text(count == 0 ? "GO!" : "\(count)")
                    .font(.system(size: 72, weight: .black, design: .rounded))
                    .foregroundStyle(count == 0 ? Color.brandAccent : Color.brandPrimaryText)
                    .contentTransition(.numericText())
                    .animation(.spring(duration: 0.3), value: count)

                Spacer()

                Text("\(weight, specifier: "%.1f") kg")
                    .font(.caption2)
                    .foregroundStyle(Color.brandSecondary)
            }
            .padding(8)
        }
        .navigationBarBackButtonHidden(true)
        .onReceive(timer) { _ in
            if count > 0 {
                count -= 1
            }
        }
        .navigationDestination(isPresented: $goToActive) {
            WatchActiveSetView(exercise: exercise, weight: weight)
        }
        .onChange(of: count) { _, newValue in
            if newValue == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    goToActive = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        WatchCountdownView(
            exercise: WatchExercise(name: "Pull Up", muscleGroup: "Back"),
            weight: 60.0
        )
    }
}

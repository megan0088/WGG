import SwiftUI

struct WatchDetectionView: View {
    let exercise: WatchExercise
    let weight: Double
    let reps: Int
    let detectedName: String
    let confidence: Double

    @State private var goToSetDone = false
    @State private var goBackToActive = false

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            VStack(spacing: 6) {

                // Detected header
                HStack(spacing: 4) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(Color.brandAccent)
                    Text("DETECTED")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.brandAccent)
                }
                .padding(.top, 8)

                Spacer()

                // Exercise name
                Text("\(detectedName)?")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundStyle(Color.brandPrimaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                // Confidence badge
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.brandAccent)
                        .frame(width: 6, height: 6)
                    Text("\(Int(confidence * 100))% match")
                        .font(.caption2)
                        .foregroundStyle(Color.brandSecondary)
                }

                Spacer()

                // Yes / No buttons
                HStack(spacing: 8) {
                    Button("No") {
                        goBackToActive = true
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.brandSecondary)
                    .font(.caption2)

                    Button("Yes") {
                        goToSetDone = true
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.brandAccent)
                    .font(.caption2.bold())
                    .foregroundStyle(.black)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToSetDone) {
            WatchSetDoneView(exercise: exercise, weight: weight, reps: reps)
        }
        .navigationDestination(isPresented: $goBackToActive) {
            WatchActiveSetView(exercise: exercise, weight: weight)
        }
    }
}

#Preview {
    NavigationStack {
        WatchDetectionView(
            exercise: WatchExercise(name: "Pull Up", muscleGroup: "Back"),
            weight: 82.5,
            reps: 8,
            detectedName: "Bench Press",
            confidence: 0.87
        )
    }
}

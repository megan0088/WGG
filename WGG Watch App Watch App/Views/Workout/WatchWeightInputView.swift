import SwiftUI

struct WatchWeightInputView: View {
    let exercise: WatchExercise
    let exercises: [WatchExercise]

    @State private var weight: Double = 20.0
    @FocusState private var crownFocused: Bool

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            VStack(spacing: 0) {

                VStack(spacing: 2) {
                    Text(exercise.name)
                        .font(.headline)
                        .foregroundStyle(Color.brandPrimaryText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Text(exercise.muscleGroup)
                        .font(.caption2)
                        .foregroundStyle(Color.brandSecondary)
                }
                .padding(.top, 8)

                Spacer()

                Text("\(weight, specifier: "%.1f") kg")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.brandAccent)
                    .focused($crownFocused)
                    .digitalCrownRotation(
                        $weight,
                        from: 0, through: 300, by: 2.5,
                        sensitivity: .medium,
                        isContinuous: false
                    )
                    .onAppear { crownFocused = true }

                Spacer()

                VStack(spacing: 6) {
                    HStack(spacing: 8) {
                        Button {
                            weight = max(0, weight - 2.5)
                        } label: {
                            Image(systemName: "minus")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .tint(Color.brandSecondary)

                        Button {
                            weight = min(300, weight + 2.5)
                        } label: {
                            Image(systemName: "plus")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .tint(Color.brandSecondary)
                    }

                    NavigationLink {
                        WatchCountdownView(exercise: exercise, exercises: exercises, weight: weight)
                    } label: {
                        Text("Start")
                            .font(.footnote.bold())
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.black)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.brandAccent)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
            }
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        WatchWeightInputView(
            exercise: WatchExercise(name: "Pull Up", muscleGroup: "Back"),
            exercises: WatchRoutine.mock.exercises
        )
    }
}

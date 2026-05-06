import SwiftUI

struct WatchExercisePickerView: View {
    let exercises: [WatchExercise]

    @State private var selectedExercise: WatchExercise?
    @State private var goToWeightInput = false

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                Text("WHICH EXERCISE?")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.brandSecondary)
                    .padding(.top, 8)
                    .padding(.bottom, 4)

                ScrollView {
                    VStack(spacing: 6) {
                        ForEach(exercises) { exercise in
                            Button {
                                selectedExercise = exercise
                                goToWeightInput = true
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(exercise.name)
                                            .font(.caption.bold())
                                            .foregroundStyle(Color.brandPrimaryText)
                                        Text(exercise.muscleGroup)
                                            .font(.caption2)
                                            .foregroundStyle(Color.brandSecondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.caption2)
                                        .foregroundStyle(Color.brandSecondary)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 6)
                                .background(Color.brandSecondary.opacity(0.1))
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToWeightInput) {
            if let exercise = selectedExercise {
                WatchWeightInputView(exercise: exercise, exercises: exercises)
            }
        }
    }
}

#Preview {
    NavigationStack {
        WatchExercisePickerView(exercises: WatchRoutine.mock.exercises)
    }
}

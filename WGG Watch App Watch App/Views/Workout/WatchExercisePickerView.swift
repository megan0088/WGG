import SwiftUI

struct WatchExercisePickerView: View {
    let exercises: [WatchExercise]
    @Environment(WatchSessionManager.self) private var sessionManager
    @State private var selectedExercise: WatchExercise?
    @State private var goToWeightInput = false

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(exercises) { exercise in
                    let isCompleted = sessionManager.finishedExerciseNames.contains(exercise.name)
                    Button {
                        selectedExercise = exercise
                        goToWeightInput = true
                    } label: {
                        HStack {
                            Text(exercise.name)
                                .font(.body.bold())
                                .foregroundStyle(isCompleted ? Color.brandSecondary : Color.brandPrimaryText)
                            Spacer()
                            if isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.caption)
                                    .foregroundStyle(Color.brandSecondary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)
                    .background(Color.white.opacity(isCompleted ? 0.04 : 0.08))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
        }
        .navigationTitle("Choose Exercise")
        .navigationBarTitleDisplayMode(.inline)
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
            .environment(WatchSessionManager())
    }
}

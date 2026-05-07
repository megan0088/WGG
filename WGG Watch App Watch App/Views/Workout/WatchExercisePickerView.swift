import SwiftUI

struct WatchExercisePickerView: View {
    let exercises: [WatchExercise]
    @Environment(WatchSessionManager.self) private var sessionManager

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(exercises) { exercise in
                    let isCompleted = sessionManager.finishedExerciseNames.contains(exercise.name)
                    NavigationLink {
                        WatchWeightInputView(exercise: exercise, exercises: exercises)
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

                // Finish Workout — visible once at least one exercise is logged
                if !sessionManager.finishedExerciseNames.isEmpty {
                    NavigationLink {
                        WatchSummaryView()
                    } label: {
                        Label("Finish Workout", systemImage: "flag.checkered")
                            .font(.caption.bold())
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.black)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.brandAccent)
                    .padding(.top, 4)
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
        }
        .navigationTitle("Choose Exercise")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        WatchExercisePickerView(exercises: WatchRoutine.mock.exercises)
            .environment({
                let m = WatchSessionManager()
                m.finishedExerciseNames = ["Pull Up"]
                return m
            }())
    }
}

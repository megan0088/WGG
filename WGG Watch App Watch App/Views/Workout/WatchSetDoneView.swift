import SwiftUI

struct WatchSetDoneView: View {
    let exercise: WatchExercise
    let exercises: [WatchExercise]
    let weight: Double
    let reps: Int
    let setDuration: Double

    @Environment(WatchSessionManager.self) private var sessionManager
    @State private var editedReps: Int
    @State private var editedWeight: Double
    @State private var goToRest = false
    @State private var isEditing = false

    init(exercise: WatchExercise, exercises: [WatchExercise], weight: Double, reps: Int, setDuration: Double = 0) {
        self.exercise = exercise
        self.exercises = exercises
        self.weight = weight
        self.reps = reps
        self.setDuration = setDuration
        self._editedReps = State(initialValue: reps)
        self._editedWeight = State(initialValue: weight)
    }

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            if isEditing {
                editView
            } else {
                confirmView
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToRest) {
            WatchRestTimerView(
                exercise: exercise,
                exercises: exercises,
                weight: editedWeight,
                completedReps: editedReps
            )
        }
    }

    // MARK: - Confirm View
    private var confirmView: some View {
        VStack(spacing: 4) {
            Text("Set done?")
                .font(.caption2)
                .foregroundStyle(Color.brandSecondary)
                .padding(.top, 8)

            Spacer()

            VStack(spacing: 2) {
                Text("\(editedReps) reps")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundStyle(Color.brandAccent)
                Text("\(editedWeight, specifier: "%.1f") kg")
                    .font(.caption)
                    .foregroundStyle(Color.brandSecondary)
            }

            Spacer()

            HStack(spacing: 8) {
                Button("Edit") {
                    isEditing = true
                }
                .buttonStyle(.bordered)
                .tint(Color.brandSecondary)
                .font(.caption2)

                Button {
                    sessionManager.logSet(
                        exercise: exercise,
                        weight: editedWeight,
                        reps: editedReps,
                        setDuration: setDuration
                    )
                    goToRest = true
                } label: {
                    Label("Log", systemImage: "checkmark")
                        .font(.caption2.bold())
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.brandAccent)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
    }

    // MARK: - Edit View
    private var editView: some View {
        VStack(spacing: 0) {
            Text("EDIT SET")
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundStyle(Color.brandSecondary)
                .padding(.top, 8)
                .padding(.bottom, 4)

            ScrollView {
                VStack(spacing: 10) {

                    // Reps editor
                    HStack(spacing: 0) {
                        Button {
                            editedReps = max(1, editedReps - 1)
                        } label: {
                            Image(systemName: "minus")
                                .frame(width: 32, height: 32)
                        }
                        .buttonStyle(.bordered)
                        .tint(Color.brandSecondary)

                        Spacer()

                        VStack(spacing: 0) {
                            Text("\(editedReps)")
                                .font(.system(size: 26, weight: .black, design: .rounded))
                                .foregroundStyle(Color.brandAccent)
                                .contentTransition(.numericText())
                            Text("reps")
                                .font(.system(size: 9))
                                .foregroundStyle(Color.brandSecondary)
                        }

                        Spacer()

                        Button {
                            editedReps = min(50, editedReps + 1)
                        } label: {
                            Image(systemName: "plus")
                                .frame(width: 32, height: 32)
                        }
                        .buttonStyle(.bordered)
                        .tint(Color.brandSecondary)
                    }
                    .padding(.horizontal, 8)

                    // Weight editor
                    HStack(spacing: 0) {
                        Button {
                            editedWeight = max(0, editedWeight - 2.5)
                        } label: {
                            Image(systemName: "minus")
                                .frame(width: 32, height: 32)
                        }
                        .buttonStyle(.bordered)
                        .tint(Color.brandSecondary)

                        Spacer()

                        VStack(spacing: 0) {
                            Text("\(editedWeight, specifier: "%.1f")")
                                .font(.system(size: 22, weight: .black, design: .rounded))
                                .foregroundStyle(Color.brandAccent)
                                .contentTransition(.numericText())
                            Text("kg")
                                .font(.system(size: 9))
                                .foregroundStyle(Color.brandSecondary)
                        }

                        Spacer()

                        Button {
                            editedWeight = min(300, editedWeight + 2.5)
                        } label: {
                            Image(systemName: "plus")
                                .frame(width: 32, height: 32)
                        }
                        .buttonStyle(.bordered)
                        .tint(Color.brandSecondary)
                    }
                    .padding(.horizontal, 8)

                    Button("Done") {
                        isEditing = false
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.brandAccent)
                    .font(.caption2.bold())
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        WatchSetDoneView(
            exercise: WatchExercise(name: "Bench Press", muscleGroup: "Chest"),
            exercises: WatchRoutine.mock.exercises,
            weight: 82.5,
            reps: 8,
            setDuration: 45
        )
        .environment(WatchSessionManager())
    }
}

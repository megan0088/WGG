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

    var setNumberLabel: String {
        let n = sessionManager.setNumber(for: exercise)
        switch n % 10 {
        case 1 where n % 100 != 11: return "\(n)st Set"
        case 2 where n % 100 != 12: return "\(n)nd Set"
        case 3 where n % 100 != 13: return "\(n)rd Set"
        default: return "\(n)th Set"
        }
    }

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()
            if isEditing { editView } else { confirmView }
        }
        .navigationBarBackButtonHidden(true)
        .background(
            NavigationLink(isActive: $goToRest) {
                WatchRestTimerView(
                    exercise: exercise,
                    exercises: exercises,
                    weight: editedWeight,
                    completedReps: editedReps
                )
            } label: { EmptyView() }
        )
    }

    // MARK: - Confirm View
    private var confirmView: some View {
        VStack(spacing: 0) {
            // Set number label
            Text(setNumberLabel)
                .font(.system(size: 12, weight: .bold, design: .default))
                .foregroundStyle(Color.brandAccent)
                .padding(.top, 8)

            // Routine + Exercise name
            VStack(spacing: 1) {
                Text(sessionManager.currentRoutineName)
                    .font(.caption2)
                    .foregroundStyle(Color.brandSecondary)
                Text(exercise.name)
                    .font(.caption2)
                    .foregroundStyle(Color.brandSecondary)
            }
            .padding(.top, 2)

            Spacer()

            // Reps
            Text("\(editedReps) reps")
                .font(.system(size: 32, weight: .black, design: .default))
                .foregroundStyle(Color.brandPrimaryText)

            // Weight
            Text(weightLabel(editedWeight))
                .font(.caption)
                .foregroundStyle(Color.brandSecondary)
                .padding(.top, 2)

            Spacer()

            // Buttons
            HStack(spacing: 8) {
                Button {
                    isEditing = true
                } label: {
                    Label("Edit", systemImage: "pencil")
                        .font(.caption2.bold())
                        .foregroundStyle(Color.brandPrimaryText)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.brandSecondary.opacity(0.25))

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

    // MARK: - Edit View (unchanged)
    private var editView: some View {
        VStack(spacing: 0) {
            Text("EDIT SET")
                .font(.system(size: 10, weight: .bold, design: .default))
                .foregroundStyle(Color.brandSecondary)
                .padding(.top, 8)
                .padding(.bottom, 4)

            ScrollView {
                VStack(spacing: 10) {
                    // Reps editor
                    HStack(spacing: 0) {
                        Button { editedReps = max(1, editedReps - 1) } label: {
                            Image(systemName: "minus").frame(width: 32, height: 32)
                        }
                        .buttonStyle(.bordered).tint(Color.brandSecondary)

                        Spacer()

                        VStack(spacing: 0) {
                            Text("\(editedReps)")
                                .font(.system(size: 26, weight: .black, design: .default))
                                .foregroundStyle(Color.brandAccent)
                                .contentTransition(.numericText())
                            Text("reps").font(.system(size: 9)).foregroundStyle(Color.brandSecondary)
                        }

                        Spacer()

                        Button { editedReps = min(50, editedReps + 1) } label: {
                            Image(systemName: "plus").frame(width: 32, height: 32)
                        }
                        .buttonStyle(.bordered).tint(Color.brandSecondary)
                    }
                    .padding(.horizontal, 8)

                    // Weight editor
                    HStack(spacing: 0) {
                        Button { editedWeight = max(0, editedWeight - 2.5) } label: {
                            Image(systemName: "minus").frame(width: 32, height: 32)
                        }
                        .buttonStyle(.bordered).tint(Color.brandSecondary)

                        Spacer()

                        VStack(spacing: 0) {
                            Text("\(editedWeight, specifier: "%.1f")")
                                .font(.system(size: 22, weight: .black, design: .default))
                                .foregroundStyle(Color.brandAccent)
                                .contentTransition(.numericText())
                            Text("kg").font(.system(size: 9)).foregroundStyle(Color.brandSecondary)
                        }

                        Spacer()

                        Button { editedWeight = min(300, editedWeight + 2.5) } label: {
                            Image(systemName: "plus").frame(width: 32, height: 32)
                        }
                        .buttonStyle(.bordered).tint(Color.brandSecondary)
                    }
                    .padding(.horizontal, 8)

                    Button("Done") { isEditing = false }
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

    private func weightLabel(_ value: Double) -> String {
        let kg = Int(value)
        let dec = Int(round((value - Double(kg)) * 100))
        return String(format: "%d,%02d kg", kg, dec)
    }
}

#Preview {
    NavigationStack {
        WatchSetDoneView(
            exercise: WatchExercise(name: "Chest Dip", muscleGroup: "Chest"),
            exercises: WatchRoutine.mock.exercises,
            weight: 15.25,
            reps: 7,
            setDuration: 45
        )
        .environment({
            let m = WatchSessionManager()
            m.currentRoutineName = "Pull Day"
            return m
        }())
    }
}

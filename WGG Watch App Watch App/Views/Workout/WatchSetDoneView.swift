import SwiftUI

struct WatchSetDoneView: View {
    let exercise: WatchExercise
    let weight: Double
    let reps: Int

    @State private var editedReps: Double
    @State private var goToRest = false
    @State private var isEditing = false
    @FocusState private var crownFocused: Bool

    init(exercise: WatchExercise, weight: Double, reps: Int) {
        self.exercise = exercise
        self.weight = weight
        self.reps = reps
        self._editedReps = State(initialValue: Double(reps))
    }

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            VStack(spacing: 4) {

                Text("Set done?")
                    .font(.caption2)
                    .foregroundStyle(Color.brandSecondary)
                    .padding(.top, 8)

                Spacer()

                if isEditing {
                    VStack(spacing: 2) {
                        Text("\(Int(editedReps))")
                            .font(.system(size: 40, weight: .black, design: .rounded))
                            .foregroundStyle(Color.brandAccent)
                            .contentTransition(.numericText())
                            .focused($crownFocused)
                            .digitalCrownRotation(
                                $editedReps,
                                from: 1, through: 50, by: 1,
                                sensitivity: .medium,
                                isContinuous: false
                            )
                            .onAppear { crownFocused = true }
                        Text("reps")
                            .font(.caption2)
                            .foregroundStyle(Color.brandSecondary)
                    }
                } else {
                    VStack(spacing: 2) {
                        Text("\(Int(editedReps)) reps")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundStyle(Color.brandAccent)
                        Text("\(weight, specifier: "%.1f") kg")
                            .font(.caption)
                            .foregroundStyle(Color.brandSecondary)
                    }
                }

                Spacer()

                HStack(spacing: 8) {
                    Button("Edit") {
                        isEditing.toggle()
                    }
                    .buttonStyle(.bordered)
                    .tint(Color.brandSecondary)
                    .font(.caption2)

                    Button {
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
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToRest) {
            WatchRestTimerView(
                exercise: exercise,
                weight: weight,
                completedReps: Int(editedReps)
            )
        }
    }
}

#Preview {
    NavigationStack {
        WatchSetDoneView(
            exercise: WatchExercise(name: "Bench Press", muscleGroup: "Chest"),
            weight: 82.5,
            reps: 8
        )
    }
}

import SwiftUI

struct WatchWorkoutView: View {
    let routines = WatchRoutine.mockRoutines
    @Environment(WatchSessionManager.self) private var sessionManager

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                ForEach(routines) { routine in
                    NavigationLink {
                        WatchExercisePickerView(exercises: routine.exercises)
                            .onAppear { sessionManager.currentRoutineName = routine.name }
                    } label: {
                        Text(routine.name)
                            .font(.body.bold())
                            .foregroundStyle(Color.brandPrimaryText)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
        }
        .navigationTitle("Choose Routine")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        WatchWorkoutView()
            .environment(WatchSessionManager())
    }
}

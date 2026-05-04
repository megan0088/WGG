import SwiftUI

struct WatchWorkoutView: View {
    let routine = WatchRoutine.mock

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {

                Text("TODAY")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.brandSecondary)
                    .padding(.horizontal, 12)
                    .padding(.top, 8)

                Text(routine.name)
                    .font(.title3.bold())
                    .foregroundStyle(Color.brandPrimaryText)
                    .padding(.horizontal, 12)
                    .padding(.top, 2)

                Text("\(routine.exercises.count) exercises")
                    .font(.caption2)
                    .foregroundStyle(Color.brandSecondary)
                    .padding(.horizontal, 12)
                    .padding(.top, 2)

                Spacer()

                NavigationLink {
                    WatchWeightInputView(exercise: routine.exercises[0])
                } label: {
                    Text("Start Workout")
                        .font(.footnote.bold())
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.brandAccent)
                .padding(.horizontal, 12)

                HStack(spacing: 4) {
                    Text("🔥")
                        .font(.caption2)
                    Text("14 day streak")
                        .font(.caption2)
                        .foregroundStyle(Color.brandSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 6)
                .padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    NavigationStack {
        WatchWorkoutView()
    }
}

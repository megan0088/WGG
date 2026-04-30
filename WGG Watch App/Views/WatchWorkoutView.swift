import SwiftUI

struct WatchWorkoutView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "figure.run")
                .font(.largeTitle)
                .foregroundStyle(.tint)
            Text("Workout")
                .font(.headline)
        }
        .navigationTitle("Workout")
    }
}

#Preview {
    WatchWorkoutView()
}

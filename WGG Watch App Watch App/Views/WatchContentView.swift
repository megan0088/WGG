import SwiftUI

struct WatchContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Dashboard", destination: WatchDashboardView())
                NavigationLink("Workout", destination: WatchWorkoutView())
            }
            .navigationTitle("WGG")
        }
    }
}

#Preview {
    WatchContentView()
}

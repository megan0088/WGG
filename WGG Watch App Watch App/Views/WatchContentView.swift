import SwiftUI

struct WatchContentView: View {
    @Environment(WatchSessionManager.self) private var sessionManager

    var body: some View {
        if sessionManager.isWorkoutActive {
            NavigationStack {
                WatchWorkoutView()
            }
        } else {
            NavigationStack {
                WatchHomeView()
            }
        }
    }
}

#Preview {
    WatchContentView()
        .environment(WatchSessionManager())
}

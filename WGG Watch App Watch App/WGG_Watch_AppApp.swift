import SwiftUI

@main
struct WGGWatchApp: App {
    @State private var sessionManager = WatchSessionManager()

    var body: some Scene {
        WindowGroup {
            WatchContentView()
                .environment(sessionManager)
                .onAppear {
                    sessionManager.activate()
                }
        }
    }
}

import SwiftUI

struct WatchDashboardView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "chart.bar.fill")
                .font(.largeTitle)
                .foregroundStyle(.tint)
            Text("Dashboard")
                .font(.headline)
        }
        .navigationTitle("Dashboard")
    }
}

#Preview {
    WatchDashboardView()
}

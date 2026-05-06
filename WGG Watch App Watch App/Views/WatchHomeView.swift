import SwiftUI

struct WatchHomeView: View {
    @Environment(WatchSessionManager.self) private var sessionManager

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            VStack(spacing: 12) {
                Text("Start Workout?")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundStyle(Color.brandPrimaryText)

                Button {
                    sessionManager.isWorkoutActive = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.brandAccent)
                            .frame(width: 80, height: 80)
                        Image(systemName: "play.fill")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundStyle(.black)
                            .offset(x: 3)
                    }
                }
                .buttonStyle(.plain)

                HStack(spacing: 4) {
                    Text("🔥")
                        .font(.caption2)
                    Text("14 Days Streak")
                        .font(.caption2)
                        .foregroundStyle(Color.brandSecondary)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        WatchHomeView()
            .environment(WatchSessionManager())
    }
}

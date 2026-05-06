import SwiftUI

struct WatchHomeView: View {
    @Environment(WatchSessionManager.self) private var sessionManager

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            VStack(spacing: 10) {
                Text("Start Workout?")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
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

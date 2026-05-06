import SwiftUI

struct WatchSummaryView: View {
    @Environment(WatchSessionManager.self) private var sessionManager

    var sendStatusIcon: String {
        switch sessionManager.sendStatus {
        case .idle: return "iphone.and.arrow.up"
        case .sending: return "arrow.trianglehead.clockwise"
        case .sent: return "checkmark.circle.fill"
        case .queued: return "clock.arrow.trianglehead.counterclockwise.rotate.90"
        case .failed: return "exclamationmark.circle"
        }
    }

    var sendStatusLabel: String {
        switch sessionManager.sendStatus {
        case .idle: return "Send to iPhone"
        case .sending: return "Sending..."
        case .sent: return "Sent!"
        case .queued: return "Queued"
        case .failed: return "Retry"
        }
    }

    var sendStatusForeground: Color {
        switch sessionManager.sendStatus {
        case .sent, .queued: return Color.brandAccent
        case .failed: return .red
        default: return .black
        }
    }

    var sendStatusTint: Color {
        switch sessionManager.sendStatus {
        case .sent, .queued: return Color.brandSecondary.opacity(0.3)
        case .failed: return .red.opacity(0.8)
        default: return Color.brandAccent
        }
    }

    var totalVolume: Double {
        sessionManager.loggedExercises
            .flatMap(\.sets)
            .reduce(0) { $0 + $1.weight * Double($1.reps) }
    }

    var body: some View {
        ZStack {
            Color.brandBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                Text("DONE!")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.brandAccent)
                    .padding(.top, 8)
                    .padding(.bottom, 4)

                ScrollView {
                    VStack(spacing: 6) {

                        // Total volume
                        VStack(spacing: 2) {
                            Text("\(Int(totalVolume)) kg")
                                .font(.system(size: 26, weight: .black, design: .rounded))
                                .foregroundStyle(Color.brandPrimaryText)
                            Text("total volume")
                                .font(.caption2)
                                .foregroundStyle(Color.brandSecondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.brandSecondary.opacity(0.1))
                        .cornerRadius(8)

                        // Exercise breakdown
                        ForEach(sessionManager.loggedExercises) { ex in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(ex.name)
                                        .font(.caption2.bold())
                                        .foregroundStyle(Color.brandPrimaryText)
                                        .lineLimit(1)
                                    Text("\(ex.sets.count) sets")
                                        .font(.system(size: 9))
                                        .foregroundStyle(Color.brandSecondary)
                                }
                                Spacer()
                                Text("\(ex.sets.map { $0.reps }.reduce(0, +)) reps")
                                    .font(.caption2)
                                    .foregroundStyle(Color.brandSecondary)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.brandSecondary.opacity(0.07))
                            .cornerRadius(6)
                        }

                        // Send to iPhone button
                        Button {
                            sessionManager.sendToPhone()
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: sendStatusIcon)
                                    .font(.caption2)
                                Text(sendStatusLabel)
                                    .font(.caption2.bold())
                            }
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(sendStatusForeground)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(sendStatusTint)
                        .disabled(sessionManager.sendStatus == .sent || sessionManager.sendStatus == .queued || sessionManager.sendStatus == .sending)

                        if sessionManager.sendStatus == .queued {
                            Text("Will sync when iPhone app opens")
                                .font(.system(size: 9))
                                .foregroundStyle(Color.brandSecondary)
                                .multilineTextAlignment(.center)
                        } else if sessionManager.sendStatus == .failed {
                            Text("Failed — tap to retry")
                                .font(.system(size: 9))
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                        }

                        // Back to home
                        Button {
                            sessionManager.reset()
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "house.fill")
                                    .font(.system(size: 9))
                                Text("Back to Home")
                                    .font(.system(size: 10, weight: .medium))
                            }
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.brandSecondary)
                        }
                        .buttonStyle(.bordered)
                        .tint(Color.brandSecondary.opacity(0.4))
                    }
                    .padding(.horizontal, 8)
                    .padding(.bottom, 8)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        WatchSummaryView()
            .environment({
                let m = WatchSessionManager()
                m.logSet(exercise: WatchExercise(name: "Pull Up", muscleGroup: "Back"), weight: 0, reps: 8, setDuration: 45)
                m.logSet(exercise: WatchExercise(name: "Pull Up", muscleGroup: "Back"), weight: 0, reps: 7, setDuration: 38)
                m.logSet(exercise: WatchExercise(name: "Bent Over Row", muscleGroup: "Back"), weight: 60, reps: 10, setDuration: 52)
                return m
            }())
    }
}

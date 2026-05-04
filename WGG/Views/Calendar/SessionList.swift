//
//  SessionList.swift
//  WGG
//
//  Created by Stepanus Imanuel on 02/05/26.
//

import SwiftUI

struct SessionListView: View {
    let date: Date
    let calendar = Calendar.current
    
    var sessionsForDate: [WorkoutSession] {
        DashboardData.sessions.filter {
            calendar.isDate($0.date, inSameDayAs: date)
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            if sessionsForDate.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "dumbbell.fill")
                        .font(.largeTitle)
                    Text("No Workouts")
                        .font(.headline)
                }
                .foregroundStyle(.gray.opacity(0.5))
                .padding(.top, 40)
                .frame(maxWidth: .infinity)
            } else {
                ForEach(sessionsForDate) { session in
                    SessionCard(session: session)
                }
            }
        }
        .padding(.bottom, 30)
    }
}

#Preview {
    SessionListView(date: Date())
}

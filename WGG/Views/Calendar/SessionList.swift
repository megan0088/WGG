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
        VStack {
            if sessionsForDate.isEmpty {
                ContentUnavailableView("No Workouts", systemImage: "dumbbell.fill")
                    .foregroundStyle(.gray)
                    .frame(height: 200)
            } else {
                ScrollView {
                    ForEach(sessionsForDate) { session in
                        SessionCard(session: session)
                    }
                }
                .frame(minHeight: 200)
            }
        }
    }
}

#Preview {
    SessionListView(date: Date())
}

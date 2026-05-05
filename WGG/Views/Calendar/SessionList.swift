//
//  SessionList.swift
//  WGG
//
//  Created by Stepanus Imanuel on 02/05/26.
//

import SwiftUI
import _SwiftData_SwiftUI

struct SessionListView: View {
    @Query(sort: \Session.date, order: .reverse)
    var sessions: [Session]
    
    let date: Date
    let calendar = Calendar.current
    
    var sessionsForDate: [Session] {
        sessions.filter {
            calendar.isDate($0.date, inSameDayAs: date) && $0.isCompleted
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

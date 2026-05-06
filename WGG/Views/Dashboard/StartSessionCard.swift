//
//  StartSessionCard.swift
//  WGG
//
//  Created by Stepanus Imanuel on 01/05/26.
//

import SwiftUI
import SwiftData

struct StartSessionCard: View {
    
    @Binding var selectedTab: Tab
    
    @Query(sort: \Session.date, order: .reverse)
    var sessions: [Session]
    
    var last: Session? {
        sessions.first(where: { $0.isCompleted })
    }
    
    var body: some View {
        // tombol start session
        ZStack {
            Button {
                selectedTab = .workout
            } label: {
                HStack {
                    if let last = last,
                       Calendar.current.isDateInToday(last.date) {
                        Text("Start Another Session")
                            .fontWeight(.bold)
                    } else {
                        Text("Start Today's Session")
                            .fontWeight(.bold)
                    }
                    Image(systemName: "chevron.right")
                        .font(.subheadline)
                        .padding(.leading, 4)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("Accent"))
                .foregroundStyle(.black)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        
        // MARK: session complete summary for today
        if let last = last,
           Calendar.current.isDateInToday(last.date) {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    HStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundStyle(Color.accent)
                            .font(.headline)
                        Text("Last Session")
                            .font(.headline)
                            .foregroundStyle(Color.accent)
                    }
                    Spacer()
                    Text(last.date, format: .dateTime.hour().minute())
                        .font(.subheadline)
                        .foregroundStyle(Color("PrimaryText"))
                }
                
                Text(last.routine?.title ?? "Workout")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                HStack(spacing: 16) {
                    VStack (alignment: .leading) {
                        Text("\(minToHourMin(minutes: totalDuration(session: last)))")
                            .foregroundStyle(Color.accent)
                            .fontWeight(.bold)
                            .font(.title2)
                        Text("Duration")
                            .foregroundStyle(Color("BrandSecondary"))
                            .font(.caption)
                    }
                    
                    VStack (alignment: .leading) {
                        Text("\(totalSets(session: last))")
                            .foregroundStyle(Color.accent)
                            .fontWeight(.bold)
                            .font(.title2)
                        Text("Sets")
                            .foregroundStyle(Color("BrandSecondary"))
                            .font(.caption)
                    }
                    
                    VStack (alignment: .leading) {
                        Text("\(Int(totalVolume(session: last))) kg")
                            .foregroundStyle(Color.accent)
                            .fontWeight(.bold)
                            .font(.title2)
                        Text("Volume")
                            .foregroundStyle(Color("BrandSecondary"))
                            .font(.caption)
                    }
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(18)
            .background(Color(#colorLiteral(red: 0.0533, green: 0.1584, blue: 0.0579, alpha: 1)))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.accent.opacity(0.3), lineWidth: 2.76)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    // MARK: - Calculations
    
    func totalDuration(session: Session) -> Int {
        let totalSeconds = session.sessionExercises
            .flatMap { $0.sets }
            .reduce(0) { partial, set in
                partial + (set.setDuration ?? 0) + (set.restDuration ?? 0)
            }
        
        return Int(totalSeconds / 60)
    }
    
    func totalSets(session: Session) -> Int {
        session.sessionExercises.reduce(0) { $0 + $1.sets.count }
    }
    
    func totalVolume(session: Session) -> Double {
        session.sessionExercises
            .flatMap { $0.sets }
            .reduce(0.0) { $0 + ($1.weight * Double($1.reps)) }
    }
    
    // MARK: Minute to Hour minute
    func minToHourMin(minutes: Int) -> String {
        if(minutes <= 60) {
            return "\(minutes)m"
        }
        let hour: Int = minutes / 60
        let min: Int = minutes % 60
        
        return "\(hour)h \(min)m"
    }
}

#Preview {
    StartSessionCard(selectedTab: .constant(.home))
}

//
//  SessionCard.swift
//  WGG
//
//  Created by Stepanus Imanuel on 02/05/26.
//

import SwiftUI

struct SessionCard: View {
    let session: WorkoutSession
    @State private var isExpanded = false 
    
    var totalVolume: Double {
        session.exercises.reduce(0) { exSum, ex in
            exSum + ex.sets.reduce(0) { $0 + ($1.weight * Double($1.reps)) }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // header
            Button {
                withAnimation(.spring()) { isExpanded.toggle() }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.title)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 16) {
                            HStack(spacing: 6) {
                                Image(systemName: "dumbbell")
                                    .foregroundStyle(Color("Secondary"))
                                    .font(.caption)
                                Text("\(session.exercises.count) Exercises")
                                    .font(.caption)
                                    .foregroundStyle(Color("Secondary"))
                            }
                            
                            HStack(spacing: 6) {
                                Image(systemName: "figure.strengthtraining.traditional")
                                    .foregroundStyle(Color("Secondary"))
                                    .font(.caption)
                                Text("\(session.exercises.count) kg")
                                    .font(.caption)
                                    .foregroundStyle(Color("Secondary"))
                            }
                            
                            HStack(spacing: 6) {
                                Image(systemName: "clock")
                                    .foregroundStyle(Color("Secondary"))
                                    .font(.caption)
                                Text("\(session.exercises.count) (rest: 60m)")
                                    .font(.caption)
                                    .foregroundStyle(Color("Secondary"))
                            }
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .foregroundStyle(Color("Secondary"))
                }
            }
            
            // list exercise ketika user klik
            if isExpanded {
                Divider().background(Color.gray.opacity(0.3))
                
                ForEach(session.exercises) { exercise in
                    ExerciseRow(exercise: exercise)
                }
            }
        }
        .padding()
        .background(Color(#colorLiteral(red: 0.1013579145, green: 0.1013579145, blue: 0.1013579145, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}

#Preview {
    SessionCard(session: WorkoutSession(title: "Test day", date: Date(), exercises: [
        Exercise(
            name: "Tes exercise",
            muscle: "Back",
            sets: [
                ExerciseSet(reps: 10, weight: 20, rest: 60),
                ExerciseSet(reps: 8, weight: 25, rest: 75),
                ExerciseSet(reps: 6, weight: 30, rest: 90)
            ],
            duration: 15
        )
    ]))
}

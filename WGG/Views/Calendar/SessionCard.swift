//
//  SessionCard.swift
//  WGG
//
//  Created by Stepanus Imanuel on 02/05/26.
//

import SwiftUI

struct SessionCard: View {
    let session: Session
    @State private var isExpanded = false
    
    var totalVolume: Double {
        session.sessionExercises
            .flatMap {$0.sets}
            .reduce(0.0) { $0 + ($1.weight * Double($1.reps)) }
    }
    
    var totalDurationText: String {
        let sets = session.sessionExercises
            .flatMap { $0.sets }
            .filter { $0.isCompleted }
        
        let seconds = sets.reduce(0) { result, set in
            result + (set.setDuration ?? 0) + (set.restDuration ?? 0)
        }
        
        return "\(Int(seconds / 60))m"
    }

    var totalRestText: String {
        let sets = session.sessionExercises
            .flatMap { $0.sets }
            .filter { $0.isCompleted }
        
        let seconds = sets.reduce(0) { result, set in
            result + (set.restDuration ?? 0)
        }
        
        return "\(Int(seconds / 60))m"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // header
            Button {
                withAnimation(.spring()) { isExpanded.toggle() }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.routine?.title ?? "Workout")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 16) {
                            HStack(spacing: 6) {
                                Image(systemName: "dumbbell")
                                    .foregroundStyle(Color("BrandSecondary"))
                                    .font(.caption)
                                Text("\(session.sessionExercises.count) Exercises")
                                    .font(.caption)
                                    .foregroundStyle(Color("BrandSecondary"))
                            }
                            
                            HStack(spacing: 6) {
                                Image(systemName: "figure.strengthtraining.traditional")
                                    .foregroundStyle(Color("BrandSecondary"))
                                    .font(.caption)
                                Text("\(Int(totalVolume)) kg")
                                    .font(.caption)
                                    .foregroundStyle(Color("BrandSecondary"))
                            }
                            
                            HStack(spacing: 6) {
                                Image(systemName: "clock")
                                    .foregroundStyle(Color("BrandSecondary"))
                                    .font(.caption)
                                Text("\(totalDurationText) (rest: \(totalRestText))")
                                    .font(.caption)
                                    .foregroundStyle(Color("BrandSecondary"))
                            }
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .foregroundStyle(Color("BrandSecondary"))
                }
            }
            
            // list exercise ketika user klik
            if isExpanded {
                Divider().background(Color.gray.opacity(0.3))
                
                ForEach(session.sessionExercises) { se in
                    if se.exercise != nil {
                        ExerciseRow(exercise: se,workoutColor: se.exercise?.themeColor)
                    }
                }
            }
        }
        .padding()
        .background(Color(#colorLiteral(red: 0.1013579145, green: 0.1013579145, blue: 0.1013579145, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    func formatTime(_ seconds: Int) -> String {
        let total = Int(seconds)
        let minutes = total / 60
        let secs = total % 60
        return String(format: "%dm %02ds", minutes, secs)
    }
}

#Preview {
    let exercise1 = Exercise(name: "Bench Press", muscleGroup: "Chest")
    let exercise2 = Exercise(name: "Shoulder Press", muscleGroup: "Shoulders")
    
    let routine = Routine(title: "Push Day", exercises: [exercise1, exercise2])
    
    let session = Session(date: Date(), routine: routine)
    session.isCompleted = true
    
    let se1 = SessionExercise(session: session, exercise: exercise1)
    se1.sets = [
        SessionSet(setNumber: 1, reps: 10, weight: 60),
        SessionSet(setNumber: 2, reps: 8, weight: 70)
    ]
    se1.sets.forEach {
        $0.setDuration = 40
        $0.restDuration = 60
    }
    
    let se2 = SessionExercise(session: session, exercise: exercise2)
    se2.sets = [
        SessionSet(setNumber: 1, reps: 12, weight: 30),
        SessionSet(setNumber: 2, reps: 10, weight: 35)
    ]
    se2.sets.forEach {
        $0.setDuration = 30
        $0.restDuration = 45
    }
    
    session.sessionExercises = [se1, se2]
    
    return SessionCard(session: session)
        .background(.black)
}

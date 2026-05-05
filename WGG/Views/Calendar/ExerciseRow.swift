//
//  ExerciseRow.swift
//  WGG
//
//  Created by Stepanus Imanuel on 02/05/26.
//

import SwiftUI

struct ExerciseRow: View {
    let exercise: SessionExercise
    let workoutColor: Color?
    @State private var isCollapsed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // header
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { isCollapsed.toggle() }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 8))
                        .foregroundStyle(workoutColor ?? Color("Accent"))
                    
                    let sets = exercise.sets.filter { $0.isCompleted }

                    let totalSeconds = sets.reduce(0) {
                        $0 + ($1.setDuration ?? 0) + ($1.restDuration ?? 0)
                    }

                    let totalRestSeconds = sets.reduce(0) {
                        $0 + ($1.restDuration ?? 0)
                    }

                    HStack(spacing: 6) {
                        Text(exercise.exercise?.name ?? "Exercise")
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundStyle(.white)
                        
                        Text("\(formatTime(totalSeconds)) (rest: \(formatTime(totalRestSeconds)))")
                            .font(.system(size: 10))
                            .foregroundStyle(Color("BrandSecondary"))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "pencil")
                        .font(.subheadline)
                        .foregroundStyle(Color("BrandSecondary"))
                }
                .padding(12)
                .background(Color(#colorLiteral(red: 0.1462407112, green: 0.1462407112, blue: 0.1462407112, alpha: 1)))
            }
            
            // tabel
            if !isCollapsed {
                VStack(spacing: 0) {
                    // Header Tabel
                    HStack(spacing: 0) {
                        Text("Set").frame(width: 35, alignment: .leading)
                        Spacer()
                        Text("Reps").frame(width: 45, alignment: .center)
                        Spacer()
                        Text("Weight").frame(width: 65, alignment: .center)
                    }
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color("BrandSecondary"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(#colorLiteral(red: 0.1242692545, green: 0.1242692545, blue: 0.1242692545, alpha: 1)))

                    // Data List
                    VStack(spacing: 12) {
                        ForEach(exercise.sets.indices, id: \.self) { index in
                            let set = exercise.sets[index]
                            HStack(spacing: 0) {
                                // Kolom Set
                                Text("\(index + 1)")
                                    .frame(width: 35, alignment: .leading)
                                    .foregroundStyle(Color("BrandSecondary"))
                                
                                Spacer()
                                
                                // Kolom Reps
                                Text("\(set.reps)")
                                    .frame(width: 45, alignment: .center)
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                // Kolom Weight
                                Text("\(Int(set.weight))kg")
                                    .frame(width: 65, alignment: .center)
                                    .foregroundStyle(Color("Accent"))
                            }
                            .font(.system(size: 12, weight: .medium))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
        }
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.vertical, 4)
    }
    
    func formatTime(_ seconds: Int) -> String {
        let total = Int(seconds)
        let minutes = total / 60
        let secs = total % 60
        return String(format: "%dm %02ds", minutes, secs)
    }
}

#Preview {
    let ex = Exercise(name: "Bench Press", muscleGroup: "Chest")
    let session = Session(date: Date())
    
    let se = SessionExercise(session: session, exercise: ex)
    se.sets = [
        SessionSet(setNumber: 1, reps: 10, weight: 60),
        SessionSet(setNumber: 2, reps: 8, weight: 70)
    ]
    se.sets.forEach {
        $0.setDuration = 40
        $0.restDuration = 60
    }
    
    return ExerciseRow(exercise: se, workoutColor: Color.accent)
        .background(.black)
}

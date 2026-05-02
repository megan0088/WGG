//
//  ExerciseRow.swift
//  WGG
//
//  Created by Stepanus Imanuel on 02/05/26.
//

import SwiftUI

struct ExerciseRow: View {
    let exercise: Exercise
    @State private var isCollapsed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // header
            Button {
                withAnimation(.easeInOut(duration: 0.2)) { isCollapsed.toggle() }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "square.fill")
                        .font(.system(size: 8))
                        .foregroundStyle(Color("Accent"))
                        
                    let timeStats = getSessionTimeStats([exercise])

                    HStack(spacing: 6) {
                        Text(exercise.name)
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundStyle(.white)
                        
                        Text("\(timeStats.total) (rest: \(timeStats.rest))")
                            .font(.system(size: 10))
                            .foregroundStyle(Color("Secondary"))
                    }
                    
                    Spacer()
                    
                    Image(systemName: "pencil")
                        .font(.subheadline)
                        .foregroundStyle(Color("Secondary"))
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
                        Spacer()
                        Text("Rest").frame(width: 45, alignment: .trailing)
                    }
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(Color("Secondary"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color(#colorLiteral(red: 0.1242692545, green: 0.1242692545, blue: 0.1242692545, alpha: 1)))

                    // Data List
                    VStack(spacing: 12) {
                        ForEach(0..<exercise.sets.count, id: \.self) { index in
                            let set = exercise.sets[index]
                            HStack(spacing: 0) {
                                // Kolom Set
                                Text("\(index + 1)")
                                    .frame(width: 35, alignment: .leading)
                                    .foregroundStyle(Color("Secondary"))
                                
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
                                
                                Spacer()
                                
                                // Kolom Rest
                                Text("\(set.rest)s")
                                    .frame(width: 45, alignment: .trailing)
                                    .foregroundStyle(.white)
                            }
                            .font(.system(size: 12, weight: .medium, design: .monospaced))
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

    // get durasi dan rest time formatted
    func getSessionTimeStats(_ exercises: [Exercise]) -> (total: String, rest: String) {
        let exerciseMinutes = exercises.reduce(0) { $0 + $1.duration }
        let totalRestSeconds = exercises.reduce(0) { exSum, ex in
            exSum + ex.sets.reduce(0) { $0 + $1.rest }
        }
        
        let restMinutes = totalRestSeconds / 60
        let totalMinutes = exerciseMinutes + restMinutes
        
        let totalFormatted = totalMinutes >= 60 ? "\(totalMinutes/60)h \(totalMinutes%60)m" : "\(totalMinutes)m"
        let restFormatted = "\(restMinutes)m \(totalRestSeconds % 60)s"
        
        return (totalFormatted, restFormatted)
    }
}

#Preview {
    ExerciseRow(
        exercise: Exercise(name: "Test", muscle: "Leg", sets: [
            ExerciseSet(reps: 8, weight: 30, rest: 50),
            ExerciseSet(reps: 8, weight: 40, rest: 100)
        ], duration: 20)
    )
}

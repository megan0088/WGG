//
//  ExerciseRow.swift
//  WGG
//
//  Created by Stepanus Imanuel on 02/05/26.
//

import SwiftUI
import SwiftData

struct ExerciseRow: View {
    @Environment(\.modelContext) private var context

    
    let exercise: SessionExercise
    let workoutColor: Color?
    var sortedSets: [SessionSet] {
        exercise.sets.sorted(by: { $0.setNumber < $1.setNumber })
    }
    
    @State private var isCollapsed = false
    @State private var isEditing = false
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack(alignment: .trailing) {
            
            Button {
                context.delete(exercise)
                
                do {
                    try context.save()
                } catch {
                    print("Delete exercise failed")
                }
            } label: {
                Image(systemName: "trash")
                    .foregroundStyle(.white)
                    .frame(width: 60,height: 60)
                    .background(Color.red)
                    .clipShape(Circle())
            }
            
            mainContent
                .offset(x: offset)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 20)
                        .onChanged { value in
                            let horizontal = abs(value.translation.width)
                            let vertical = abs(value.translation.height)
                            guard horizontal > vertical * 1.5 else { return }
                            if value.translation.width < 0 {
                                offset = value.translation.width
                            }
                        }
                        .onEnded { value in
                            let horizontal = abs(value.translation.width)
                            let vertical = abs(value.translation.height)
                            guard horizontal > vertical * 1.5 else {
                                offset = 0
                                return
                            }
                            withAnimation {
                                if value.translation.width < -160 {
                                    context.delete(exercise)
                                    do {
                                        try context.save()
                                    } catch {
                                        print("Delete failed")
                                    }
                                } else if value.translation.width < -70 {
                                    offset = -75
                                } else {
                                    offset = 0
                                }
                            }
                        }
                )
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    var mainContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack(spacing: 12) {
                
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isCollapsed.toggle()
                    }
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
                    }
                }
                
                Spacer()
                
                Button {
                    isEditing.toggle()
                } label: {
                    Image(systemName: isEditing ? "checkmark" : "pencil")
                        .font(.subheadline)
                        .foregroundStyle(Color("BrandSecondary"))
                }
            }
            .padding(12)
            .background(Color(#colorLiteral(red: 0.1013579145, green: 0.1013579145, blue: 0.1013579145, alpha: 1)))
            
            if !isCollapsed {
                
                VStack(spacing: 0) {
                    
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
                    .background(Color(#colorLiteral(red: 0.1013579145, green: 0.1013579145, blue: 0.1013579145, alpha: 1)))
                    
                    VStack(spacing: 12) {
                        
                        ForEach(sortedSets) { set in
                            
                            HStack(spacing: 0) {
                                
                                Text("\(set.setNumber)")
                                    .frame(width: 35, alignment: .leading)
                                    .foregroundStyle(Color("BrandSecondary"))
                                
                                Spacer()
                                
                                if isEditing {
                                    
                                    TextField(
                                        "0",
                                        value: Binding(
                                            get: { set.reps },
                                            set: { set.reps = $0 }
                                        ),
                                        format: .number
                                    )
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 45)
                                    .foregroundStyle(.white)
                                    
                                } else {
                                    
                                    Text("\(set.reps)")
                                        .frame(width: 45, alignment: .center)
                                        .foregroundStyle(.white)
                                }
                                
                                Spacer()
                                
                                if isEditing {
                                    
                                    TextField(
                                        "0",
                                        value: Binding(
                                            get: { set.weight },
                                            set: { set.weight = $0 }
                                        ),
                                        format: .number.precision(.fractionLength(2))
                                    )
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 65)
                                    .foregroundStyle(Color("Accent"))
                                    
                                } else {
                                    
                                    Text("\(Int(set.weight))kg")
                                        .frame(width: 65, alignment: .center)
                                        .foregroundStyle(Color("Accent"))
                                }
                                
                                if isEditing {
                                    
                                    HStack(spacing: 14) {
                                        
                                        Button {
                                            insertSet(after: set)
                                        } label: {
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundStyle(Color.accent)
                                        }
                                        
                                        Button {
                                            deleteSet(set)
                                        } label: {
                                            Image(systemName: "trash")
                                                .foregroundStyle(.red)
                                        }
                                    }
                                    .padding(.leading, 12)
                                }
                            }
                            .font(.system(size: 12, weight: .medium))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .background(.black)
    }
    
    func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let secs = seconds % 60
        
        return String(format: "%dm %02ds", minutes, secs)
    }
    
    func insertSet(after set: SessionSet) {
        
        let sorted = exercise.sets.sorted {
            $0.setNumber < $1.setNumber
        }
        
        guard let index = sorted.firstIndex(where: {
            $0.id == set.id
        }) else { return }
        
        for i in (index + 1)..<sorted.count {
            sorted[i].setNumber += 1
        }
        
        let newSet = SessionSet(
            setNumber: set.setNumber + 1,
            reps: 0,
            weight: 0
        )
        
        newSet.isCompleted = true
        newSet.sessionExercise = exercise
        
        exercise.sets.append(newSet)
        
        try? context.save()
    }
    
    func deleteSet(_ set: SessionSet) {
        
        context.delete(set)
        
        let remaining = exercise.sets
            .filter { $0.id != set.id }
            .sorted { $0.setNumber < $1.setNumber }
        
        for (index, item) in remaining.enumerated() {
            item.setNumber = index + 1
        }
        
        try? context.save()
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

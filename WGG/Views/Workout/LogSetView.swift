//
//  LogSetView.swift
//  WGG
//
//  Created by George Maximillian Theodore on 02/05/26.
//

import SwiftUI
import SwiftData

struct LogSetView: View {
    
    @Environment(WorkoutManager.self) private var manager
    @Environment(\.dismiss) private var dismiss
    
    @State private var inputWeight: Double = 0.0
    @State private var inputReps: Int = 0
    @State private var completedSessionToView: Session?
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea()
            
                .fullScreenCover(isPresented: Bindable(manager).showRestTimer) {
                    RestTimeView()
                }
            
            ScrollView{
                
                VStack(alignment: .leading){
                    HStack{
                        Text(manager.activeSession?.date ?? Date(), style: .timer)
                            .font(.headline)
                            .foregroundStyle(Color.accent)
                            .padding(.vertical, 8)
                            .frame(width: 72)
                            .background(Color.accent.opacity(0.1))
                            .cornerRadius(16)
                        Spacer()
                        Text(manager.activeSession?.routine?.title ?? "Workout")
                            .font(Font.title.bold())
                            .foregroundStyle(Color.primaryText)
                        Spacer()
                        
                        Button {
                            completedSessionToView = manager.activeSession
                                
                            manager.finishWorkout()
                        } label: {
                            Text("Finish")
                                .font(.headline)
                                .foregroundStyle(Color.primaryText)
                                .padding(.vertical, 8)
                                .frame(width: 72)
                                .background(Color.primaryText.opacity(0.1))
                                .cornerRadius(16)
                        }
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            if let sessionExercises = manager.activeSession?.sessionExercises {
                                ForEach(sessionExercises) { sessionEx in
                                    let isSelected = manager.currentExercise?.id == sessionEx.id
                                    let exerciseName = sessionEx.exercise?.name ?? "Unknown"
                                    
                                    Button {
                                        manager.switchExercise(to: sessionEx)
                                    } label: {
                                        Text(exerciseName)
                                            .foregroundStyle(isSelected ? Color.accent : Color.primaryText.opacity(0.5))
                                            .padding(12)
                                            .background(isSelected ? Color.accent.opacity(0.1) : Color.primaryText.opacity(0.1))
                                            .cornerRadius(24)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 24)
                                                    .stroke(Color.accent.opacity(0.3), lineWidth: isSelected ? 1 : 0)
                                            )
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 16)
                    
                    if let currentEx = manager.currentExercise {
                        
                        // MARK: - EXERCISE INFO
                        VStack(alignment: .leading) {
                            Text(currentEx.exercise?.name ?? "Exercise")
                                .font(.title.bold())
                                .foregroundStyle(Color.primaryText)
                            
                            Text("\(currentEx.exercise?.muscleGroup ?? "") · Primary")
                                .font(.caption)
                                .foregroundStyle(Color.primaryText.opacity(0.5))
                        }
                        .padding(.bottom, 16)
                        
                        // Cek Set yang sedang aktif
                        let activeSetNumber = currentEx.sets.filter { !$0.isCompleted }.first?.setNumber ?? currentEx.sets.count
                        
                        Text("SET \(activeSetNumber)")
                            .font(.headline)
                            .foregroundStyle(Color.primaryText.opacity(0.5))
                        
                        // MARK: - INPUT NUMPAD
                        VStack(alignment: .leading) {
                            // WEIGHT INPUT
                            Text("WEIGHT")
                                .foregroundStyle(Color.primaryText.opacity(0.5))
                                .font(.subheadline.bold())
                            
                            HStack {
                                Button { inputWeight = max(0, inputWeight - 1) } label: { NumpadButton(icon: "minus") }
                                Spacer()
                                VStack {
                                    Text(String(format: "%.1f", inputWeight)) // Format 1 desimal
                                        .foregroundStyle(Color.primaryText)
                                        .font(.title.bold())
                                    Text("kg")
                                        .foregroundStyle(Color.primaryText.opacity(0.5))
                                }
                                Spacer()
                                Button { inputWeight += 1 } label: { NumpadButton(icon: "plus") }
                            }
                            
                            // Quick Add Weight Buttons
                            HStack {
                                Spacer()
                                QuickAddButton(text: "+1") { inputWeight += 1 }
                                QuickAddButton(text: "+2.5") { inputWeight += 2.5 }
                                QuickAddButton(text: "+5") { inputWeight += 5 }
                                Spacer()
                            }
                            
                            Divider().padding(.vertical, 20)
                            
                            // REPS INPUT
                            HStack {
                                Text("REPS")
                                    .foregroundStyle(Color.primaryText.opacity(0.5))
                                    .font(.subheadline.bold())
                                Spacer()
                                // Auto Watch Badge (Dibiarkan statis dulu)
                                HStack {
                                    Circle().fill(Color.accent).frame(width: 6, height: 6).shadow(color: Color.accent.opacity(0.5), radius: 4)
                                    Text("Auto · Watch").foregroundStyle(Color.primaryText.opacity(0.5)).font(.subheadline)
                                }.padding(8).background(Color.primaryText.opacity(0.1)).cornerRadius(16)
                            }
                            
                            HStack {
                                Button { inputReps = max(0, inputReps - 1) } label: { NumpadButton(icon: "minus") }
                                Spacer()
                                VStack {
                                    Text("\(inputReps)")
                                        .foregroundStyle(Color.primaryText)
                                        .font(.title.bold())
                                    Text("reps")
                                        .foregroundStyle(Color.primaryText.opacity(0.5))
                                }
                                Spacer()
                                Button { inputReps += 1 } label: { NumpadButton(icon: "plus") }
                            }
                        }
                        .padding(16)
                        .background(Color.primaryText.opacity(0.1))
                        .cornerRadius(16)
                        .padding(.bottom, 16)
                        
                        let isFinished = currentEx.isFinished
                        
                        // MARK: - TOMBOL LOG SET
                        Button {
                            // Simpan Set
                            manager.completeActiveSet(weight: inputWeight, reps: inputReps)
                            // Optional: Reset input untuk set berikutnya
                            // inputWeight = 0; inputReps = 0
                        } label: {
                            HStack {
                                Image(systemName: isFinished ? "lock.fill" : "checkmark")
                                Text(isFinished ? "Exercise Finished" : "Log Set")
                            }
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(isFinished ? Color.primaryText.opacity(0.5) : Color.background)
                            .background(isFinished ? Color.primaryText.opacity(0.1) : Color.accent)
                            .cornerRadius(16)
                            .padding(.bottom, 20)
                        }
                        .disabled(isFinished)
                        
                        // MARK: - SET HISTORY (THIS EXERCISE)
                        Text("THIS EXERCISE")
                            .font(.headline)
                            .foregroundStyle(Color.primaryText.opacity(0.5))
                        
                        ForEach(currentEx.sets.sorted(by: { $0.setNumber < $1.setNumber })) { set in
                            // Misal enum SetStatus kamu ada .completed dan .active
                            let status: setStatus = set.isCompleted ? .completed : .active
                            SetRow(
                                setNumber: set.setNumber,
                                weight: set.isCompleted ? "\(String(format: "%.1f", set.weight)) kg" : nil,
                                reps: set.isCompleted ? set.reps : nil,
                                status: status
                            )
                        }
                    } else {
                        // Jika tidak ada exercise yang dipilih/tersedia
                        Text("No exercise available in this session.")
                            .foregroundStyle(Color.primaryText.opacity(0.5))
                            .padding(.top, 40)
                    }
                }
                .padding(16)
            }
        }
        .navigationBarBackButtonHidden(true)
        
        .fullScreenCover(item: $completedSessionToView) { session in
            SessionCompleteView(session: session) {
                dismiss()
            }
        }
    }
}

#Preview {
    LogSetView()
        .environment(WorkoutManager())
        .modelContainer(for: [Routine.self, Exercise.self, Session.self, SessionExercise.self, SessionSet.self], inMemory: true)
}

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
    @Environment(\.modelContext) private var context
    
    @State private var inputWeight: Double = 0.0
    @State private var inputReps: Int = 0
    @State private var completedSessionToView: Session?
    
    @State private var showFinishConfirmation: Bool = false
    
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
                            showFinishConfirmation.toggle()
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
                        
                        // MARK: - INPUT NUMPAD (SCROLLABLE WHEEL)
                        VStack(alignment: .leading) {
                            
                            // WEIGHT INPUT
                            Text("WEIGHT")
                                .foregroundStyle(Color.primaryText.opacity(0.5))
                                .font(.subheadline.bold())
                                .padding(.bottom, -8) // Rapatkan jarak dengan wheel
                            
                            // Custom Binding untuk memecah Double ke dalam 2 Wheel
                            let weightIntBinding = Binding<Int>(
                                get: { Int(inputWeight) },
                                set: { inputWeight = Double($0) + inputWeight.truncatingRemainder(dividingBy: 1) }
                            )
                            
                            let weightDecBinding = Binding<Double>(
                                get: {
                                    // Bulatkan paksa ke kelipatan 0.25 agar wheel tidak kosong jika ada angka ganjil dari history
                                    let remainder = inputWeight.truncatingRemainder(dividingBy: 1)
                                    let snapped = round(remainder * 4) / 4.0
                                    return snapped == 1.0 ? 0.0 : snapped
                                },
                                set: { inputWeight = Double(Int(inputWeight)) + $0 }
                            )
                            
                            HStack(spacing: 0) {
                                Spacer()
                                
                                // Roda Kiri: Angka Bulat (0 - 500)
                                Picker("Weight", selection: weightIntBinding) {
                                    ForEach(0...500, id: \.self) { i in
                                        Text("\(i)").tag(i)
                                            .font(.title2.bold())
                                            .foregroundStyle(Color.primaryText)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 80, height: 120)
                                .clipped()
                                
                                // Pemisah Koma / Titik
                                Text(".")
                                    .font(.title.bold())
                                    .foregroundStyle(Color.primaryText)
                                    .padding(.bottom, 8)
                                
                                // Roda Kanan: Desimal (0.0, 0.25, 0.5, 0.75)
                                Picker("Decimal", selection: weightDecBinding) {
                                    Text("00").tag(0.0)
                                        .font(.title2.bold())
                                        .foregroundStyle(Color.primaryText)
                                    Text("25").tag(0.25)
                                        .font(.title2.bold())
                                        .foregroundStyle(Color.primaryText)
                                    Text("50").tag(0.50)
                                        .font(.title2.bold())
                                        .foregroundStyle(Color.primaryText)
                                    Text("75").tag(0.75)
                                        .font(.title2.bold())
                                        .foregroundStyle(Color.primaryText)
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 80, height: 120)
                                .clipped()
                                
                                Text("kg")
                                    .font(.headline)
                                    .foregroundStyle(Color.primaryText.opacity(0.5))
                                    .padding(.leading, 8)
                                
                                Spacer()
                            }
                            
                            Divider().padding(.vertical, 8)
                            
                            // REPS INPUT
                            HStack {
                                Text("REPS")
                                    .foregroundStyle(Color.primaryText.opacity(0.5))
                                    .font(.subheadline.bold())
                                Spacer()
                                // Auto Watch Badge
                                HStack {
                                    Circle().fill(Color.accent).frame(width: 6, height: 6).shadow(color: Color.accent.opacity(0.5), radius: 4)
                                    Text("Auto · Watch").foregroundStyle(Color.primaryText.opacity(0.5)).font(.subheadline)
                                }.padding(8).background(Color.primaryText.opacity(0.1)).cornerRadius(16)
                            }
                            
                            HStack {
                                Spacer()
                                
                                // Roda Repetisi (0 - 100)
                                Picker("Reps", selection: $inputReps) {
                                    ForEach(0...100, id: \.self) { i in
                                        Text("\(i)").tag(i)
                                            .font(.title2.bold())
                                            .foregroundStyle(Color.primaryText)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 80, height: 120)
                                .clipped()
                                
                                Text("reps")
                                    .font(.headline)
                                    .foregroundStyle(Color.primaryText.opacity(0.5))
                                    .padding(.leading, 8)
                                
                                Spacer()
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
                            let status: SetStatus = set.isCompleted ? .completed : .active
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
        // 3. FULL SCREEN COVER (Membuka layar summary jika sessionCompleteToView terisi)
        .fullScreenCover(item: $completedSessionToView) { session in
            SessionCompleteView(session: session) {
                dismiss()
            }
        }
        // 4. ALERT KONFIRMASI (Saat menekan tombol Finish)
        .alert("Finish Workout?", isPresented: $showFinishConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Finish", role: .none) {
                completedSessionToView = manager.activeSession
                manager.finishWorkout()
                try? context.save()
            }
        } message: {
            Text("Are you sure you want to finish this workout session?")
        }
        // 5. TRIGGER LAZY LOGGING (Dipanggil saat UI berubah)
        .onAppear {
            updateInputPlaceholders()
        }
        .onChange(of: manager.currentExercise) { _, _ in
            updateInputPlaceholders()
        }
        .onChange(of: manager.showRestTimer) { _, isShowingTimer in
            if !isShowingTimer {
                // Timer baru saja ditutup (user klik Next Set), perbarui placeholder!
                updateInputPlaceholders()
            }
        }
    }
    
    private func updateInputPlaceholders() {
        guard let currentEx = manager.currentExercise else { return }
        
        // Cari Set ke-berapa yang sedang aktif sekarang
        let activeSetNum = currentEx.sets.filter { !$0.isCompleted }.first?.setNumber ?? currentEx.sets.count
        
        // A. Cek database masa lalu (Sesi sebelumnya dari Routine yang sama)
        if let activeSession = manager.activeSession, let routine = activeSession.routine {
            let pastSessions = routine.sessions
                .filter { $0.id != activeSession.id && $0.date < activeSession.date }
                .sorted { $0.date > $1.date }
            
            // Cari Set yang sama (Misal: Set 2) dari Latihan yang sama (Misal: Pull Up) di sesi yang lalu
            if let lastSession = pastSessions.first,
               let pastEx = lastSession.sessionExercises.first(where: { $0.exercise?.id == currentEx.exercise?.id }),
               let pastSet = pastEx.sets.first(where: { $0.setNumber == activeSetNum && $0.isCompleted }) {
                
                inputWeight = pastSet.weight
                inputReps = pastSet.reps
                return // Berhenti di sini, berhasil dapat dari sesi lalu
            }
        }
        
        // B. Kalau ini pertama kali latihan routine tersebut, atau set-nya lebih banyak dari yang lalu
        // Fallback: Gunakan beban dari Set Terakhir yang baru saja dicatat di Sesi HARI INI
        if let lastLoggedSet = currentEx.sets.filter({ $0.isCompleted }).last {
            inputWeight = lastLoggedSet.weight
            inputReps = lastLoggedSet.reps
            return
        }
        
        // C. Kalau benar-benar belum ada data apa-apa (Blank Slate)
        inputWeight = 0.0
        inputReps = 0
    }
}

#Preview {
    LogSetView()
        .environment(WorkoutManager())
        .modelContainer(for: [Routine.self, Exercise.self, Session.self, SessionExercise.self, SessionSet.self], inMemory: true)
}

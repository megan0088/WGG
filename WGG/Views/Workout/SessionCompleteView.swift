//
//  SessionCompleteView.swift
//  WGG
//
//  Created by Stepanus Imanuel on 05/05/26.
//

import SwiftUI
import SwiftData

struct SessionCompleteView: View {
    // Terima data session dari halaman sebelumnya
    let session: Session
    let onDone: () -> Void
    
    // MARK: - Computed Properties (Penghitung Otomatis)
    
    var durationString: String {
        let diff = Date().timeIntervalSince(session.date)
        let mins = max(1, Int(diff) / 60) // Minimal 1 menit
        return "\(mins)m"
    }
    
    var totalSets: Int {
        // Gabungkan semua set dari semua exercise, lalu hitung yang isCompleted == true
        session.sessionExercises.flatMap { $0.sets }.filter { $0.isCompleted }.count
    }
    
    var totalExercises: Int {
        session.sessionExercises.filter { $0.sets.contains(where: { $0.isCompleted }) }.count
    }
    
    var totalVolume: Double {
        session.sessionExercises
            .flatMap { $0.sets }
            .filter { $0.isCompleted }
            .reduce(0) { $0 + ($1.weight * Double($1.reps)) }
    }
    
    var previousSession: Session? {
        guard let routine = session.routine else { return nil }
        
        return routine.sessions
            .filter { $0.id != session.id && $0.date < session.date }
            .sorted { $0.date > $1.date }
            .first
    }
    
    var volumePercentage: Double? {
        guard let prev = previousSession else { return nil }
        
        let prevVolume = prev.sessionExercises
            .flatMap { $0.sets }
            .filter { $0.isCompleted }
            .reduce(0) { $0 + ($1.weight * Double($1.reps)) }
        
        if prevVolume == 0 { return nil }
        return ((totalVolume - prevVolume) / prevVolume) * 100
    }
    
    var newPR: (exerciseName: String, weight: Double, reps: Int)? {
        guard let routine = session.routine else { return nil }
        
        let pastSessions = routine.sessions.filter { $0.id != session.id && $0.date < session.date }
        
        if pastSessions.isEmpty { return nil }
        
        for sessionEx in session.sessionExercises {
            guard let masterEx = sessionEx.exercise else { continue }
            
            guard let bestCurrentSet = sessionEx.sets
                .filter({ $0.isCompleted })
                .max(by: { $0.weight < $1.weight }) else { continue }
            
            let pastMaxWeight = pastSessions
                .flatMap { $0.sessionExercises }
                .filter { $0.exercise?.id == masterEx.id }
                .flatMap { $0.sets }
                .filter { $0.isCompleted }
                .max(by: { $0.weight < $1.weight })?.weight ?? 0.0
            
            if bestCurrentSet.weight > pastMaxWeight {
                return (exerciseName: masterEx.name, weight: bestCurrentSet.weight, reps: bestCurrentSet.reps)
            }
        }
        return nil
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack {
                    // confetti
                    Text("🎉")
                        .font(.title)
                        .padding(20)
                        .background(Color(red: 0.155, green: 0.203, blue: 0))
                        .clipShape(Circle())
                    
                    // session complete header
                    VStack(spacing: 10) {
                        Text("Session Complete")
                            .foregroundStyle(.white) // Ganti ke white sementara kalau PrimaryText belum di set di Assets
                            .font(.title)
                            .fontWeight(.bold)
                        
                        // Menampilkan Nama Routine & Tanggal Dinamis
                        Text("\(session.routine?.title ?? "Workout") · \(session.date.formatted(date: .abbreviated, time: .omitted))")
                            .foregroundStyle(.gray)
                    }
                    .padding(.vertical, 20)
                    
                    // stats
                    HStack(spacing: 36) {
                        VStack(spacing: 8) {
                            Text(durationString)
                            Text("Duration")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        Divider().frame(height: 64).background(.gray)
                        
                        VStack(spacing: 8) {
                            Text("\(totalSets)")
                            Text("Sets")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        Divider().frame(height: 64).background(.gray)
                        
                        VStack(spacing: 8) {
                            Text("\(totalExercises)")
                            Text("Exercises")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 16)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .font(.title2)
                    .background(Color(red: 0.101, green: 0.101, blue: 0.101))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Total volume
                    VStack(alignment: .leading, spacing: 8) {
                        Text("TOTAL VOLUME")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.gray)
                            .padding(.top, 4)
                        
                        HStack(alignment: .top, spacing: 4) {
                            Text("\(String(format: "%.0f", totalVolume)) kg")
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .font(.title)
                                .padding(.trailing, 20)
                            Spacer()
                            
                            if let percentage = volumePercentage {
                                let isPositive = percentage >= 0
                                let sign = isPositive ? "+" : ""
                                let color = isPositive ? Color.accent : Color.red
                                let icon = isPositive ? "chart.line.uptrend.xyaxis" : "chart.line.downtrend.xyaxis"
                                
                                HStack(spacing: 2) {
                                    Image(systemName: icon)
                                    Text("\(sign)\(String(format: "%.0f", percentage))% vs last session")
                                        .fontWeight(.semibold)
                                }
                                .foregroundStyle(color)
                                .padding(8)
                                .font(.footnote)
                                .fontWeight(.light)
                                .background(color.opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(24)
                    .background(Color(red: 0.078, green: 0.078, blue: 0.078))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.top, 16)
                    
                    if let pr = newPR {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(spacing: 18) {
                                Image(systemName: "trophy")
                                    .font(.title2)
                                    .padding(12)
                                    .background(Color.accent.opacity(0.15))
                                    .clipShape(RoundedRectangle(cornerRadius: 14))
                                    .fontWeight(.semibold)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("NEW PR")
                                        .fontWeight(.bold)
                                        .font(.subheadline)
                                    
                                    Text("\(pr.exerciseName) · \(String(format: "%.1f", pr.weight)) kg × \(pr.reps)")
                                        .fontWeight(.bold)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    Text("\"New PR. That's what showing up does.\"")
                                        .foregroundStyle(.gray)
                                        .font(.caption)
                                }
                            }
                            .foregroundStyle(Color.accent)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(18)
                        .background(Color.accent.opacity(0.1))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.accent.opacity(0.3), lineWidth: 3)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.top, 8)
                    }
                    
                    // 👇 EXERCISE BREAKDOWN MENGGUNAKAN SESSION CARD
                    VStack(alignment: .leading, spacing: 12) {
                        Text("EXERCISE BREAKDOWN")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.gray)
                            .padding(.top, 16)
                            .padding(.horizontal, 8)
                        
                        SessionCard(session: session)
                    }
                    .padding(.top, 16)
                    
                    // TOMBOL SELESAI
                    Button(action: onDone) {
                        Text("Done")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(.black)
                            .background(Color.white)
                            .cornerRadius(16)
                            .padding(.top, 32)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    // 1. Siapkan Database Bohongan
    let schema = Schema([Routine.self, Exercise.self, Session.self, SessionExercise.self, SessionSet.self])
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: [config])
    let context = container.mainContext
    
    // 2. Bikin Master Data
    let barbellRow = Exercise(name: "Barbell Row", muscleGroup: "Back")
    context.insert(barbellRow)
    
    let pullDay = Routine(title: "Pull Day", exercises: [barbellRow])
    context.insert(pullDay)
    
    // ==========================================
    // 3. SESI MASA LALU (Dilakukan 3 Hari Lalu)
    // ==========================================
    let pastSession = Session(routine: pullDay)
    pastSession.date = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
    
    let pastEx = SessionExercise(session: pastSession, exercise: barbellRow)
    // Anggap setnya: 60kg x 10 reps = Volume 600kg. (Rekor beban terberat: 60kg)
    let pastSet = SessionSet(setNumber: 1, reps: 10, weight: 60)
    pastSet.isCompleted = true
    
    pastEx.sets.append(pastSet)
    pastSession.sessionExercises.append(pastEx)
    context.insert(pastSession)
    
    // ==========================================
    // 4. SESI HARI INI (Baru Saja Selesai)
    // ==========================================
    let currentSession = Session(routine: pullDay)
    currentSession.date = Date() // Hari ini
    
    let currentEx = SessionExercise(session: currentSession, exercise: barbellRow)
    // Anggap setnya: 70kg x 8 reps (2 Set) = Volume 1.120kg. (Rekor beban: 70kg -> PECAH REKOR!)
    let currentSet1 = SessionSet(setNumber: 1, reps: 8, weight: 70)
    currentSet1.isCompleted = true
    let currentSet2 = SessionSet(setNumber: 2, reps: 8, weight: 70)
    currentSet2.isCompleted = true
    
    currentEx.sets.append(currentSet1)
    currentEx.sets.append(currentSet2)
    currentSession.sessionExercises.append(currentEx)
    context.insert(currentSession)
    
    // 5. Tampilkan UI-nya menggunakan sesi hari ini
    return SessionCompleteView(session: currentSession) {
        print("Done diklik")
    }
    .modelContainer(container)
}

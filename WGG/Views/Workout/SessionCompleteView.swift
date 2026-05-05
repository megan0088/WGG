//
//  SessionCompleteView.swift
//  WGG
//
//  Created by Stepanus Imanuel on 05/05/26.
//

import SwiftUI

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
                            
//                            HStack(spacing: 2) {
//                                Image(systemName: "chart.line.uptrend.xyaxis")
//                                Text("+12% vs last week") // Ini bisa dibikin dinamis nanti
//                                    .fontWeight(.semibold)
//                            }
//                            .foregroundStyle(Color.accentColor)
//                            .padding(8)
//                            .font(.footnote)
//                            .fontWeight(.light)
//                            .background(Color(red: 0.053, green: 0.158, blue: 0.058))
//                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(24)
                    .background(Color(red: 0.078, green: 0.078, blue: 0.078))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.top, 16)
                    
                    // new PR (Untuk sementara statis dulu)
//                    VStack(alignment: .leading, spacing: 20) {
//                        HStack(spacing: 18) {
//                            Image(systemName: "trophy")
//                                .font(.title2)
//                                .padding(12)
//                                .background(Color(red: 0.216, green: 0.278, blue: 0))
//                                .clipShape(RoundedRectangle(cornerRadius: 14))
//                                .fontWeight(.semibold)
//                            
//                            VStack(alignment: .leading, spacing: 8) {
//                                Text("NEW PR")
//                                    .fontWeight(.bold)
//                                    .font(.subheadline)
//                                Text("Barbell Row · 70 kg × 8")
//                                    .fontWeight(.bold)
//                                    .font(.headline)
//                                    .foregroundStyle(.white)
//                                Text("\"New PR. That's what showing up does.\"")
//                                    .foregroundStyle(.gray)
//                                    .font(.caption)
//                            }
//                        }
//                        .foregroundStyle(Color.accentColor)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(18)
//                    .background(Color(red: 0.053, green: 0.158, blue: 0.058))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 16)
//                            .stroke(Color.accentColor.opacity(0.3), lineWidth: 2.76)
//                    )
//                    .clipShape(RoundedRectangle(cornerRadius: 16))
//                    .padding(.top, 8)
                    
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

// Preview dengan Dummy Data agar tidak error
#Preview {
    SessionCompleteView(session: Session(date: Date())) {
        print("Done clicked")
    }
}

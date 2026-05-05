//
//  RestTimeView.swift
//  WGG
//
//  Created by George Maximillian Theodore on 02/05/26.
//

import SwiftUI
internal import Combine

struct RestTimeView: View {
    
    // 1. Panggil WorkoutManager
    @Environment(WorkoutManager.self) private var manager
    
    @State private var timeRemaining: Double = 60 // Ubah ke 60 detik (standar istirahat)
    @State private var isBlinking: Bool = false
    let totalTime: Double = 60
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    // Helper untuk mengambil Set terakhir yang baru saja di-log
    var lastCompletedSet: SessionSet? {
        manager.currentExercise?.sets
            .filter { $0.isCompleted }
            .sorted { $0.setNumber < $1.setNumber }
            .last
    }
    
    func timeString(time: Double) -> String {
        let displayTime = Int(ceil(time))
        let absTime = abs(displayTime)
        let minutes = absTime / 60
        let seconds = absTime % 60
        
        let sign = time <= -1 ? "-" : ""
        
        return String(format: "%@%02d:%02d", sign, minutes, seconds)
    }

    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            
            VStack {
                // 2. Tampilkan Nama Exercise dan Nomor Set secara dinamis
                let exerciseName = manager.currentExercise?.exercise?.name ?? "Exercise"
                let currentSetNum = lastCompletedSet?.setNumber ?? 1
                let totalSets = manager.currentExercise?.sets.count ?? 1
                
                Text("\(exerciseName) · Set \(currentSetNum) of \(totalSets)")
                    .foregroundStyle(Color.primaryText.opacity(0.5))
                
                HStack(spacing: 4) {
                    Image(systemName: "checkmark")
                    // 3. Tampilkan Data Beban dan Reps yang baru di-log
                    if let lastSet = lastCompletedSet {
                        Text("\(String(format: "%.1f", lastSet.weight)) kg x \(lastSet.reps) reps logged")
                            .font(.headline)
                    } else {
                        Text("Set logged")
                            .font(.headline)
                    }
                }
                .foregroundStyle(Color.accent)
                
                ZStack {
                    Circle()
                        .stroke(
                            timeRemaining < 0
                            ? Color.red.opacity(isBlinking ? 0.7 : 0.05)
                            : Color.primaryText.opacity(0.1),
                            lineWidth: 16
                        )
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(max(timeRemaining, 0)) / totalTime)
                        .stroke(Color.accent,
                                style: StrokeStyle(lineWidth: 16, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    
                    VStack {
                        Text(timeString(time: timeRemaining))
                            .onReceive(timer) { _ in
                                timeRemaining -= 0.05
                                
                                if timeRemaining < 0 && !isBlinking {
                                    withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                                        isBlinking = true
                                    }
                                }
                            }
                            .foregroundStyle(timeRemaining >= 0 ? Color.accent : Color.red)
                            .font(.system(size: 96).bold())
                        
                        Text("rest time remaining")
                            .foregroundStyle(Color.primaryText.opacity(0.3))
                    }
                }
                .padding(16)
                
                HStack {
                    Button {
                        // 4. Panggil fungsi Finish Exercise dari manager
                        manager.finishCurrentExercise()
                    } label: {
                        Text("Finish Exercise")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.accent.opacity(0.7))
                            .padding(16)
                            .background(Color.primaryText.opacity(0.1))
                            .cornerRadius(16)
                    }
                    
                    Button {
                        // 5. Panggil fungsi Next Set dari manager
                        manager.addNextSet()
                    } label: {
                        Text("Next Set")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color.background)
                            .padding(16)
                            .background(Color.accent)
                            .cornerRadius(16)
                    }
                }
            }
            .padding(16)
        }
    }
}

#Preview {
    RestTimeView()
        // Jangan lupa suntikkan ini supaya Preview tidak crash
        .environment(WorkoutManager())
}

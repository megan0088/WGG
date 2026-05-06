//
//  RestTimeView.swift
//  WGG
//
//  Created by George Maximillian Theodore on 02/05/26.
//

import SwiftUI
internal import Combine

struct RestTimeView: View {
    
    @Environment(WorkoutManager.self) private var manager
    
    @State private var timeRemaining: Double = 60
    @State private var isBlinking: Bool = false
    let totalTime: Double = 60
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var lastCompletedSet: SessionSet? {
        manager.lastCompletedSet
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
                Text("Rest Time")
                    .foregroundStyle(timeRemaining < 0 ?  .red : .teal)
                    .font(.title.bold())
                    .padding(.bottom, 16)
                
                let exerciseName = manager.currentExercise?.exercise?.name ?? "Exercise"
                let currentSetNum = lastCompletedSet?.setNumber ?? 1
                
                Text("\(exerciseName) · Set \(currentSetNum)")
                    .foregroundStyle(Color.primaryText.opacity(0.5))
                
                HStack(spacing: 4) {
                    Image(systemName: "checkmark")
                    
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
                        .stroke(.teal,
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
                            .foregroundStyle(timeRemaining >= 0 ? Color.teal : Color.red)
                            .font(.system(size: 96).bold())
                        
                        Text("rest time remaining")
                            .foregroundStyle(Color.primaryText)
                    }
                }
                .padding(16)
                
                HStack {
                    Button {
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
        .environment(WorkoutManager())
}

//
//  ExerciseCard.swift
//  WGG
//
//  Created by George Maximillian Theodore on 02/05/26.
//

import SwiftUI

struct ExerciseCard: View {
    
    let exercise: Exercise
    
    let isSelected: Bool
    
    let action: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "dumbbell.fill")
                .foregroundStyle(exercise.themeColor)
                .frame(width: 40, height: 40)
                .background(exercise.themeColor.opacity(0.133))
                .cornerRadius(8)
            
            VStack (alignment: .leading, spacing: 6) {
                Text(exercise.name)
                    .font(Font.body.bold())
                    .foregroundStyle(Color.primaryText)
                
                Text(exercise.muscleGroup)
                    .font(.subheadline.bold())
                    .foregroundStyle(exercise.themeColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(exercise.themeColor.opacity(0.2))
                    .cornerRadius(4)
            }
            
            Spacer()
            
            Button {
                action()
            } label: {
                Image(systemName: isSelected ? "checkmark" : "plus")
                    .foregroundStyle(isSelected ? Color.background : Color.primaryText.opacity(0.5))
                    .padding(8)
                    .background(isSelected ? Color.accent : Color.primaryText.opacity(0.1))
                    .cornerRadius(8)
            }
            
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
        .background(Color.primaryText.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primaryText.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(16)
    }
}

//#Preview {
//    ExerciseCard(exercise: Exercise(name: "Pull Up", muscleGroup: "Back"))
//}

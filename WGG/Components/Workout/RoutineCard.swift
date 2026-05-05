//
//  RoutineList.swift
//  WGG
//
//  Created by George Maximillian Theodore on 02/05/26.
//

import SwiftUI

struct RoutineCard: View {
    let routine: Routine
    var action: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "dumbbell.fill")
                .foregroundStyle(routine.themeColor)
                .frame(width: 40, height: 40)
                .background(routine.themeColor.opacity(0.133))
                .cornerRadius(8)
            
            VStack (alignment: .leading) {
                Text(routine.title)
                    .font(Font.body.bold())
                    .foregroundStyle(Color.primaryText)
                
                Text(routine.subtitle)
                    .font(.caption)
                    .foregroundStyle(Color.primaryText.opacity(0.5))
            }
            
            Spacer()
            
            Button{
                action()
            } label: {
                HStack {
                    Text("Start")
                        .font(.headline.bold())
                        .foregroundStyle(Color.accent)
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color.accent)
                }
                .padding(12)
                .background(Color.accent.opacity(0.1))
                .cornerRadius(16)
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
//    RoutineCard(routine: Routine(
//        title: "Pull Day",
//        themeColorName: "red"
//    ), action: {})
//}

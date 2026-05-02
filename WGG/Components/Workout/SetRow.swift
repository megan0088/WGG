//
//  SetRow.swift
//  WGG
//
//  Created by George Maximillian Theodore on 02/05/26.
//

import SwiftUI

enum setStatus {
    case completed
    case active
//    case future
}

struct SetRow: View {
    
    let setNumber: Int
    let weight: String?
    let reps: Int?
    let status: setStatus
    
    var valueText: String{
        if let w = weight, let r = reps {
            return "\(w) x \(r)"
        } else {
            return "-"
        }
    }
    
    var circleBgColor: Color {
        switch status {
        case .completed: return Color.accent.opacity(0.3)
        case .active: return Color.accent
//        case .future: return Color.primaryText.opacity(0.1)
        }
    }
    
    var circleTextColor: Color {
        switch status {
        case .completed: return Color.accent.opacity(0.7)
        case .active: return Color.background
//        case .future: return Color.primaryText.opacity(0.4)
        }
    }
    
    var titleColor: Color {
        switch status {
        case .completed, .active: return Color.primaryText
//        case .future: return Color.primaryText.opacity(0.4)
        }
    }
    
    var valueTextColor: Color {
        switch status {
        case .completed: return Color.primaryText.opacity(0.7)
        case .active: return Color.accent
//        case .future: return Color.primaryText.opacity(0.4)
        }
    }
    
    var borderColor: Color {
        switch status {
//        case .completed, .future: return Color.clear
        case .completed: return Color.clear
        case .active: return Color.primaryText.opacity(0.3)
        }
    }
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(circleBgColor)
                    .frame(width: 16)
                
                Text("\(setNumber)")
                    .font(.caption.bold())
                    .foregroundStyle(circleTextColor)
            }
            
            Text("Set \(setNumber)")
                .font(.headline)
                .foregroundStyle(titleColor)
            
            Spacer()
            
            Text("\(valueText)")
                .font(.headline)
                .foregroundStyle(valueTextColor)
        }
        .padding(16)
        .background(Color.primaryText.opacity(0.1))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor, lineWidth: 1)
        )
    }
}

#Preview {
    SetRow(setNumber: 1, weight: "2.5 kg", reps: 8, status: .completed)
}

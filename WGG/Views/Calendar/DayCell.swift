//
//  DayCell.swift
//  WGG
//
//  Created by Stepanus Imanuel on 02/05/26.
//

import SwiftUI

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let hasWorkout: Bool
    let workoutTitle: String?
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                if isSelected {
                    Rectangle()
                        .fill(Color("Accent"))
                        .frame(width: 36, height: 36)
                }
                
                Text(dayNumber(date))
                    .fontWeight(isSelected ? .bold : (hasWorkout ? .semibold : .regular))
                    .foregroundStyle(isSelected ? .black : (hasWorkout ? .white : .gray))
            }
            .frame(height: 30)
            
            Text(getDisplayTitle())
                .font(.system(size: 12))
                .fontWeight(.medium)
                .foregroundStyle(Color("Accent"))
                .lineLimit(1)
                .frame(height: 14)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .contentShape(Rectangle())
    }
    
    // supaya tinggi teks tetap sama walau kosong
    private func getDisplayTitle() -> String {
        if !isSelected, let title = workoutTitle {
            return title.components(separatedBy: " ").first ?? ""
        }
        return " "
    }
    
    // convert date tanggal
    func dayNumber(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f.string(from: date)
    }
}

#Preview {
    DayCell(date: Date(), isSelected: true, hasWorkout: true, workoutTitle: "Push")
}

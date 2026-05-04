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
    let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                // Background bulat saat dipilih
                if isSelected {
                    Circle()
                        .fill(Color("Accent"))
                        .frame(width: 36, height: 36)
                }
                
                Text(dayNumber(date))
                    .fontWeight(isSelected ? .bold : (hasWorkout ? .semibold : .regular))
                    .foregroundStyle(isSelected ? .black : (hasWorkout ? .white : .gray))
            }
            .frame(width: 36, height: 36)
            
            // Dot kecil
            Circle()
                .fill(hasWorkout ? Color("Accent") : Color.clear)
                .frame(width: 6, height: 6)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 52)
    }
    
    func dayNumber(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f.string(from: date)
    }
}

#Preview {
    DayCell(date: Date(), isSelected: true, hasWorkout: true)
}

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
    let highlightColor: Color?
    let sessionColors: [Color]

    var body: some View {
        VStack(spacing: 6) {

            ZStack {

                Circle()
                    .fill(
                        isSelected
                        ? Color("Accent")
                        : (highlightColor ?? Color.clear).opacity(0.25)
                    )
                    .frame(width: 36, height: 36)

                Text(dayNumber(date))
                    .fontWeight(
                        isSelected
                        ? .bold
                        : (highlightColor != nil ? .semibold : .regular)
                    )
                    .foregroundStyle(
                        isSelected
                        ? .black
                            : (highlightColor ?? .gray)
                    )
            }
            .frame(width: 36, height: 36)

            HStack(spacing: 3) {

                ForEach(
                    Array(sessionColors.prefix(4).enumerated()),
                    id: \.offset
                ) { _, color in

                    Circle()
                        .fill(color)
                        .frame(width: 5, height: 5)
                }
            }
            .frame(height: 6)
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
    DayCell(date: Date(), isSelected: true, highlightColor: nil, sessionColors: [])
}

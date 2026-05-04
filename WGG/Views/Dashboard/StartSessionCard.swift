//
//  StartSessionCard.swift
//  WGG
//
//  Created by Stepanus Imanuel on 01/05/26.
//

import SwiftUI

struct StartSessionCard: View {
    let last = DashboardData.lastSession
    var body: some View {
        // tombol start session
        ZStack {
            NavigationLink(destination: WorkoutView()) {
                HStack {
                    Text("Start Today's Session")
                        .fontWeight(.bold)
                    Image(systemName: "chevron.right")
                        .font(.subheadline)
                        .padding(.leading, 4)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("Accent"))
                .foregroundStyle(.black)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        
        // MARK: last session summary
        if let last = last {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundStyle(Color.accent)
                        .font(.headline)
                    Text("Session Complete")
                        .font(.headline)
                        .foregroundColor(Color.accent)
                }
                
                Text(last.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                HStack(spacing: 16) {
                    VStack (alignment: .leading) {
                        Text("\(minToHourMin(minutes: DashboardData.totalDuration(session: last)))")
                            .foregroundStyle(Color.accent)
                            .fontWeight(.bold)
                            .font(.title2)
                        Text("Duration")
                            .foregroundStyle(Color("BrandSecondary"))
                            .font(.caption)
                    }
                    
                    VStack (alignment: .leading) {
                        Text("\(DashboardData.totalSets(session: last))")
                            .foregroundStyle(Color.accent)
                            .fontWeight(.bold)
                            .font(.title2)
                        Text("Sets")
                            .foregroundStyle(Color("BrandSecondary"))
                            .font(.caption)
                    }
                    
                    VStack (alignment: .leading) {
                        Text("\(Int(DashboardData.totalVolume(session: last))) kg")
                            .foregroundStyle(Color.accent)
                            .fontWeight(.bold)
                            .font(.title2)
                        Text("Volume")
                            .foregroundStyle(Color("BrandSecondary"))
                            .font(.caption)
                    }
                    
                    Spacer()
                }
                
            }
            .frame(maxWidth: .infinity)
            .padding(18)
            .background(Color(#colorLiteral(red: 0.05331161618, green: 0.1584380567, blue: 0.05793306977, alpha: 1)))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.accent.opacity(0.3), lineWidth: 2.76)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        
    }
    
    // MARK: Minute to Hour minute
    func minToHourMin(minutes: Int) -> String {
        if(minutes <= 60) {
            return "\(minutes)m"
        }
        let hour: Int = minutes / 60
        let min: Int = minutes % 60
        
        return "\(hour)h \(min)m"
    }
}

#Preview {
    StartSessionCard()
}

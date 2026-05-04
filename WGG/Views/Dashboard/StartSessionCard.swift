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
            Button(action: {}) {
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
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color("Accent").opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        
        // MARK: last session summary
        if let last = last {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundStyle(Color.accent)
                        .font(.headline)
                    Text("Last Session")
                        .font(.headline)
                        .foregroundColor(Color.accent)
                }
                
                Text(last.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                HStack(spacing: 16) {
                    VStack (alignment: .leading) {
                        Text("\(DashboardData.totalDuration(session: last))m")
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
            .background(Color("Accent").opacity(0.15))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.accent, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        
    }
}

#Preview {
    StartSessionCard()
}

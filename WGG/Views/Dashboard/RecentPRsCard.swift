//
//  RecentPRsCard.swift
//  WGG
//
//  Created by Stepanus Imanuel on 02/05/26.
//

import SwiftUI

struct RecentPRsCard: View {
    let prs = DashboardData.recentPRRecords
    var body: some View {
        VStack(alignment: .leading) {
            TitleText(text: "RECENT PRs", isUpper: false)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(prs, id: \.name) { pr in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "trophy")
                                    .foregroundStyle(Color.accent)
                                    .font(.caption)
                                    .padding(.trailing, 4)
                            
                                
                                
                                HStack {
                                    Text("\(Int(pr.weight)) kg")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                    Text("+\(Int(pr.diff)) kg")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                }
                                .foregroundColor( Color("Accent"))
                                
                                Spacer()
                            }
                            
                            VStack (alignment: .leading, spacing: 4) {
                                Text(pr.name)
                                    .font(.subheadline)
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                                
                                
                                Text("\(pr.daysAgo) days ago")
                                    .font(.caption)
                                    .foregroundStyle(Color("BrandSecondary"))
                            }
                        }
                        .padding()
                        .frame(width: 180)
                        .background(Color("Card"))
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
}

#Preview {
    RecentPRsCard()
}

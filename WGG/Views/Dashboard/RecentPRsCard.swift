//
//  RecentPRsCard.swift
//  WGG
//
//  Created by Stepanus Imanuel on 02/05/26.
//

import SwiftUI

struct RecentPRsCard: View {
    let prs = DashboardData.prs
    var body: some View {
        VStack(alignment: .leading) {
            TitleText(text: "RECENT PRs", isUpper: false)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(prs) { pr in
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                if pr.diff > 0 {
                                    Image(systemName: "trophy")
                                        .foregroundStyle(Color.accent)
                                        .font(.caption)
                                        .padding(.trailing, 4)
                                }
                                
                                
                                HStack {
                                    Text("\(pr.diff > 0 ? "+" : "")\(Int(pr.diff)) kg")
                                        .foregroundColor(pr.diff >= 0 ? Color.accent : Color(#colorLiteral(red: 1, green: 0.1491003036, blue: 0, alpha: 1)))
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text("\(Int(pr.weight)) kg")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                }
                                
                                Spacer()
                            }
                            
                            VStack (alignment: .leading, spacing: 4) {
                                Text(pr.name)
                                    .font(.subheadline)
                                    .foregroundStyle(.white)
                                    .fontWeight(.semibold)
                                
                                
                                Text("\(pr.daysAgo) days ago")
                                    .font(.caption)
                                    .foregroundStyle(Color("Secondary"))
                            }
                        }
                        .padding()
                        .frame(width: 180)
                        .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
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

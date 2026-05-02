//
//  DashboardView.swift
//  WGG
//
//  Created by Stepanus Imanuel on 01/05/26.
//

import SwiftUI

struct DashboardView: View {
    let dashboardData = DashboardData.self
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(#colorLiteral(red: 0.03797435388, green: 0.03797435015, blue: 0.03797435015, alpha: 1)).ignoresSafeArea()
                
                ScrollView {
                    
                    VStack(spacing: 22) {
                        VStack {
                            Text("Hello, ")
                                .foregroundStyle(Color("Secondary"))
                            Text("Gym Goer")
                                .foregroundStyle(.white)
                                .fontWeight(.semibold)
                        }
                        .font(.caption)
                        
                        WeekStreak()
                        
                        StartSessionCard()
                        
                        WeeklyVolumeCard()
                        
                        MuscleFocusCard()
                        
                        RecentPRsCard()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    DashboardView()
}

//
//  DashboardView.swift
//  WGG
//
//  Created by Stepanus Imanuel on 01/05/26.
//

import SwiftUI

struct DashboardView: View {
    let dashboardData = DashboardData.self
    
    @Binding var selectedTab: Tab
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(#colorLiteral(red: 0.03797435388, green: 0.03797435015, blue: 0.03797435015, alpha: 1)).ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    
                    VStack(alignment: .leading, spacing: 22) {
                        PageTitle(title: "Home")
                        
                        WeekStreak(selectedTab: $selectedTab)
                        
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
    DashboardView(selectedTab: .constant(.home))
}

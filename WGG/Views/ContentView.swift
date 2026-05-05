//
//  ContentView.swift
//  WGG
//
//  Created by Muhamad Ega Nugraha on 30/04/26.
//

import SwiftUI

enum Tab {
    case home
    case workout
    case calendar
    case analytics
}

struct ContentView: View {
    
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            DashboardView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)

            WorkoutView()
                .tabItem {
                    Label("Workout", systemImage: "figure.strengthtraining.traditional")
                }
                .tag(Tab.workout)

            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(Tab.calendar)

            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.fill")
                }
                .tag(Tab.analytics)
        }
        .tint(.accent)
    }
}

#Preview {
    ContentView()
}

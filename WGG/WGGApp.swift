//
//  WGGApp.swift
//  WGG
//
//  Created by Muhamad Ega Nugraha on 30/04/26.
//

import SwiftUI
import SwiftData

@main
struct WGGApp: App {
    @State private var workoutManager = WorkoutManager()
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Routine.self, Exercise.self, Session.self, SessionExercise.self, SessionSet.self)
            MockDataSeeder.seedIfNeeded(context: container.mainContext)
        } catch {
            fatalError("\(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .environment(workoutManager)
        .modelContainer(container)
    }
}

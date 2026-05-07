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
    let workoutManager: WorkoutManager
    let phoneSessionManager: PhoneSessionManager
    let container: ModelContainer

    init() {
        do {
            let container = try ModelContainer(for: Routine.self, Exercise.self, Session.self, SessionExercise.self, SessionSet.self)
            self.container = container
            let manager = PhoneSessionManager()
            manager.configure(with: container.mainContext)
            manager.activate()
            self.phoneSessionManager = manager
            self.workoutManager = WorkoutManager()
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
        .environment(phoneSessionManager)
        .modelContainer(container)
    }
}

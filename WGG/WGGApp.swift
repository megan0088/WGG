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
    @State private var phoneSessionManager = PhoneSessionManager()
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
                .onAppear {
                    phoneSessionManager.configure(with: container.mainContext)
                    phoneSessionManager.activate()
                }
        }
        .environment(workoutManager)
        .environment(phoneSessionManager)
        .modelContainer(container)
    }
}

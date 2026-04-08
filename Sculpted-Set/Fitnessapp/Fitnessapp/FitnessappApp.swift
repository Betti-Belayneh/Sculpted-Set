//
//  FitnessappApp.swift
//  Fitnessapp
//
//  Created by Betti 
//

import SwiftUI

@main
struct FitnessappApp: App {
    @StateObject private var signUpService = SignUpService()
    @StateObject private var workoutStore = WorkoutStore()
    @StateObject private var healthKit = HealthKitService()

    var body: some Scene {
        WindowGroup {
            if signUpService.isUserLoggedIn {
                TabsView(signUpService: signUpService)
                    .environmentObject(workoutStore)
                    .environmentObject(healthKit)
            } else {
                ContentView()
                    .environmentObject(signUpService)
            }
        }
    }
}



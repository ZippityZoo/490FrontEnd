//
//  SpartanFitApp.swift
//  SpartanFit
//
//  Created by Collin Harris on 10/7/24.
//

import SwiftUI

@main
struct SpartanFitApp: App {
    @StateObject private var workoutPlanData = WorkoutPlanData(userId: 0) 
    @StateObject private var userData = UserData(user: sampleUser, userPreference: sampleUserPreference)

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(workoutPlanData)
                .environmentObject(userData)
        }
    }
}

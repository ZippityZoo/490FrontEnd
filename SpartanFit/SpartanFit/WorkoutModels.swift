//
//  WorkoutModels.swift
//  SpartanFit
//
//  Created by Garrett Emerich on 10/15/24.
//

import Foundation

// WorkoutPlan model
struct WorkoutPlan: Identifiable {
    var id = UUID()
    var name: String
    var sessions: [WorkoutSession]
}

// WorkoutSession model
struct WorkoutSession: Identifiable {
    var id = UUID()
    var date: Date
    var exercises: [Exercise]  
}

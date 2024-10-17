//
//  WorkoutModels.swift
//  SpartanFit
//
//  Created by Garrett Emerich on 10/15/24.
//

import Foundation
import SwiftUI

// Updated WorkoutPlan model to align with the backend db
struct WorkoutPlan: Identifiable {
    var id: Int
    var userId: Int
    var name: String
    var startDate: Date
    var endDate: Date
    var isActive: Bool
    var sessions: [WorkoutSession]
}

// Updated WorkoutSession model, mapped to DB
struct WorkoutSession: Identifiable {
    var id: Int
    var date: Date
    var calories: Int
    var type: String
    var intensity: String
    var duration: Int 
    var exercises: [Exercise] // Corresponds to exercises for this workout session
}

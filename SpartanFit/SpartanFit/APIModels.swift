//
//  APIModels.swift
//  SpartanFit
//
//  Created by Garrett Emerich on 11/2/24.
//
import Foundation
import SwiftUI


struct WorkoutPlanAPIResponse: Codable {
    let status: String
    let recommendedPlans: [RecommendedPlan]
}


struct RecommendedPlan: Codable {
    let plan_id: Int
    let start_date: String
    let end_date: String
    let workouts: [Workout]
    
    func toWorkoutPlan(userId: Int) -> WorkoutPlan {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return WorkoutPlan(
            id: plan_id,
            userId: userId,
            name: "Recommended Plan",
            startDate: formatter.date(from: start_date) ?? Date(),
            endDate: formatter.date(from: end_date) ?? Date(),
            isActive: true,
            sessions: workouts.map { $0.toWorkoutSession() }
        )
    }
}

struct Workout: Codable {
    let workout_id: Int
    let intensity: String
    let duration: Int
    let exercise_name: String
    
    func toWorkoutSession() -> WorkoutSession {
        WorkoutSession(
            id: workout_id,
            date: Date(),
            intensity: intensity,
            duration: duration,
            exercises: [
                Exercise(
                    id: workout_id,
                    name: exercise_name,
                    apiId: workout_id,
                    planSets: 3,
                    planReps: 10,
                    planWeight: 0.0,
                    restTime: 60,
                    setVariation: .one
                )
            ]
        )
    }
}

struct UserProfileResponse: Codable {
    let status: String
    let user: [User]
}



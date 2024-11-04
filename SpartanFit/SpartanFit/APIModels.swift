//
//  APIModels.swift
//  SpartanFit
//
//  Created by Garrett Emerich on 11/2/24.
//
import Foundation
import SwiftUI
import Combine

class WorkoutPlanData: ObservableObject {
    @Published var workoutPlan: WorkoutPlan?
    @Published var isLoading = true
    
    // Initializer for fetching data from API
    init(userId: Int) {
        fetchWorkoutPlan(userId: userId)
    }
    
    // Test initializer for sample data
    init(workoutPlan: WorkoutPlan) {
        self.workoutPlan = workoutPlan
        self.isLoading = false
    }
    
    func fetchWorkoutPlan(userId: Int) {
        let urlString = "http://localhost:3000/recommendations?user_id=\(userId)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let apiResponse = try JSONDecoder().decode(RecommendedPlansResponse.self, from: data)
                DispatchQueue.main.async {
                    self.workoutPlan = apiResponse.recommendedPlans.first
                    self.isLoading = false
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }.resume()
    }
}

struct RecommendedPlansResponse: Codable {
    let status: String
    let recommendedPlans: [WorkoutPlan]
}

// Workout Plan model
struct WorkoutPlan: Identifiable, Codable {
    let id: Int
    let userId: Int
    let startDate: String
    let endDate: String
    let active: Int
    let workouts: [Workout]
    
    // Coding keys to match JSON keys
    enum CodingKeys: String, CodingKey {
        case id = "plan_id"
        case userId = "user_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case active, workouts
    }
}

// Workout model
struct Workout: Identifiable, Codable {
    let id: Int
    let exerciseName: String
    let intensity: String
    let duration: Int
    let exercises: [Exercise]
    
    // Coding keys to match JSON keys
    enum CodingKeys: String, CodingKey {
        case id = "workout_id"
        case exerciseName = "exercise_name"
        case intensity, duration, exercises
    }
}

// Sample data for preview
let workout1Exercises = [
    Exercise(id: 1, name: "Bench Press", apiId: 101, planSets: 4, planReps: 12, planWeight: 135.0, restTime: 60),
    Exercise(id: 2, name: "Squat", apiId: 102, planSets: 3, planReps: 10, planWeight: 185.0, restTime: 90)
]

let sampleWorkouts = [
    Workout(id: 1, exerciseName: "", intensity: "Advanced", duration: 60, exercises: workout1Exercises)
]

let sampleWorkoutPlan = WorkoutPlan(
    id: 1,
    userId: 3601,
    startDate: "2024-01-01",
    endDate: "2024-02-01",
    active: 1,
    workouts: sampleWorkouts
)

// Creating an instance of WorkoutPlanData with sample data
let sampleWorkoutPlanData = WorkoutPlanData(workoutPlan: sampleWorkoutPlan)

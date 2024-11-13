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

    init(userId: Int) {
        fetchWorkoutPlan(userId: userId)
    }

    init(workoutPlan: WorkoutPlan) {
        self.workoutPlan = workoutPlan
        self.isLoading = false
    }

    func fetchWorkoutPlan(userId: Int) {
        let urlString = "\(apiBaseUrl)/recommendations?user_id=\(userId)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }

            do {
                let apiResponse = try JSONDecoder().decode(RecommendedPlansResponse.self, from: data)
                DispatchQueue.main.async {
                    self.workoutPlan = apiResponse.recommendedPlans.first?.workoutPlans.first
                    self.isLoading = false
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }.resume()
    }

}

class WorkoutHistoryData: ObservableObject{
    @Published var performance:[WorkoutHistory]?

    init(userId: Int){
        fetchWorkoutHistory(userId: userId)
    }
    func fetchWorkoutHistory(userId: Int){
        //getting the right json info time to use it huh
        let urlString = "http://localhost:3000/userworkouthistory/user_id=\(userId)"
        //"http://localhost:3000/userworkouthistory/user_id=\(userId)"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let apiResponse = try JSONDecoder().decode(PerformanceData.self, from: data)
                DispatchQueue.main.async {
                    //idk if this will work, good news
                    
                    self.performance = apiResponse.performance
                }
            } catch {
                print("Failed to decode JSON:", error)

            }
        }.resume()
    }
}


struct RecommendedPlansResponse: Codable {
    let status: String
    let recommendedPlans: [RecommendedPlan]
}

struct RecommendedPlan: Codable {
    let status: String
    let workoutPlans: [WorkoutPlan]
}

struct WorkoutPlan: Identifiable, Codable, Equatable {
    let id: Int
    let startDate: String
    let endDate: String
    let active: Int
    let workouts: [Workout]

    enum CodingKeys: String, CodingKey {
        case id = "plan_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case active, workouts
    }
    
    static func == (lhs: WorkoutPlan, rhs: WorkoutPlan) -> Bool {
            return lhs.id == rhs.id &&
                   lhs.startDate == rhs.startDate &&
                   lhs.endDate == rhs.endDate &&
                   lhs.active == rhs.active &&
                   lhs.workouts.map { $0.id } == rhs.workouts.map { $0.id }
        }
}

struct Workout: Identifiable, Codable {
    let id: Int
    let name: String
    let intensity: String
    let duration: Int
    let exercises: [Exercise]

    enum CodingKeys: String, CodingKey {
        case id = "workout_id"
        case name = "exercise_name"
        case intensity, duration, exercises
    }
}
//TODO: finish this for the progress view

struct WorkoutHistory:Identifiable, Codable{
    let userId: Int
    let firstName: String
    let lastName: String
    let id: Int
    let exerciseName: String
    let setPerf:Int
    let repPerf:Int
    let weightPerf:Double
    let dateCompleted:String

    enum CodingKeys:String, CodingKey {
        case userId = "user_id"
        case firstName = "fname"
        case lastName = "lname"
        case id = "perf_id"
        case exerciseName = "exercise_name"
        case setPerf = "actual_sets"
        case repPerf = "actual_reps"
        case weightPerf = "actual_weight"
        case dateCompleted = "perf_date"
    }


}
struct PerformanceData: Codable {
    let performance: [WorkoutHistory]
}



let workout1Exercises = [
    Exercise(id: 1, name: "Bench Press", apiId: 101, planSets: 4, planReps: 12, planWeight: 135.0, restTime: 60),
    Exercise(id: 2, name: "Squat", apiId: 102, planSets: 3, planReps: 10, planWeight: 185.0, restTime: 90),
    Exercise(id: 3, name: "Deadlift", apiId: 103, planSets: 3, planReps: 8, planWeight: 225.0, restTime: 120),
    Exercise(id: 4, name: "Pull Up", apiId: 104, planSets: 4, planReps: 10, planWeight: 0.0, restTime: 60),
    Exercise(id: 5, name: "Overhead Press", apiId: 105, planSets: 4, planReps: 10, planWeight: 95.0, restTime: 60)
]

let workout2Exercises = [
    Exercise(id: 6, name: "Leg Press", apiId: 106, planSets: 4, planReps: 15, planWeight: 270.0, restTime: 60),
    Exercise(id: 7, name: "Lunges", apiId: 107, planSets: 3, planReps: 12, planWeight: 50.0, restTime: 60),
    Exercise(id: 8, name: "Leg Curl", apiId: 108, planSets: 4, planReps: 12, planWeight: 100.0, restTime: 45),
    Exercise(id: 9, name: "Calf Raise", apiId: 109, planSets: 4, planReps: 15, planWeight: 90.0, restTime: 30),
    Exercise(id: 10, name: "Hamstring Curl", apiId: 110, planSets: 3, planReps: 12, planWeight: 80.0, restTime: 45)
]

let workout3Exercises = [
    Exercise(id: 11, name: "Chest Fly", apiId: 111, planSets: 3, planReps: 12, planWeight: 100.0, restTime: 45),
    Exercise(id: 12, name: "Incline Press", apiId: 112, planSets: 4, planReps: 10, planWeight: 115.0, restTime: 60),
    Exercise(id: 13, name: "Tricep Extension", apiId: 113, planSets: 3, planReps: 15, planWeight: 40.0, restTime: 30),
    Exercise(id: 14, name: "Bicep Curl", apiId: 114, planSets: 4, planReps: 12, planWeight: 30.0, restTime: 30),
    Exercise(id: 15, name: "Lat Pulldown", apiId: 115, planSets: 3, planReps: 10, planWeight: 120.0, restTime: 60)
]

let sampleWorkouts = [
    Workout(id: 1, name: "Upper Body Strength", intensity: "Advanced", duration: 60, exercises: workout1Exercises),
    Workout(id: 2, name: "Lower Body Power", intensity: "Intermediate", duration: 55, exercises: workout2Exercises),
    Workout(id: 3, name: "Full Body Endurance", intensity: "Beginner", duration: 50, exercises: workout3Exercises)
]

let sampleWorkoutPlan = WorkoutPlan(
    id: 1,
    startDate: "2024-01-01",
    endDate: "2024-02-01",
    active: 1,
    workouts: sampleWorkouts
)

// Creating an instance of WorkoutPlanData with sample data
let sampleWorkoutPlanData = WorkoutPlanData(workoutPlan: sampleWorkoutPlan)

let apiBaseUrl = "http://localhost:3000"
//Sample workouthistorydata
let sampleWorkoutHistory = WorkoutHistoryData(userId: 7572)

//
//  UserModels.swift
//  SpartanFit
//
//  Created by Garrett Emerich on 10/21/24.
//
import SwiftUI

struct User: Identifiable, Codable, Hashable {
    let id: Int // Use 'id' as Swift's identifier for `Identifiable`
    let fname: String
    let lname: String
    let username: String
    let email: String
    let fit_goal: String
    let exp_level: String
    let created_at: String
    let muscle_id: Int?
    let muscle_name: String?
    let muscle_position: String?
    let injury_intensity: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id" // Maps "user_id" in JSON to "id" in Swift
        case fname, lname, username, email, fit_goal, exp_level, created_at
        case muscle_id, muscle_name, muscle_position, injury_intensity
    }
}

let sampleUser = User(
    id: 3601,
    fname: "Garrett",
    lname: "Emerich",
    username: "SpartanMaster",
    email: "garrett@example.com",
    fit_goal: "Strength",
    exp_level: "Advanced",
    created_at: "2024-01-09 01:16:10",
    muscle_id : 1,
    muscle_name: "bicep",
    muscle_position: "left",
    injury_intensity: "low"
)

struct UserPreference {
    var id: Int          // preference_id
    var userId: Int      // user_id
    var preferredTypes: String
    var preferredIntensity: String
    var preferredDuration: Int?
    var preferredExercise: String
}


let sampleUserPreference = UserPreference(
    id: 1,
    userId: 3601,
    preferredTypes: "Strength",
    preferredIntensity: "Advanced",
    preferredDuration: 60,
    preferredExercise: "Bench Press"
)

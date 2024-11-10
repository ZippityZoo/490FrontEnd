//
//  UserModels.swift
//  SpartanFit
//
//  Created by Garrett Emerich on 10/21/24.
//
import SwiftUI
import Foundation
import Combine

class UserData: ObservableObject {
    @Published var user: User?
    @Published var preferences: UserPreference?

    init(user: User? = nil, userPreference: UserPreference? = nil) {
            self.user = user
            self.preferences = userPreference
        }
    
    func updateUser(_ user: User) {
        self.user = user
    }
    
    func updateUserPreference(_ preference: UserPreference) {
        self.preferences = preference
    }
}

struct UserProfileResponse: Codable {
    let status: String
    let user: [User]
}

struct UserPreferencesResponse: Codable {
    let user: User
    let preferences: UserPreference
}

struct User: Identifiable, Codable, Hashable {
    var id: Int // Use 'id' as Swift's identifier for `Identifiable`
    var fname: String
    var lname: String
    var username: String
    var password: String
    var email: String
    var fit_goal: String
    var exp_level: String
    var created_at: String
    var muscle_id: Int?
    var muscle_name: String?
    var muscle_position: String?
    var injury_intensity: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id" // Maps "user_id" in JSON to "id" in Swift
        case fname, lname, username, password, email, fit_goal, exp_level, created_at
        case muscle_id, muscle_name, muscle_position, injury_intensity
    }
}


let sampleUser = User(
    id: 3601,
    fname: "Garrett",
    lname: "Emerich",
    username: "SpartanMaster",
    password: "SuperStrongPassword",
    email: "garrett@example.com",
    fit_goal: "Strength",
    exp_level: "Advanced",
    created_at: "2024-01-09 01:16:10",
    muscle_id : 1,
    muscle_name: "bicep",
    muscle_position: "left",
    injury_intensity: "low"
)

struct UserPreference: Codable {
    var id: Int
    var userId: Int
    var preferredTypes: String
    var preferredIntensity: String
    var preferredDuration: Int?
    var preferredExercise: String
    
    enum CodingKeys: String, CodingKey {
        case id = "preference_id"
        case userId = "user_id"
        case preferredTypes = "preferred_types"
        case preferredIntensity = "preferred_intensity"
        case preferredDuration = "preferred_duration"
        case preferredExercise = "preferred_exercise"
    }
}


let sampleUserPreference = UserPreference(
    id: 1,
    userId: 3601,
    preferredTypes: "Strength",
    preferredIntensity: "Advanced",
    preferredDuration: 60,
    preferredExercise: "Bench Press"
)



//
//  UserModels.swift
//  SpartanFit
//
//  Created by Garrett Emerich on 10/21/24.
//
import SwiftUI

struct User: Identifiable {
    var id: Int  // user_id in the database
    var fname: String
    var lname: String
    var username: String
    var email: String
    var fitGoal: String
    var expLevel: String
    var createdAt: Date
}


let sampleUser = User(
    id: 3601,
    fname: "Garrett",
    lname: "Emerich",
    username: "SpartanMaster",
    email: "garrett@example.com",
    fitGoal: "Strength",
    expLevel: "Advanced",
    createdAt: Date()
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

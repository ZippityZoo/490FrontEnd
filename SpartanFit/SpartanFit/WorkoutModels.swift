//
//  WorkoutModels.swift
//  SpartanFit
//
//  Created by Garrett Emerich on 10/15/24.
//

import Foundation
import SwiftUI


struct WorkoutSession: Identifiable, Decodable {
    var id: Int // Maps to workout_id in the API response
    var intensity: String
    var duration: Int
    var exercises: [Exercise] // Corresponds to exercises for this workout session

    enum CodingKeys: String, CodingKey {
        case id = "workout_id"       // Maps workout_id from API to id
        case intensity
        case duration
        case exercises
    }
}


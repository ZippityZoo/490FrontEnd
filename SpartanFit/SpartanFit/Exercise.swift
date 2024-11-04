import Foundation
import SwiftUI

// Enum to represent variations in sets
//enum SetVariation: Codable {
//    case one
//    case alternate
//    case maxout
//}

// Enum to represent types of sets
enum SetType: CustomStringConvertible, Codable {
    case regular
    case warmup
    case max
    
    var description: String {
        switch self {
        case .regular: return "Regular"
        case .warmup: return "Warm UP"
        case .max: return "Max"
        }
    }
}

// WorkoutSet class (reflecting the set-level details within an exercise)
class WorkoutSet: ObservableObject, Identifiable, Codable {
    var id = UUID()
    @Published var type: SetType
    @Published var weight: Double
    @Published var repsInput: [Int]
    @Published var repsAssumed: [Int]
    @Published var restTime: Int  // Rest time in seconds

    init(type: SetType, weight: Double, repsAssumed: [Int], restTime: Int) {
        self.type = type
        self.weight = weight
        self.repsAssumed = repsAssumed
        self.repsInput = Array(repeating: 0, count: repsAssumed.count)
        self.restTime = restTime
    }
    
    enum CodingKeys: String, CodingKey {
        case type, weight, repsInput, repsAssumed, restTime
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(SetType.self, forKey: .type)
        weight = try container.decode(Double.self, forKey: .weight)
        repsInput = try container.decode([Int].self, forKey: .repsInput)
        repsAssumed = try container.decode([Int].self, forKey: .repsAssumed)
        restTime = try container.decode(Int.self, forKey: .restTime)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(weight, forKey: .weight)
        try container.encode(repsInput, forKey: .repsInput)
        try container.encode(repsAssumed, forKey: .repsAssumed)
        try container.encode(restTime, forKey: .restTime)
    }
}

/// Exercise class updated to conform to Codable and mapped to the new JSON structure
class Exercise: ObservableObject, Identifiable, Codable {
    var id: Int
    @Published var name: String
    @Published var sets: [WorkoutSet]
    @Published var apiId: Int
    @Published var planSets: Int
    @Published var planReps: Int
    @Published var planWeight: Double
    @Published var restTime: Int

    enum CodingKeys: String, CodingKey {
        case id = "exercise_id"
        case name = "exercise_name"
        case apiId = "api_id"
        case planSets = "plan_sets"
        case planReps = "plan_reps"
        case planWeight = "plan_weight"
        case restTime = "rest_time"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode properties to local variables
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let apiId = try container.decode(Int.self, forKey: .apiId)
        let planSets = try container.decode(Int.self, forKey: .planSets)
        let planReps = try container.decode(Int.self, forKey: .planReps)
        let planWeight = try container.decode(Double.self, forKey: .planWeight)
        let restTime = try container.decode(Int.self, forKey: .restTime)
        

        // Initialize sets
        let initializedSets = (0..<planSets).map { _ in
            WorkoutSet(type: .regular, weight: planWeight, repsAssumed: [planReps], restTime: restTime)
        }
        
        // Assign all properties to `self` after initialization is complete
        self.id = id
        self.name = name
        self.apiId = apiId
        self.planSets = planSets
        self.planReps = planReps
        self.planWeight = planWeight
        self.restTime = restTime
        self.sets = initializedSets
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(apiId, forKey: .apiId)
        try container.encode(planSets, forKey: .planSets)
        try container.encode(planReps, forKey: .planReps)
        try container.encode(planWeight, forKey: .planWeight)
        try container.encode(restTime, forKey: .restTime)
    }
    
    // Initializer for manual creation (e.g., for previews or local data)
    init(id: Int, name: String, apiId: Int, planSets: Int, planReps: Int, planWeight: Double, restTime: Int) {
        self.id = id
        self.name = name
        self.apiId = apiId
        self.planSets = planSets
        self.planReps = planReps
        self.planWeight = planWeight
        self.restTime = restTime
        self.sets = []

        // Initialize the sets (warmup and regular)
        for _ in 0..<planSets {
            let workoutSet = WorkoutSet(type: .regular, weight: planWeight, repsAssumed: [planReps], restTime: restTime)
            self.sets.append(workoutSet)
        }
    }

    
    // Method to render exercise details in SwiftUI view
    func exercisePage() -> some View {
        VStack(alignment: .leading) {
            Text("Exercise: \(self.name)")
                .font(.headline)
                .padding(.bottom, 5)

            ForEach(sets) { set in
                VStack(alignment: .leading) {
                    Text("Set Type: \(set.type.description)")
                        .font(.subheadline)
                    HStack {
                        Text("Weight: \(set.weight, specifier: "%.2f") lbs")
                        Spacer()
                        Text("Reps: \(self.repInputDisplay(set))")
                        Spacer()
                        Text("Goal Reps: \(self.repAssumptionDisplay(set))")
                    }
                }
                Divider()
            }
        }
        .padding()
    }
    
    // Helper function to display input reps
    private func repInputDisplay(_ set: WorkoutSet) -> String {
        return set.repsInput.map { String($0) }.joined(separator: ", ")
    }
    
    // Helper function to display assumed reps (goal reps)
    private func repAssumptionDisplay(_ set: WorkoutSet) -> String {
        return set.repsAssumed.map { String($0) }.joined(separator: ", ")
    }
}

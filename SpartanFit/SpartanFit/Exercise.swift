import Foundation
import SwiftUI

let darkBlue = Color(red: 11/255, green: 11/255, blue: 69/255)
let cream = Color(red: 243/255, green: 223/255, blue: 201/255)
let mint = Color(red: 162/255, green: 228/255, blue: 184/255)

// Enum to represent variations in sets
enum SetVariation {
    case one
    case alternate
    case maxout
}


// Enum to represent types of sets
enum SetType : CustomStringConvertible {
    case regular
    case warmup
    case max
    
    var description: String{
        switch self{
            case .regular: return "Regular"
            case .warmup:  return "Warm UP"
            case .max:     return "Max"
        }
    }
}


// WorkoutSet class (reflecting the set-level details within an exercise)
class WorkoutSet: ObservableObject, Identifiable {
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
}


// New Exercise class mapped to DB
class Exercise: ObservableObject, Identifiable {
    var id: Int
    @Published var name: String
    @Published var sets: [WorkoutSet]
    @Published var apiId: Int
    @Published var planSets: Int
    @Published var planReps: Int
    @Published var planWeight: Double
    @Published var restTime: Int
    @Published var setVariation: SetVariation
    
    // Sample initializer
    init(id: Int, name: String, apiId: Int, planSets: Int, planReps: Int, planWeight: Double, restTime: Int, setVariation: SetVariation) {
        self.id = id
        self.name = name
        self.apiId = apiId
        self.planSets = planSets
        self.planReps = planReps
        self.planWeight = planWeight
        self.restTime = restTime
        self.setVariation = setVariation
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
                    Text("Set Type\(set.type == .warmup ? "Warmup" : set.type == .max ? "Maxout" : "Regular")")
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

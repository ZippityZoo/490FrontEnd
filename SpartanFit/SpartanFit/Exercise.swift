import Foundation
import SwiftUI


// Enum to represent variations in sets
enum SetVariation {
    case one
    case alternate
    case maxout
}


// Enum to represent types of sets
enum SetType {
    case regular
    case warmup
    case max
}


// Class to represent each set within an exercise
class WorkoutSet: Identifiable {
    var id = UUID()  // Make each set identifiable
    @Published var type: SetType
    @Published var weight: Double
    @Published var repsInput: [Int]
    @Published var repsAssumed: [Int]
    
    init(type: SetType, weight: Double, repsAssumed: [Int]) {
        self.type = type
        self.weight = weight
        self.repsAssumed = repsAssumed
        self.repsInput = Array(repeating: 0, count: repsAssumed.count)  // Initialize repsInput with zeros
    }
}


// New Exercise class
class Exercise: ObservableObject, Identifiable {
    var id = UUID() 
    @Published var name: String
    @Published var sets: [WorkoutSet]
    @Published var setVariation: SetVariation
    
  
    init(name: String, setCount: Int, regularWeight: Double, warmUpCount: Int, warmUpWeight: Double, setVariation: SetVariation) {
        self.name = name
        self.sets = []
        self.setVariation = setVariation
        
        // Initialize the warm-up sets
        for _ in 0..<warmUpCount {
            let warmUpSet = WorkoutSet(type: .warmup, weight: warmUpWeight, repsAssumed: setVariation == .alternate ? [10,8] : [10])
            self.sets.append(warmUpSet)
        }
        
        // Initialize the regular sets
        for _ in warmUpCount..<setCount {
            let regularSet = WorkoutSet(type: .regular, weight: regularWeight, repsAssumed: setVariation == .alternate ? [10, 8] : [10])
            self.sets.append(regularSet)
        }
        
        // If maxout variation, handle special logic for maxout sets
        if setVariation == .maxout {
            self.sets.removeLast()  // Remove the last regular set
            let maxOutSet = WorkoutSet(type: .max, weight: warmUpWeight, repsAssumed: [10])
            self.sets.append(maxOutSet)
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

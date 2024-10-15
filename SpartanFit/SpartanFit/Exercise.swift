////
////  Exercise.swift
////  SpartanFit
////
////  Created by Collin Harris on 10/8/24.
////
////This is nothing ignore it
//import Foundation
//import SwiftUI
////for each set
//
//enum SetVariation{
//    case one
//    case alternate
//    case maxout
//}
//
//enum SetType{
//    case regular
//    case warmup
//    case max
//}
//class workoutSet :Identifiable{
//    @Published var type = SetType.regular
//    @Published var weights: Double = 0.0
//    @Published var reps_input: Array<Int> = []
//    @Published var reps_assumed: Array<Int>
//    init(type: SetType, weights: Double = 5.0, reps_assumed: [Int] = [10]) {
//        self.type = type
//        self.weights = weights
//        self.reps_assumed = reps_assumed
//        for rep in reps_assumed{
//            self.reps_input.append(rep * 0)
//        }
//    }
//}
//
//
//class Exercise: ObservableObject{
//    @Published var name = ""
//    @Published var completeness = 0.0
//    @Published var set_count:Int
//    @Published var sets :Array <workoutSet> = []
//    @Published var setvar: SetVariation
//    @Published var target: Array <String> = []
//    
//    init(name:String = "",set_count: Int = 1,regular_weight:Double = 1.0,warm_up_count: Int = 1,warm_up_weight: Double = 5.0 ,setvar: SetVariation) {
//        self.set_count = set_count
//        self.setvar = setvar
//        var i = 0
//        while(i < set_count){
//            //the 10 is a place holder subject to change
//            if i < warm_up_count && setvar == SetVariation.one{
//                self.sets.append(workoutSet(type: SetType.warmup,weights: warm_up_weight,reps_assumed: [10]))
//            }
//            else if i > warm_up_count && setvar == SetVariation.one{
//                self.sets.append(workoutSet(type: SetType.regular,weights: regular_weight,reps_assumed: [10]))
//            }
//            else if i < warm_up_count && setvar == SetVariation.alternate{
//                self.sets.append(workoutSet(type: SetType.warmup,weights: warm_up_weight,reps_assumed: [10,10]))
//            }
//            else if i > warm_up_count && setvar == SetVariation.alternate{
//                self.sets.append(workoutSet(type: SetType.regular,weights: regular_weight,reps_assumed: [10,10]))
//            }
//            else if i < warm_up_count && setvar == SetVariation.maxout{
//                self.sets.append(workoutSet(type: SetType.warmup,weights: warm_up_weight,reps_assumed: [10,10]))
//            }
//            else if i > warm_up_count && setvar == SetVariation.maxout{
//                self.sets.append(workoutSet(type: SetType.regular,weights: warm_up_weight,reps_assumed: [10,10]))
//            }
//            i += 1
//        }
//        if(setvar == SetVariation.maxout){
//            self.sets.popLast()
//            self.sets.append(workoutSet(type: SetType.regular,weights: warm_up_weight,reps_assumed: [10]))
//        }
//    }
//    // Display the exercise and its sets in a view
//        func exercisePage() -> some View {
//            VStack(alignment: .leading) {
//                Text("Exercise: \(self.name)")
//                    .font(.headline)
//                    .padding(.bottom, 5)
//
//                ForEach(sets) { aSet in
//                    HStack {
//                        Text("Weight: \(aSet.weights, specifier: "%.2f") lbs")
//                        Spacer()
//                        Text("Reps: \(self.repInputDisplay(thisSet: aSet))")
//                        Spacer()
//                        Text("Goal Reps: \(self.repAssumptionDisplay(thisSet: aSet))")
//                    }
//                }
//            }
//            .padding()
//        }
//    func repInputDisplay(thisSet: workoutSet) -> String{
//        var str = ""
//        switch setvar {
//        case .one:
//            str += String(thisSet.reps_input[0])
//            return str
//        case .alternate:
//            str += String(thisSet.reps_input[0])
//            str += String(thisSet.reps_input[1])
//            return str
//        case .maxout:
//            str += String(thisSet.reps_input[0])
//            str += String(thisSet.reps_input[1])
//            return str
//        }
//    }
//    func repAssumptionDisplay(thisSet: workoutSet) -> String{
//        var str = ""
//        switch setvar {
//        case .one:
//            str += String(thisSet.reps_assumed[0])
//            return str
//        case .alternate:
//            str += String(thisSet.reps_assumed[0])
//            str += String(thisSet.reps_assumed[1])
//            return str
//        case .maxout:
//            str += String(thisSet.reps_assumed[0])
//            str += String(thisSet.reps_assumed[1])
//            return str
//        }
//    }
//    
//}
//


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
            let warmUpSet = WorkoutSet(type: .warmup, weight: warmUpWeight, repsAssumed: [10])
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
                    Text("Set Type: \(set.type == .warmup ? "Warmup" : set.type == .max ? "Maxout" : "Regular")")
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

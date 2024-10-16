//
//  WorkoutPlanView.swift
//  SpartanFit
//
//  Created by Garrett Emerich on 10/15/24.
//

import SwiftUI

struct WorkoutPlanView: View {
    @State var workoutPlan: WorkoutPlan
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("Gold").ignoresSafeArea() // Gold background for the entire view
                
                VStack {
                    Text(workoutPlan.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 50)
                    WorkoutPlanBody(workoutPlan: self.workoutPlan)
                    
                }
            }
        }
    }
}

struct WorkoutPlanBody:View{
    @State var workoutPlan: WorkoutPlan
    var body: some View{
        List {
            ForEach(workoutPlan.sessions) { session in
                // Each session will have a full blue background
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        // Exercises within the session
                        ForEach(session.exercises, id: \.id) { exercise in
                            NavigationLink(destination: WorkoutSessionDetailView(session: session)) {
                                HStack {
                                    Text(exercise.name)
                                        .font(.subheadline)
                                        .foregroundColor(.white) // White text for better contrast
                                    Spacer()
                                    Text("\(exercise.sets.count) sets")
                                        .foregroundColor(.white)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                
                            }
                        }
                    }
                    .padding() // Add padding around the exercise list within the session
                    .background(Color("DarkBlue").cornerRadius(25)).overlay(RoundedRectangle(cornerRadius: 25) // Rounded rectangle for the border
                        .stroke(.black, lineWidth: 5)) // Blue background for entire session and black border
                    
                } header: {
                    Text(session.date, style: .date)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.vertical, 5) // Padding for session date header
                }
                .listRowBackground(Color.clear) // Remove default list background
            }
        }
        .listStyle(InsetGroupedListStyle())
        .scrollContentBackground(.hidden) // Remove the white scroll box background
    }
}



// Sample data for WorkoutPlan with multiple sessions
let session1Exercises = [
    Exercise(name: "Bench Press", setCount: 4, regularWeight: 135.0, warmUpCount: 2, warmUpWeight: 95.0, setVariation: .one),
    Exercise(name: "Squat", setCount: 3, regularWeight: 185.0, warmUpCount: 1, warmUpWeight: 135.0, setVariation: .alternate)
]

let session2Exercises = [
    Exercise(name: "Deadlift", setCount: 4, regularWeight: 225.0, warmUpCount: 1, warmUpWeight: 135.0, setVariation: .one),
    Exercise(name: "Overhead Press", setCount: 3, regularWeight: 95.0, warmUpCount: 1, warmUpWeight: 45.0, setVariation: .maxout)
]

let session3Exercises = [
    Exercise(name: "Pull-Ups", setCount: 3, regularWeight: 0.0, warmUpCount: 0, warmUpWeight: 0.0, setVariation: .one),
    Exercise(name: "Barbell Row", setCount: 4, regularWeight: 135.0, warmUpCount: 1, warmUpWeight: 95.0, setVariation: .alternate),
    Exercise(name: "Dips", setCount: 3, regularWeight: 0.0, warmUpCount: 0, warmUpWeight: 0.0, setVariation: .maxout)
]

// Create multiple workout sessions with different exercises
let sampleWorkoutSessions = [
    WorkoutSession(date: Date().addingTimeInterval(-86400 * 3), exercises: session1Exercises),  // Session 3 days ago
    WorkoutSession(date: Date().addingTimeInterval(-86400 * 2), exercises: session2Exercises),  // Session 2 days ago
    WorkoutSession(date: Date().addingTimeInterval(-86400), exercises: session3Exercises)       // Session 1 day ago
]

// Sample workout plan with multiple sessions
let sampleWorkoutPlan = WorkoutPlan(name: "Full Body Strength Training", sessions: sampleWorkoutSessions)

#Preview {
    WorkoutPlanView(workoutPlan: sampleWorkoutPlan)
}



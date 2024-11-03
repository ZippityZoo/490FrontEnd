//
//  WorkoutPlanView.swift
//  SpartanFit
//
//  Created by Garrett Emerich on 10/15/24.
//

import Foundation
import SwiftUI


struct WorkoutPlanView: View {
    @State var workoutPlan: WorkoutPlan
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            cream.ignoresSafeArea()
            
            if isLoading {
                SwiftUI.ProgressView("Loading Workout Plan...")
                    .onAppear {
                        fetchWorkoutPlan(userId: workoutPlan.userId)
                    }
            } else {
                VStack {
                    Text(workoutPlan.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(darkBlue)
                        .padding(.top, 50)
                    WorkoutPlanBody(workoutPlan: workoutPlan)
                }
            }
        }
    }
    
    private func fetchWorkoutPlan(userId: Int) {
        let urlString = "http://localhost:3000/recommendations?user_id=\(userId)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let apiResponse = try JSONDecoder().decode(WorkoutPlanAPIResponse.self, from: data)
                if let recommendedPlan = apiResponse.recommendedPlans.first {
                    DispatchQueue.main.async {
                        self.workoutPlan = recommendedPlan.toWorkoutPlan(userId: userId)
                        self.isLoading = false
                    }
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }.resume()
    }
}


struct WorkoutPlanBody: View {
    @State var workoutPlan: WorkoutPlan
    
    var body: some View {
        List {
            ForEach(workoutPlan.sessions) { session in
                Section {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(session.exercises) { exercise in
                            NavigationLink(destination: WorkoutSessionDetailView(session: session)) {
                                HStack {
                                    Text(exercise.name)
                                        .font(.subheadline)
                                        .foregroundColor(Color("Cream"))
                                    Spacer()
                                    Text("\(exercise.sets.count) sets")
                                        .foregroundColor(Color("Cream"))
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 0)
                            }
                        }
                    }
                    .padding()
                    .background(Color("DarkBlue").cornerRadius(25))
                    //.overlay(RoundedRectangle(cornerRadius: 25).stroke(.black, lineWidth: 5))
                    
                } header: {
                    Text(session.date, style: .date)
                        .font(.headline)
                        .foregroundColor(Color("DarkBlue"))
                        .padding(.vertical, 1)
                }
                .listRowBackground(Color.clear)
                .padding(.vertical, -1)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .scrollContentBackground(.hidden) // Remove the white scroll box background
        //.padding()
    }
}

let session1Exercises = [
    Exercise(id: 1, name: "Bench Press", apiId: 101, planSets: 4, planReps: 12, planWeight: 135.0, restTime: 60,  setVariation: .one),
    Exercise(id: 2, name: "Squat", apiId: 102, planSets: 3, planReps: 10, planWeight: 185.0, restTime: 90,  setVariation: .alternate),
    Exercise(id: 3, name: "Deadlift", apiId: 103, planSets: 4, planReps: 12, planWeight: 225.0, restTime: 60, setVariation: .one),
    Exercise(id: 4, name: "Overhead Press", apiId: 104, planSets: 3, planReps: 8, planWeight: 95.0, restTime: 90, setVariation: .maxout),
    Exercise(id: 5, name: "Pull-Ups", apiId: 105, planSets: 3, planReps: 10, planWeight: 0.0, restTime: 0, setVariation: .one),
    Exercise(id: 6, name: "Barbell Row", apiId: 106, planSets: 4, planReps: 8, planWeight: 135.0, restTime: 60, setVariation: .alternate)
]

let session2Exercises = [
    Exercise(id: 3, name: "Deadlift", apiId: 103, planSets: 4, planReps: 12, planWeight: 225.0, restTime: 60, setVariation: .one),
    Exercise(id: 4, name: "Overhead Press", apiId: 104, planSets: 3, planReps: 8, planWeight: 95.0, restTime: 90, setVariation: .maxout)
]

let session3Exercises = [
    Exercise(id: 5, name: "Pull-Ups", apiId: 105, planSets: 3, planReps: 10, planWeight: 0.0, restTime: 0, setVariation: .one),
    Exercise(id: 6, name: "Barbell Row", apiId: 106, planSets: 4, planReps: 8, planWeight: 135.0, restTime: 60, setVariation: .alternate)
]

let sampleWorkoutSessions = [
    WorkoutSession(id: 1, date: Date().addingTimeInterval(0), intensity: "Advanced", duration: 45, exercises: session1Exercises),
    WorkoutSession(id: 2, date: Date().addingTimeInterval(86400), intensity: "Advanced", duration: 60, exercises: session2Exercises),
    WorkoutSession(id: 3, date: Date().addingTimeInterval(86400 * 2), intensity: "Beginner", duration: 30, exercises: session3Exercises)
]

let sampleWorkoutPlan = WorkoutPlan(
    id: 1,
    userId: 3601,
    name: "Full Body Strength Training",
    startDate: Date().addingTimeInterval(-86400 * 30), // 30 days ago
    endDate: Date().addingTimeInterval(86400 * 30),    // 30 days in the future
    isActive: true,
    sessions: sampleWorkoutSessions
)

#Preview {
    WorkoutPlanView(workoutPlan: sampleWorkoutPlan)
}

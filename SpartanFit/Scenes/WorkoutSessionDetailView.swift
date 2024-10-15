//
//  WorkoutSessionDetailView.swift
//  SpartanFit
//
//  Created by Garrett Emerich on 10/15/24.
//
import SwiftUI

struct WorkoutSessionDetailView: View {
    var session: WorkoutSession
    @Environment(\.presentationMode) var presentationMode  // To navigate back

    var body: some View {
        ZStack {
            Color("Gold").ignoresSafeArea() // Background color

            VStack {
                // Header for the session date
                Text(session.date, style: .date)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 50)

                // Back to workout plan button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()  // Navigate back
                }) {
                    Text("Back to Workout Plan")
                        .bold()
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 10)

                // Exercises in the session
                List {
                    ForEach(session.exercises, id: \.id) { exercise in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Exercise: \(exercise.name)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.bottom, 5)

                            // Set details within the exercise
                            ForEach(exercise.sets, id: \.id) { set in
                                VStack(alignment: .leading) {
                                    Text("Set Type: \(set.type == .warmup ? "Warmup" : set.type == .max ? "Maxout" : "Regular")")
                                        .font(.subheadline)
                                        .foregroundColor(.white)

                                    HStack {
                                        Text("Weight: \(set.weight, specifier: "%.1f") lbs")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text("Reps: \(set.repsInput.map { String($0) }.joined(separator: ", "))")
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text("Goal Reps: \(set.repsAssumed.map { String($0) }.joined(separator: ", "))")
                                            .foregroundColor(.white)
                                    }
                                    Divider().background(Color.white)  // White divider
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .padding()
                        .background(Color("DarkBlue").cornerRadius(25))  // Dark blue background for exercises
                    }
                    .listRowBackground(Color.clear) // Remove default list background
                }
                .listStyle(InsetGroupedListStyle())
                .scrollContentBackground(.hidden) // Remove white scroll box background
            }
            .padding()
        }
        .navigationTitle("Workout Session")
    }
}



struct SetView: View {
    var workoutSet: WorkoutSet
    
    var body: some View {
        ZStack {
            Color(red: 0.5, green: 0.5, blue: 0.5)
                .clipShape(RoundedRectangle(cornerRadius: 15.0))
            
            HStack {
                VStack {
                    Text("Weight: \(workoutSet.weight)")
                    Divider()
                    Text("Reps: \(workoutSet.repsInput.map(String.init).joined(separator: ", "))")
                    Text("Goal Reps: \(workoutSet.repsAssumed.map(String.init).joined(separator: ", "))")
                }
                .padding(10)
                .background(Color.white.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 15.0))
            }
        }
        .padding(5)
    }
}


#Preview {
    WorkoutSessionDetailView(session: sampleWorkoutSessions[2])
}

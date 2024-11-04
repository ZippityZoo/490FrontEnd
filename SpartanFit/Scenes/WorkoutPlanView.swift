import SwiftUI

struct WorkoutPlanView: View {
    @EnvironmentObject var workoutPlanData: WorkoutPlanData
    @EnvironmentObject var userData: UserData

    var body: some View {
        ZStack {
            Color("Cream").ignoresSafeArea() // Background
            
            if workoutPlanData.isLoading {
                SwiftUI.ProgressView("Loading Workout Plan...")
                    .onAppear {
                        if let userId = userData.user?.id {
                            workoutPlanData.fetchWorkoutPlan(userId: userId)
                        }
                    }
            } else if let workoutPlan = workoutPlanData.workoutPlan {
                VStack {
                    Text("Your Workout Plan") // Workout plan title
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("DarkBlue"))
                        .padding(.top, 50)
                    
                    WorkoutPlanBody(workoutPlan: workoutPlan)
                }
            } else {
                Text("No workout plan available.")
                    .foregroundColor(Color("DarkBlue"))
            }
        }
    }
}

struct WorkoutPlanBody: View {
    let workoutPlan: WorkoutPlan
    
    var body: some View {
        List {
            ForEach(workoutPlan.workouts, id: \.id) { workout in
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(workout.exercises, id: \.id) { exercise in
                            NavigationLink(destination: WorkoutSessionDetailView(workout: workout)) {
                                HStack {
                                    Text(exercise.name)
                                        .font(.subheadline)
                                        .foregroundColor(Color("Cream"))
                                    Spacer()
                                    Text("\(exercise.planSets) sets")
                                        .foregroundColor(Color("Cream"))
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                            }
                        }
                    }
                    .padding()
                    .background(Color("DarkBlue").cornerRadius(25))
                    .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 5))
                    
                } header: {
                    Text(workout.exerciseName) // Placeholder for the workout title or another identifier
                        .font(.headline)
                        .foregroundColor(Color("DarkBlue"))
                        .padding(.vertical, 5)
                }
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .scrollContentBackground(.hidden) // Remove the white scroll box background
    }
}

// Sample preview setup
#Preview {
    WorkoutPlanView()
        .environmentObject(sampleWorkoutPlanData)
        .environmentObject(UserData(user: sampleUser, userPreference: sampleUserPreference))
}

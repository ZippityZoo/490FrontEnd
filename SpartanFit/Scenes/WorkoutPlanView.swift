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
                        refreshWorkoutData()
                    }
            } else if let workoutPlan = workoutPlanData.workoutPlan {
                VStack {
                    Text("Upcoming Workouts") // Workout plan title
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("DarkBlue"))
                        .padding(.top, 20)
                    
                    WorkoutPlanBody(workoutPlan: workoutPlan)
                }
            } else {
                Text("No workout plan available.")
                    .foregroundColor(Color("DarkBlue"))
                    .onAppear {
                        refreshWorkoutData()
                    }
            }
        }
        .onAppear {
            refreshWorkoutData()
        }
    }
    
    private func refreshWorkoutData() {
        if let userId = userData.user?.id {
            workoutPlanData.isLoading = true
            workoutPlanData.fetchWorkoutPlan(userId: userId)
        }
    }
}

struct WorkoutPlanBody: View {
    let workoutPlan: WorkoutPlan
    
    var body: some View {
        List {
            ForEach(Array(workoutPlan.workouts.enumerated()), id: \.element.id) { index, workout in
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(workout.exercises, id: \.id) { exercise in
                            NavigationLink(destination: WorkoutSessionDetailView()) {
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
                    
                } header: {
                    Text("\(ordinalWorkoutText(for: index)) Workout")
                        .font(.headline)
                        .foregroundColor(Color("DarkBlue"))
                        .padding(.vertical, 5)
                }
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .scrollContentBackground(.hidden)
    }
    
    private func ordinalWorkoutText(for index: Int) -> String {
        switch index {
        case 0: return "First"
        case 1: return "Second"
        case 2: return "Third"
        case 3: return "Fourth"
        case 4: return "Fifth"
        default: return "\(index + 1)th"
        }
    }
}

// Sample preview setup
#Preview {
    WorkoutPlanView()
        .environmentObject(sampleWorkoutPlanData)
        .environmentObject(UserData(user: sampleUser, userPreference: sampleUserPreference))
}

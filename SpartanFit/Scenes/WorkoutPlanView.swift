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
        let startDate = Calendar.current.startOfDay(for: Date()).addingTimeInterval(workoutPlan.id == 4 ? 0 : 86400) // Today if id is 4, tomorrow otherwise
        
        List {
            ForEach(Array(workoutPlan.workouts.enumerated()), id: \.element.id) { index, workout in
                let workoutDate = Calendar.current.date(byAdding: .day, value: index, to: startDate)!
                
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
                    Text(dateFormatter.string(from: workoutDate))
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
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d" 
        return formatter
    }
}

// Sample preview setup
#Preview {
    WorkoutPlanView()
        .environmentObject(sampleWorkoutPlanData)
        .environmentObject(UserData(user: sampleUser, userPreference: sampleUserPreference))
}

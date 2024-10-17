import SwiftUI

struct WorkoutSessionDetailView: View {
    @State var session: WorkoutSession
    @Environment(\.presentationMode) var presentationMode  // To navigate back
    
    let allSessions: [WorkoutSession] = sampleWorkoutSessions
    @State private var currentIndex: Int = 0 // Tracks the index for the workout session

    var body: some View {
        ZStack {
            Color("Gold").ignoresSafeArea() // Background color

            VStack {
                // Button to go to the workout plan (Top Right)
                HStack {
                    Spacer()
                    NavigationLink(destination: WorkoutPlanView(workoutPlan: sampleWorkoutPlan)) {
                        Image(systemName: "list.bullet.rectangle")
                            .font(.title)
                            .foregroundColor(.black)
                            .padding(.trailing, 20)
                    }
                    .ignoresSafeArea(edges: .bottom)
                }

                // Header for the session date with arrow buttons
                HStack {
                    Spacer()
                    Button(action: previousWorkout) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    
                    Text(session.date, style: .date)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    Button(action: nextWorkout) {
                        Image(systemName: "chevron.right")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.top, 20)

                // Exercises in the session
                List {
                    ForEach(session.exercises) { exercise in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Exercise: \(exercise.name)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                            Divider().background(Color.white)

                            // Set details within the exercise
                            ForEach(Array(exercise.sets.enumerated()), id: \.element.id) { index, set in
                                SetView(workoutSet: set, setNumber: index + 1)
                            }
                        }
                        .padding(15)
                        .background(Color("DarkBlue").cornerRadius(25))
                    }
                    .listRowBackground(Color.clear)
                    .padding(.bottom, 20)
                }
                .listStyle(InsetGroupedListStyle())
                .scrollContentBackground(.hidden) // Remove white scroll box background
                .padding(0.1)
            }
        }
        .navigationTitle("Today's Workout")
    }

    // Function to go to the previous workout
    func previousWorkout() {
        if currentIndex > 0 {
            currentIndex -= 1
            session = allSessions[currentIndex]
        }
    }

    // Function to go to the next workout
    func nextWorkout() {
        if currentIndex < allSessions.count - 1 {
            currentIndex += 1
            session = allSessions[currentIndex]
        }
    }
}

#Preview {
    WorkoutSessionDetailView(session: sampleWorkoutSessions[1])
}

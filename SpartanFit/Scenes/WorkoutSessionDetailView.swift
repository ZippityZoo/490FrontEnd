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
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
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
                        .padding(20)
                        .background(Color("DarkBlue").cornerRadius(25))
                    }
                    .listRowBackground(Color.clear)
                    .padding(.bottom, 20)
                }
                .listStyle(InsetGroupedListStyle())
                .scrollContentBackground(.hidden) // Remove white scroll box background
            }
        }
        .navigationTitle("Workout Session").hidden()
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    WorkoutSessionDetailView(session: sampleWorkoutSessions[1])
}

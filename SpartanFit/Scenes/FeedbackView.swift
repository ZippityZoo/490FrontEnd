import SwiftUI

struct FeedbackView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var workoutPlanData: WorkoutPlanData
    
    @Binding var isPresented: Bool
    @State private var rating: Int = 0
    @State private var intensity: Int = 0
    @State private var showConfirmation = false
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            Color("Cream").ignoresSafeArea()
            
            if workoutPlanData.isLoading {
                SwiftUI.ProgressView("Loading...")
                    .foregroundColor(Color("DarkBlue"))
                    .onAppear {
                        if let userId = userData.user?.id {
                            workoutPlanData.fetchWorkoutPlan(userId: userId)
                        }
                    }
            } else {
                VStack(spacing: 20) {
                    Spacer()
                    Text("Rate Your Workout")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("DarkBlue"))

                    // Star rating system
                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: rating >= star ? "star.fill" : "star")
                                .foregroundColor(rating >= star ? Color("DarkBlue") : .gray)
                                .onTapGesture {
                                    rating = star
                                }
                                .font(.largeTitle)
                        }
                    }
                    .padding(.bottom, 40)
                    // Intensity rating system with dumbbell icons
                    VStack {
                        Text("Rate Workout Intensity")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("DarkBlue"))
                            .padding(.bottom, 20)
                        
                        HStack {
                            ForEach(1...5, id: \.self) { level in
                                Image(systemName: intensity >= level ? "dumbbell.fill" : "dumbbell")
                                    .foregroundColor(intensity >= level ? Color("DarkBlue") : .gray)
                                    .onTapGesture {
                                        intensity = level
                                    }
                                    .font(.largeTitle)
                            }
                        }
                    }

                    // Submit button
                    Button(action: submitFeedback) {
                        Text("Submit")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("DarkBlue"))
                            .foregroundColor(Color("Cream"))
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)

                    Spacer()
                    Spacer()
                }
                .padding()
                
                // Confirmation message overlay
                if showConfirmation {
                    VStack {
                        Text("Feedback Submitted!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("DarkBlue"))
                            .padding()
                            .background(Color("Cream"))
                            .cornerRadius(15)
                            .shadow(radius: 10)
                    }
                    .transition(.scale)
                    .zIndex(1)
                }
                
                // Confetti animation
                if showConfetti {
                    ConfettiView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
        }
    }

    private func submitFeedback() {
        guard
            let userId = userData.user?.id,
            let planId = workoutPlanData.workoutPlan?.id
        else { return }

        // Convert intensity to estimated calories burned
        let caloriesBurned = calculateCaloriesBurned(intensity: intensity)
        
        let feedbackData: [String: Any] = [
            "userId": userId,
            "planId": planId,
            "rating": rating,
            "totalCaloriesBurned": caloriesBurned
        ]

        let urlString = "\(apiBaseUrl)/feedback"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: feedbackData)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error submitting feedback:", error)
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        showConfirmation = true
                        showConfetti = true
                        
                        // Refresh workoutPlan
                        if let userId = userData.user?.id {
                            workoutPlanData.fetchWorkoutPlan(userId: userId)
                        }
                        
                        // Automatically dismiss confirmation and feedback view
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showConfirmation = false
                                showConfetti = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isPresented = false
                            }
                        }
                    }
                } else {
                    print("Failed to submit feedback")
                }
            }.resume()
        } catch {
            print("Failed to encode feedback data:", error)
        }
    }

    // Helper function to estimate calories based on intensity level
    private func calculateCaloriesBurned(intensity: Int) -> Double {
        let multiplier = 100
        return Double(multiplier * intensity)
    }
}


// Simple confetti animation view
struct ConfettiView: View {
    @State private var confettiPositions: [CGSize] = Array(repeating: .zero, count: 40)

    var body: some View {
        ZStack {
            ForEach(0..<40, id: \.self) { index in
                Circle()
                    .fill(randomColor())
                    .frame(width: 10, height: 10)
                    .offset(confettiPositions[index])
                    .onAppear {
                        withAnimation(.linear(duration: Double.random(in: 1.0...2.0))) {
                            confettiPositions[index] = CGSize(
                                width: CGFloat.random(in: -250...250),
                                height: index % 2 == 0 ? CGFloat.random(in: -500 ... -300) : CGFloat.random(in: 300 ... 500)
                            )
                        }
                    }
            }
        }
    }

    private func randomColor() -> Color {
        let colors: [Color] = [.red, .blue, .green, .yellow, .pink, .purple, .orange]
        return colors.randomElement() ?? .gray
    }
}


#Preview {
    FeedbackView(isPresented: .constant(true))
        .environmentObject(WorkoutPlanData(workoutPlan: sampleWorkoutPlan))
        .environmentObject(UserData(user: sampleUser))
}

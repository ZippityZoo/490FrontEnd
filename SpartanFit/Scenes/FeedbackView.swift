import SwiftUI

struct FeedbackView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var workoutPlanData: WorkoutPlanData
    
    @Binding var isPresented: Bool
    @State private var rating: Double = 0
    @State private var caloriesBurned: String = ""
    @State private var showConfirmation = false // State variable for showing confirmation
    @State private var showConfetti = false     // State variable for confetti animation

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
                        .fontWeight(.bold)
                        .foregroundColor(Color("DarkBlue"))

                    // Star rating system with half-star support
                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: rating >= Double(star) - 0.5 ? "star.fill" : "star")
                                .foregroundColor(rating >= Double(star) - 0.5 ? Color("DarkBlue") : .gray)
                                .onTapGesture {
                                    rating = Double(star)
                                }
                                .font(.largeTitle)
                        }
                    }

                    // Calories burned input
                    VStack(alignment: .leading) {
                        Text("Estimated Calories Burned")
                            .fontWeight(.semibold)

                        TextField("Enter calories", text: $caloriesBurned)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, 10)
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
            let planId = workoutPlanData.workoutPlan?.id,
            let calories = Double(caloriesBurned)
        else { return }

        let feedbackData: [String: Any] = [
            "userId": userId,
            "planId": planId,
            "rating": rating,
            "totalCaloriesBurned": calories
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
                        
                        //refresh workoutPlan
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

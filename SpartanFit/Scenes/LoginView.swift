import SwiftUI

struct LoginView: View {
    @State private var path = NavigationPath()
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var workoutPlanData: WorkoutPlanData // WorkoutPlanData as EnvironmentObject

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color("Cream").ignoresSafeArea()
                
                VStack {
                    Text("SPARTANFIT")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(Color("DarkBlue"))
                    
                    ZStack {
                        Color("DarkBlue")
                        
                        VStack {
                            TextField("Enter Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 20)
                            
                            SecureField("Enter Password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            HStack {
                                Spacer()
                                Button("Login") {
                                    authenticateUser(email: email)
                                }
                                .padding()
                                .background(Color("DarkBlue"))
                                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                .foregroundColor(.white)
                            }
                            NavigationLink(destination: SignUpView()) {
                                Text("Sign Up").foregroundStyle(.blue).underline()
                            }
                        }
                    }
                    .padding(.vertical, 200)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                }
            }
            .navigationDestination(for: User.self) { user in
                WelcomeView()
                    .environmentObject(WorkoutPlanData(userId: user.id)) // Initialize WorkoutPlanData with userId
            }
        }
    }
    
    func authenticateUser(email: String) {
        let userId = email
        let urlString = "http://localhost:3000/userprofile/user_id=\(userId)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Network or URL error:", error ?? "Unknown error")
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(UserProfileResponse.self, from: data)
                DispatchQueue.main.async {
                    if let fetchedUser = apiResponse.user.first {
                        print("User fetched successfully:", fetchedUser)
                        self.userData.updateUser(fetchedUser)
                        fetchPreferences(userId: fetchedUser.id) // Fetch preferences after updating user
                    } else {
                        print("User not found.")
                    }
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }.resume()
    }

    
    func fetchPreferences(userId: Int) {
        let urlString = "http://localhost:3000/preferences/\(userId)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Network or URL error:", error ?? "Unknown error")
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(UserPreferencesResponse.self, from: data)
                DispatchQueue.main.async {
                    // Only update preferences
                    self.userData.updateUserPreference(apiResponse.preferences)
                    
                    // Perform navigation if `path` is valid and available
                    self.path.append(apiResponse.user) // Navigate once preferences are loaded
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }.resume()
    }
}

#Preview {
    LoginView()
        .environmentObject(UserData())
        .environmentObject(WorkoutPlanData(workoutPlan: sampleWorkoutPlan))
}

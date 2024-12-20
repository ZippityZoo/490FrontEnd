import SwiftUI

struct LoginView: View {
    @State private var path = NavigationPath()
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var workoutPlanData: WorkoutPlanData
    @EnvironmentObject var workoutHistoryData: WorkoutHistoryData
    @State var isAuthenticated: Bool = false
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color("DarkBlue").ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    ZStack {
                        Color("DarkBlue")
                            .cornerRadius(25) 
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image("LOGO")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350, height: 350)
                                .padding(.bottom, 20)
                            
                            VStack(spacing: 15) {
                                TextField("Enter Username", text: $email)
                                    .padding()
                                    .background(Color("Cream").opacity(0.8))
                                    .cornerRadius(10)
                                    .padding(.horizontal, 20)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                                
                                SecureField("Enter Password", text: $password)
                                    .padding()
                                    .background(Color("Cream").opacity(0.8))
                                    .cornerRadius(10)
                                    .padding(.horizontal, 20)
                            }
                            
                            Button(action: {
                                authenticateUser(email: email, password: password)
                            }) {
                                Text("Login")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("Cream"))
                                    .foregroundColor(Color("DarkBlue"))
                                    .font(.headline)
                                    .cornerRadius(10)
                                    .padding(.horizontal, 20)
                                    .shadow(radius: 5)
                            }
                            
                            NavigationLink(destination: SignUpViewMain()) {
                                Text("Don't have an account? Sign Up")
                                    .foregroundColor(Color("Cream"))
                                    .font(.headline)
                                    .padding(.top, 10)
                            }
                            
                            Spacer()
                        }
                        .padding(.top, 30)
                        .padding(.bottom, 30)
                    }
                }
                .padding(.bottom, 30)
            }
            .navigationDestination(for: String.self) { view in
                if view == "WelcomeView" {
                    WelcomeView()
                        .environmentObject(workoutPlanData)
                        .environmentObject(workoutHistoryData)
                }
            }
            .navigationDestination(for: User.self) { user in
                WelcomeView()
                    .environmentObject(WorkoutPlanData(userId: user.id)) // Initialize WorkoutPlanData with userId
                    .environmentObject(WorkoutHistoryData(userId: user.id))
            }
        }
    }
    
    private func refreshWorkoutData() {
        if let userId = userData.user?.id {
            workoutPlanData.isLoading = true
            workoutPlanData.fetchWorkoutPlan(userId: userId)
            workoutHistoryData.fetchWorkoutHistory(userId: userId)
            
        }
    }
    
    func authenticateUser(email: String, password: String) {
        let loginUrl = "\(apiBaseUrl)/login"
        guard let url = URL(string: loginUrl) else { return }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["username": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Network or URL error:", error ?? "Unknown error")
                return
            }
            
            do {
                // Decode the login response
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                DispatchQueue.main.async {
                    if loginResponse.success {
                        print("Login successful, userId:", loginResponse.userId ?? 3601)
                        // Fetch user profile after successful login
                        fetchUserProfile(userId: loginResponse.userId ?? 3601)
                    } else {
                        print("Login failed:", loginResponse.message)
                    }
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }.resume()
    }
    
    func fetchUserProfile(userId: Int) {
        let userProfileUrl = "\(apiBaseUrl)/userprofile/user_id=\(userId)"
        guard let url = URL(string: userProfileUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Network or URL error:", error ?? "Unknown error")
                return
            }
            
            do {
                // Decode the user profile response
                let userProfileResponse = try JSONDecoder().decode(UserProfileResponse.self, from: data)
                DispatchQueue.main.async {
                    if let fetchedUser = userProfileResponse.user.first {
                        print("User profile fetched successfully:", fetchedUser)
                        self.userData.updateUser(fetchedUser)
                        self.isAuthenticated = true
                        self.path.append("WelcomeView")
                    }
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }.resume()
    }
    
    
    
    func fetchPreferences(userId: Int) {
        let urlString = "\(apiBaseUrl)/preferences/\(userId)"
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
                    
                    // Perform navigation if path is valid and available
                    self.path.append(apiResponse.user) // Navigate once preferences are loaded
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }.resume()
    }
}

struct LoginResponse: Codable {
    let success: Bool
    let userId: Int?
    let message: String
}



#Preview {
    LoginView()
        .environmentObject(UserData())
        .environmentObject(WorkoutPlanData(workoutPlan: sampleWorkoutPlan))
        .environmentObject(WorkoutHistoryData(userId: 7572))
}

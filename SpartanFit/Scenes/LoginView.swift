import SwiftUI

struct LoginView: View {
    @State private var path = NavigationPath()
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var workoutPlanData: WorkoutPlanData
    @State var isAuthenticated: Bool = false

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color("DarkBlue").ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    ZStack {
                        Color("DarkBlue")
                            .cornerRadius(25) // Rounded corners for the blue section
                            .padding(.horizontal, 20)
                            
                        
                        VStack(spacing: 20) {
                            Spacer()
                            
                            Image("LOGO")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350, height: 350)
                                .padding(.bottom, 20)
                            
                            VStack(spacing: 15) {
                                TextField("Enter Email", text: $email)
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
                                authenticateUser(email: email)
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
                            
                            NavigationLink(destination: SignUpView()) {
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
                }
            }
            .onAppear {
                refreshWorkoutData()
            }
        }
    }
    
    func refreshWorkoutData() {
        if let userId = userData.user?.id {
            workoutPlanData.isLoading = true
            workoutPlanData.fetchWorkoutPlan(userId: userId)
            workoutPlanData.isLoading = false // Reset isLoading after fetching
            
        }
    }
    
    func authenticateUser(email: String) {
        let userId = 3601
        let urlString = "\(apiBaseUrl)/userprofile/user_id=\(userId)"
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
                        self.isAuthenticated = true
                        self.path.append("WelcomeView")
                        fetchPreferences(userId: fetchedUser.id)
                    } else {
                        self.isAuthenticated = false
                        print("User not found.")
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
                    self.userData.updateUserPreference(apiResponse.preferences)
                    self.path.append(apiResponse.user)
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

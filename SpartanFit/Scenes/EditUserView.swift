import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var userData: UserData
    @Binding var isPresented: Bool

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @State private var fitGoal = "Strength"  // Default selection
    @State private var expLevel = "Beginner"  // Default selection

    let fitnessGoals = ["Strength", "Hypertrophy", "Endurance"]
    let experienceLevels = ["Beginner", "Intermediate", "Advanced"]

    var body: some View {
        ZStack {
            Color("Cream").ignoresSafeArea()
            
            VStack {
                Text("Edit Profile")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("DarkBlue"))
                    .padding(.top)
                
                Spacer()
                
                VStack(spacing: 20) {
                    editField(label: "First Name", text: $firstName)
                    editField(label: "Last Name", text: $lastName)
                    editField(label: "Username", text: $username)
                    editField(label: "Email", text: $email)
                    secureField(label: "Password", text: $password)

                    // Dropdown for Fitness Goal
                    dropdownField(label: "Fitness Goal", selection: $fitGoal, options: fitnessGoals)

                    // Dropdown for Experience Level
                    dropdownField(label: "Experience Level", selection: $expLevel, options: experienceLevels)
                }
                .padding()
                .background(Color("DarkBlue").opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal, 20)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("DarkBlue").opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        saveProfile()
                    }) {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("DarkBlue"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear(perform: loadUserData)
    }

    // Load current user data into state variables for editing
    private func loadUserData() {
        if let user = userData.user {
            firstName = user.fname
            lastName = user.lname
            username = user.username
            password = user.password
            email = user.email
            fitGoal = user.fit_goal
            expLevel = user.exp_level
        }
    }
    
    // Save the updated profile
    private func saveProfile() {
        guard let userId = userData.user?.id else { return }
        
        let updatedUser = User(
            id: userId,
            fname: firstName,
            lname: lastName,
            username: username,
            password: password,
            email: email,
            fit_goal: fitGoal,
            exp_level: expLevel,
            created_at: userData.user?.created_at ?? "",
            muscle_id: userData.user?.muscle_id,
            muscle_name: userData.user?.muscle_name,
            muscle_position: userData.user?.muscle_position,
            injury_intensity: userData.user?.injury_intensity
        )
        
        userData.updateUser(updatedUser)
        
        // Call the API to update the profile
        updateUserProfile(updatedUser)
        
        isPresented = false
    }

    private func updateUserProfile(_ user: User) {
        guard let url = URL(string: "\(apiBaseUrl)/users/update/\(user.id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let updatedUserBody: [String: Any] = [
            "user_id": user.id,
            "fname": user.fname,
            "lname": user.lname,
            "username": user.username,
            "password": user.password,
            "email": user.email,
            "fit_goal": user.fit_goal,
            "exp_level": user.exp_level
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: updatedUserBody)
        } catch {
            print("Failed to serialize request body:", error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error:", error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    print("User profile updated successfully.")
                }
            } else {
                print("Failed to update user profile:", response ?? "Unknown error")
            }
        }.resume()
    }
    
    // Helper function for text fields
    private func editField(label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color("DarkBlue"))
            
            TextField(label, text: text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(height: 44)
        }
    }
    
    private func secureField(label: String, text: Binding<String>) -> some View {
            VStack(alignment: .leading) {
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color("DarkBlue"))
                
                SecureField(label, text: text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 44)
            }
        }
    
    // Helper function for dropdown fields
    private func dropdownField(label: String, selection: Binding<String>, options: [String]) -> some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color("DarkBlue"))
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        selection.wrappedValue = option
                    }
                }
            } label: {
                Text(selection.wrappedValue)
                    .foregroundColor(Color("DarkBlue"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(in: RoundedRectangle(cornerRadius: 5))
                    .background(Color(.white))
            }
        }
    }
}

#Preview {
    EditProfileView(isPresented: .constant(true))
        .environmentObject(UserData(user: sampleUser))
}

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var userData: UserData
    @State private var isEditingProfile = false
    
    // Local state for each editable field
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var email = ""
    @State private var fitGoal = ""
    @State private var expLevel = ""
    
    var body: some View {
        ZStack {
            Color("Cream").ignoresSafeArea()  // background
            
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                // Header Section with Edit Button
                HStack {
                    Spacer()
                    Button(action: {
                        print("Edit/Save button pressed")
                        if isEditingProfile {
                            saveChanges()
                        } else {
                            loadUserData()
                        }
                        isEditingProfile.toggle()
                    }) {
                        Text(isEditingProfile ? "Save" : "Edit Profile")
                            .bold()
                            .padding(10)
                            .background(Color("DarkBlue"))
                            .foregroundColor(Color("Cream"))
                            .cornerRadius(10)
                    }
                    
                }
                .padding(.horizontal)
                
                // User Info Section
                if let user = userData.user {
                    VStack(alignment: .leading, spacing: 10) {
                        userInfoRow(label: "First Name", value: isEditingProfile ? $firstName : .constant(user.fname), isEditing: isEditingProfile)
                        userInfoRow(label: "Last Name", value: isEditingProfile ? $lastName : .constant(user.lname), isEditing: isEditingProfile)
                        userInfoRow(label: "Username", value: isEditingProfile ? $username : .constant(user.username), isEditing: isEditingProfile)
                        userInfoRow(label: "Email", value: isEditingProfile ? $email : .constant(user.email), isEditing: isEditingProfile)
                        userInfoRow(label: "Fitness Goal", value: isEditingProfile ? $fitGoal : .constant(user.fit_goal), isEditing: isEditingProfile)
                        userInfoRow(label: "Experience Level", value: isEditingProfile ? $expLevel : .constant(user.exp_level), isEditing: isEditingProfile)
                        userInfoRow(label: "Member Since", value: .constant(dateFormatter(user.created_at)), isEditing: false)
                    }
                    .padding()
                    .background(Color("DarkBlue"))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                
                // Muscle and Injury Info Section
                if let user = userData.user {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Injury Information")
                            .font(.headline)
                            .foregroundColor(Color("Cream"))
                        
                        userInfoRow(label: "Muscle ID", value: .constant(user.muscle_id?.description ?? "N/A"), isEditing: false)
                        userInfoRow(label: "Muscle Name", value: .constant(user.muscle_name ?? "N/A"), isEditing: false)
                        userInfoRow(label: "Muscle Position", value: .constant(user.muscle_position ?? "N/A"), isEditing: false)
                        userInfoRow(label: "Injury Intensity", value: .constant(user.injury_intensity ?? "N/A"), isEditing: false)
                    }
                    .padding()
                    .background(Color("DarkBlue"))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                
                // Button to view preferences
                NavigationLink(destination: UserPreferencesView()) {
                    Text("View Preferences")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("DarkBlue"))
                        .foregroundColor(Color("Cream"))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                Spacer()
            }
            .navigationTitle("User Profile")
        }
    }
    
    // Function to load user data into local state for editing
    private func loadUserData() {
        if let user = userData.user {
            firstName = user.fname
            lastName = user.lname
            username = user.username
            email = user.email
            fitGoal = user.fit_goal
            expLevel = user.exp_level
        }
    }
    
    // Function to save updated user profile
    private func saveChanges() {
        guard let user = userData.user else { return }
        
        userData.updateUser(User(
            id: user.id,
            fname: firstName,
            lname: lastName,
            username: username,
            email: email,
            fit_goal: fitGoal,
            exp_level: expLevel,
            created_at: user.created_at,
            muscle_id: user.muscle_id,
            muscle_name: user.muscle_name,
            muscle_position: user.muscle_position,
            injury_intensity: user.injury_intensity
        ))
        
        
        updateUserProfile()
    }
    
    // Function to handle profile update request
    func updateUserProfile() {
        guard let user = userData.user else { return }
        
        // URL with user_id as a path parameter
        guard let url = URL(string: "http://localhost:3000/users/update/\(user.id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create request body
        let updatedUserBody: [String: Any] = [
            "user_id": user.id,
            "fname": user.fname,
            "lname": user.lname,
            "username": user.username,
            "email": user.email,
            "fit_goal": user.fit_goal,
            "exp_level": user.exp_level
        ]
        
        // Convert body to JSON
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: updatedUserBody)
        } catch {
            print("Failed to serialize request body:", error)
            return
        }
        
        // Send the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error:", error)
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                DispatchQueue.main.async {
                    print("User profile updated successfully.")
                    
                }
            } else {
                print("Failed to update user profile:", response ?? "Unknown error")
            }
        }.resume()
    }
    
    
    // Helper function for user info row
    func userInfoRow(label: String, value: Binding<String>, isEditing: Bool) -> some View {
        HStack {
            Text(label + ":")
                .fontWeight(.bold)
                .foregroundColor(Color("Cream"))
            Spacer()
            if isEditing {
                TextField(label, text: value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.white.opacity(0.8))
                    .frame(width: 150)
            } else {
                Text(value.wrappedValue)
                    .foregroundColor(Color("Cream"))
            }
        }
        .padding(10)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    // Helper function to format the date
    func dateFormatter(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: dateString) {
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
        return dateString
    }
}

#Preview {
    UserProfileView()
        .environmentObject(UserData(user: sampleUser))
}

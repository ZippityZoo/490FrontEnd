import SwiftUI

struct UserProfileView: View {
    @State var user: User  // The user's data
    @State var userPreference: UserPreference // The user's preference
    @State private var isEditingProfile = false // Toggle edit mode for profile
    
    var body: some View {
        
        ZStack {
            Color("Cream").ignoresSafeArea()  // Cream background
            
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                // Header Section with Edit Button
                HStack {
                    Spacer()
                    Button(action: {
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
                VStack(alignment: .leading, spacing: 10) {
                    userInfoRow(label: "First Name", value: user.fname, isEditing: isEditingProfile)
                    userInfoRow(label: "Last Name", value: user.lname, isEditing: isEditingProfile)
                    userInfoRow(label: "Username", value: user.username, isEditing: isEditingProfile)
                    userInfoRow(label: "Email", value: user.email, isEditing: isEditingProfile)
                    userInfoRow(label: "Fitness Goal", value: user.fit_goal, isEditing: isEditingProfile)
                    userInfoRow(label: "Experience Level", value: user.exp_level, isEditing: isEditingProfile)
                    userInfoRow(label: "Member Since", value: dateFormatter(user.created_at), isEditing: false)
                }
                .padding()
                .background(Color("DarkBlue"))
                .cornerRadius(15)
                .padding(.horizontal)
                
                // Muscle and Injury Info Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Muscle and Injury Information")
                        .font(.headline)
                        .foregroundColor(Color("DarkBlue"))
                    
                    userInfoRow(label: "Muscle ID", value: user.muscle_id?.description ?? "N/A", isEditing: false)
                    userInfoRow(label: "Muscle Name", value: user.muscle_name ?? "N/A", isEditing: false)
                    userInfoRow(label: "Muscle Position", value: user.muscle_position ?? "N/A", isEditing: false)
                    userInfoRow(label: "Injury Intensity", value: user.injury_intensity ?? "N/A", isEditing: false)
                }
                .padding()
                .background(Color("DarkBlue"))
                .cornerRadius(15)
                .padding(.horizontal)
                
                
                // Button to view preferences
                NavigationLink(destination: UserPreferencesView(preference: userPreference)) {
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
    
    // Helper function to create a row of user info with text fields in edit mode
    func userInfoRow(label: String, value: String, isEditing: Bool) -> some View {
        HStack {
            Text(label + ":")
                .fontWeight(.bold)
                .foregroundColor(Color("Cream"))
            Spacer()
            if isEditing {
                TextField(value, text: Binding(get: { value }, set: { _ in })) // Editable field in edit mode
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.white.opacity(0.8))
                    .frame(width: 150)
            } else {
                Text(value)
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
    UserProfileView(user: sampleUser, userPreference: sampleUserPreference)
}

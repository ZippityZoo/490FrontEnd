//
//  UserProfileView.swift
//  SpartanFit
//
//  Created by Garrett Emerich on 10/21/24.
//

import SwiftUI

struct UserProfileView: View {
    @State var user: User  // The user's data
    @State var userPreference: UserPreference // The user's preference
    @State private var isEditingProfile = false // Toggle edit mode for profile
    
    var body: some View {
        
        ZStack {
            Color("Gold").ignoresSafeArea()  // Gold background
            
            VStack(alignment: .leading, spacing: 20) {
                
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
                            .foregroundColor(.white)
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
                    userInfoRow(label: "Fitness Goal", value: user.fitGoal, isEditing: isEditingProfile)
                    userInfoRow(label: "Experience Level", value: user.expLevel, isEditing: isEditingProfile)
                    userInfoRow(label: "Member Since", value: dateFormatter(user.createdAt), isEditing: false)
                }
                .padding()
                .background(Color("DarkBlue"))
                .cornerRadius(15)
                .padding(.horizontal)
                
                Spacer()
                
                // Button to view preferences
                NavigationLink(destination: UserPreferencesView(preference: userPreference)) {
                    Text("View Preferences")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("DarkBlue"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .navigationTitle("User Profile")
        }
        
    }
    
    // Helper function to create a row of user info with text fields in edit mode
    func userInfoRow(label: String, value: String, isEditing: Bool) -> some View {
        HStack {
            Text(label + ":")
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
            if isEditing {
                TextField(value, text: Binding(get: { value }, set: { _ in })) // Editable field in edit mode
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.white.opacity(0.8))
                    .frame(width: 150)
            } else {
                Text(value)
                    .foregroundColor(.white)
            }
        }
        .padding(10)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
    
    // Helper function to format the date
    func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

#Preview {
    UserProfileView(user: sampleUser, userPreference: sampleUserPreference)
}

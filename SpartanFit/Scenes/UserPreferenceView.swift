import SwiftUI

struct UserPreferencesView: View {
    @EnvironmentObject var userData: UserData
    @State private var isEditingPreferences = false

    var body: some View {
        ZStack {
            Color("Cream").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Preferences")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                    .foregroundColor(Color("DarkBlue"))
                
                // Display the current preferences
                userPreferenceDisplay
                
                Spacer()
                
                // Edit button to navigate to EditPreferencesView
                Button(action: {
                    isEditingPreferences.toggle()
                }) {
                    Text("Edit Preferences")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("DarkBlue"))
                        .foregroundColor(Color("Cream"))
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isEditingPreferences) {
                    EditPreferencesView(isPresented: $isEditingPreferences)
                        .environmentObject(userData)
                }
                .padding(.horizontal, -100)
            }
            .padding()
            .navigationTitle("User Preferences")
        }
    }
    
    // View for displaying preferences
    var userPreferenceDisplay: some View {
        VStack(alignment: .leading, spacing: 15) {
            preferenceRow(label: "Preferred Types", value: userData.preferences?.preferredTypes ?? "N/A")
            preferenceRow(label: "Preferred Intensity", value: userData.preferences?.preferredIntensity ?? "N/A")
            preferenceRow(label: "Preferred Duration", value: "\(userData.preferences?.preferredDuration ?? 0) mins")
            preferenceRow(label: "Preferred Exercise", value: userData.preferences?.preferredExercise ?? "N/A")
        }
        .padding()
        .background(Color("DarkBlue"))
        .cornerRadius(15)
    }
    
    // Helper for preference display rows
    func preferenceRow(label: String, value: String) -> some View {
        HStack {
            Text(label + ":")
                .fontWeight(.bold)
                .foregroundColor(Color("Cream"))
            Spacer()
            Text(value)
                .foregroundColor(Color("Cream"))
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct EditPreferencesView: View {
    @EnvironmentObject var userData: UserData
    @Binding var isPresented: Bool
    
    @State private var preferredTypes = ""
    @State private var preferredIntensity = ""
    @State private var preferredDuration = ""
    @State private var preferredExercise = ""
    
    let preferredTypesOptions = ["Weightlifting", "Running", "Bodybuilding", "Powerlifting", "Cycling"]
    let preferredIntensityOptions = ["Low", "Medium", "High"]
    
    var body: some View {
        ZStack {
            Color("Cream").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Edit Preferences")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                    .foregroundColor(Color("DarkBlue"))
                
                // Form for editing preferences
                VStack(alignment: .leading, spacing: 15) {
                    dropdownField(label: "Preferred Types", selection: $preferredTypes, options: preferredTypesOptions)
                    dropdownField(label: "Preferred Intensity", selection: $preferredIntensity, options: preferredIntensityOptions)
                    textField(label: "Preferred Duration (mins)", value: $preferredDuration)
                    textField(label: "Preferred Exercise", value: $preferredExercise)
                }
                .padding()
                .background(Color("DarkBlue"))
                .cornerRadius(15)
                
                Spacer()
                
                // Cancel and Save buttons
                HStack {
                    Button(action: { isPresented = false }) {
                        Text("Cancel")
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("DarkBlue").opacity(0.4))
                            .foregroundColor(Color("Cream"))
                            .cornerRadius(10)
                    }
                    
                    Button(action: savePreferences) {
                        Text("Save")
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("DarkBlue"))
                            .foregroundColor(Color("Cream"))
                            .cornerRadius(10)
                    }
                }
                .padding(.bottom)
            }
            .padding()
            .onAppear { loadUserPreferences() }
        }
    }
    
    // Load user preferences from userData
    private func loadUserPreferences() {
        if let preferences = userData.preferences {
            preferredTypes = preferences.preferredTypes
            preferredIntensity = preferences.preferredIntensity
            preferredDuration = preferences.preferredDuration.map { String($0) } ?? ""
            preferredExercise = preferences.preferredExercise
        }
    }
    
    // Save updated preferences and call API
    private func savePreferences() {
        guard let userId = userData.user?.id else { return }
        
        let updatedPreferences = UserPreference(
            id: userData.preferences?.id ?? 0,
            userId: userId,
            preferredTypes: preferredTypes,
            preferredIntensity: preferredIntensity,
            preferredDuration: Int(preferredDuration) ?? 0,
            preferredExercise: preferredExercise
        )
        
        guard let url = URL(string: "\(apiBaseUrl)/preferences/update/\(userId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(updatedPreferences)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error updating preferences:", error)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        userData.updateUserPreference(updatedPreferences)
                        isPresented = false
                    }
                } else {
                    print("Failed to update preferences")
                }
            }.resume()
        } catch {
            print("Failed to encode preferences data:", error)
        }
    }
    
    // Helper function for dropdown fields
    func dropdownField(label: String, selection: Binding<String>, options: [String]) -> some View {
        VStack(alignment: .leading) {
            Text(label)
                .fontWeight(.bold)
                .foregroundColor(Color("Cream"))
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        selection.wrappedValue = option
                    }
                }
            } label: {
                Text(selection.wrappedValue.isEmpty ? "Select \(label)" : selection.wrappedValue)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .foregroundColor(.black)
            }
        }
        .padding(.vertical, 5)
    }
    
    // Helper function for text fields
    func textField(label: String, value: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(label)
                .fontWeight(.bold)
                .foregroundColor(Color("Cream"))
            
            TextField(label, text: value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.black)
                .background(Color.white)
        }
    }
}

#Preview {
    UserPreferencesView()
        .environmentObject(UserData(user: sampleUser, userPreference: sampleUserPreference))
}

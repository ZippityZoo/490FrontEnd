import SwiftUI

struct UserPreferencesView: View {
    @EnvironmentObject var userData: UserData
    @State private var editMode: Bool = false
    
    var body: some View {
        ZStack {
            Color("Cream").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Preferences")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                    .foregroundColor(Color("DarkBlue"))
                
                if editMode {
                    preferenceEditor
                } else {
                    userPreferenceDisplay
                }
                
                Spacer()
                
                Button(action: toggleEditMode) {
                    Text(editMode ? "Save" : "Edit Preferences")
                        .bold()
                        .padding()
                        .background(Color("DarkBlue"))
                        .foregroundColor(Color("Cream"))
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("User Preferences")
        }
    }
    
    // View for editing preferences
    var preferenceEditor: some View {
        VStack(alignment: .leading, spacing: 15) {
            preferenceField(label: "Preferred Types", value: Binding(
                get: { userData.preferences?.preferredTypes ?? "" },
                set: { userData.preferences?.preferredTypes = $0 }
            ))
            preferenceField(label: "Preferred Intensity", value: Binding(
                get: { userData.preferences?.preferredIntensity ?? "" },
                set: { userData.preferences?.preferredIntensity = $0 }
            ))
            preferenceField(label: "Preferred Duration (mins)", value: Binding(
                get: { userData.preferences?.preferredDuration.map { String($0) } ?? "" },
                set: { userData.preferences?.preferredDuration = Int($0) }
            ))
            preferenceField(label: "Preferred Exercise", value: Binding(
                get: { userData.preferences?.preferredExercise ?? "" },
                set: { userData.preferences?.preferredExercise = $0 }
            ))
        }
        .padding()
        .background(Color("DarkBlue"))
        .cornerRadius(15)
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
    
    // Toggle edit mode
    func toggleEditMode() {
        editMode.toggle()
        if !editMode {
            // Add code to save preferences here
            print("Preferences saved: \(String(describing: userData.preferences))")
        }
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
    
    // Helper for editable fields
    func preferenceField(label: String, value: Binding<String>) -> some View {
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

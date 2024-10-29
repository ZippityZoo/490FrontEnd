//
//  UserPreferenceView.swift
//  SpartanFit
//
//  Created by Garrett Emerich on 10/21/24.
//

import SwiftUI

struct UserPreferencesView: View {
    @State var preference: UserPreference
    @State private var editMode: Bool = false
    
    var body: some View {
        ZStack {
            cream.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Preferences")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                    .foregroundColor(darkBlue)
                
                if editMode {
                    // Editable fields
                    preferenceEditor
                } else {
                    // Display user preferences
                    userPreferenceDisplay
                }
                
                Spacer()
                
                // Edit/Save button
                Button(action: toggleEditMode) {
                    Text(editMode ? "Save" : "Edit Preferences")
                        .bold()
                        .padding()
                        .background(darkBlue)
                        .foregroundColor(cream)
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
            preferenceField(label: "Preferred Types", value: $preference.preferredTypes)
            preferenceField(label: "Preferred Intensity", value: $preference.preferredIntensity)
            preferenceField(label: "Preferred Duration (mins)", value: Binding(
                get: { preference.preferredDuration.map { String($0) } ?? "" },
                set: { preference.preferredDuration = Int($0) }
            ))
            preferenceField(label: "Preferred Exercise", value: $preference.preferredExercise)
        }
        .padding()
        .background(darkBlue)
        .cornerRadius(15)
    }
    
    // View for displaying preferences
    var userPreferenceDisplay: some View {
        VStack(alignment: .leading, spacing: 15) {
            preferenceRow(label: "Preferred Types", value: preference.preferredTypes)
            preferenceRow(label: "Preferred Intensity", value: preference.preferredIntensity)
            preferenceRow(label: "Preferred Duration", value: "\(preference.preferredDuration ?? 0) mins")
            preferenceRow(label: "Preferred Exercise", value: preference.preferredExercise)
        }
        .padding()
        .background(darkBlue)
        .cornerRadius(15)
    }
    
    // Helper to toggle edit mode
    func toggleEditMode() {
        editMode.toggle()
        if !editMode {
            // Code to save the changes to the backend can go here in the future
            print("Saving preferences: \(preference)")
        }
    }
    
    // Helper for preference display rows
    func preferenceRow(label: String, value: String) -> some View {
        HStack {
            Text(label + ":")
                .fontWeight(.bold)
                .foregroundColor(cream)
            Spacer()
            Text(value)
                .foregroundColor(cream)
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
                .foregroundColor(cream)
            
            TextField(label, text: value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.black)
                .background(Color.white)
        }
    }
}

#Preview {
    UserPreferencesView(preference: sampleUserPreference)
}

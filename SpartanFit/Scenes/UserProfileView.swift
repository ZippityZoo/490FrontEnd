import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var userData: UserData
    @State private var isEditingProfile = false

    var body: some View {
        ZStack {
            Color("Cream").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: {
                        isEditingProfile.toggle()
                    }) {
                        Text("Edit Profile")
                            .bold()
                            .padding(10)
                            .background(Color("DarkBlue"))
                            .foregroundColor(Color("Cream"))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                if let user = userData.user {
                    VStack(alignment: .leading, spacing: 10) {
                        userInfoRow(label: "First Name", value: user.fname)
                        userInfoRow(label: "Last Name", value: user.lname)
                        userInfoRow(label: "Username", value: user.username)
                        //userInfoRow(label: "Password", value: "••••••••")
                        userInfoRow(label: "Email", value: user.email)
                        userInfoRow(label: "Fitness Goal", value: user.fit_goal)
                        userInfoRow(label: "Experience Level", value: user.exp_level)
                        userInfoRow(label: "Member Since", value: dateFormatter(user.created_at))
                    }
                    .padding()
                    .background(Color("DarkBlue"))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                
                if let user = userData.user {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Injury Information")
                            .font(.headline)
                            .foregroundColor(Color("Cream"))
                        
                        userInfoRow(label: "Muscle ID", value: user.muscle_id?.description ?? "N/A")
                        userInfoRow(label: "Muscle Name", value: user.muscle_name ?? "N/A")
                        userInfoRow(label: "Muscle Position", value: user.muscle_position ?? "N/A")
                        userInfoRow(label: "Injury Intensity", value: user.injury_intensity ?? "N/A")
                    }
                    .padding()
                    .background(Color("DarkBlue"))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                
                NavigationLink(destination: UserPreferencesView()) {
                    Text("View Preferences")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("DarkBlue"))
                        .foregroundColor(Color("Cream"))
                        .cornerRadius(10)
                }
                .padding(.horizontal, -10)
                
                Spacer()
            }
            .navigationTitle("User Profile")
            .sheet(isPresented: $isEditingProfile) {
                EditProfileView(isPresented: $isEditingProfile)
                    .environmentObject(userData)
            }
        }
    }
    
    func userInfoRow(label: String, value: String) -> some View {
        HStack {
            Text(label + ":")
                .fontWeight(.bold)
                .foregroundColor(Color("Cream"))
            Spacer()
            Text(value)
                .foregroundColor(Color("Cream"))
        }
        .padding(8)
        .background(Color.gray.opacity(0.15))
        .cornerRadius(10)
    }
    
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
 

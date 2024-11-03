//
//  ContentView.swift
//  SpartanFit
//
//  Created by Collin Harris on 10/7/24.
//
import SwiftUI

struct LoginView: View {
    @State private var path = NavigationPath()
    @State private var email = ""
    @State private var password = ""
    @State private var user: User?
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color("Cream").ignoresSafeArea()
                
                VStack {
                    Text("SPARTANFIT")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(Color("DarkBlue"))
                    
                    ZStack {
                        Color("DarkBlue")
                        
                        VStack {
                            TextField("Enter Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.bottom, 20)
                            
                            SecureField("Enter Password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            HStack {
                                Spacer()
                                Button("Login") {
                                    authenticateUser(userId: 3601) // Replace with dynamic user_id if needed
                                }
                                .padding()
                                .background(Color("DarkBlue"))
                                .clipShape(RoundedRectangle(cornerRadius: 15.0))
                                .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.vertical, 200)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                }
            }
            .navigationDestination(for: User.self) { user in
                WelcomeView(fromLogin: true, user: user)
            }
            .onChange(of: user) { newUser in
                if let newUser = newUser {
                    path.append(newUser) // Navigate to WelcomeView with the user
                }
            }
        }
    }
    
    func authenticateUser(userId: Int) {
        let urlString = "http://localhost:3000/userprofile/user_id=\(userId)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let apiResponse = try JSONDecoder().decode(UserProfileResponse.self, from: data)
                DispatchQueue.main.async {
                    if let fetchedUser = apiResponse.user.first {
                        self.user = fetchedUser // This will trigger the navigation in onChange
                    } else {
                        print("User not found.")
                    }
                }
            } catch {
                print("Failed to decode JSON:", error)
            }
        }.resume()
    }
}


#Preview {
    LoginView()
}


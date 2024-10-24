//
//  WelcomeView.swift
//  SpartanFit
//
//  Created by Collin Harris on 10/10/24.
//

import SwiftUI

struct WelcomeView: View {
    @State var fromLogin: Bool // Will hide the back button if navigated from login/signup
    @State var date: Date = .now
    @State var scrollIndex: Int = 0
    @State var user: User
    
    var workoutSubView = WorkoutPlanBody(workoutPlan: sampleWorkoutPlan)
    
    // Fetch today's session
    var todaysWorkoutSession: WorkoutSession? {
        sampleWorkoutPlan.sessions.first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Gold").ignoresSafeArea() // Background set to gold
                VStack(spacing: 10) {
                    // Header
                    headerView
                    
                    // Progress View navigation
                    NavigationLink(destination: ProgressView()) {
                        progressView
                            .frame(height: 275) // Set a fixed height for the progress view
                    }
                    
                    // Display today's workout with navigation to session detail
                    VStack {
                        Text("Today's Workout:")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(.top, 10)
                            .underline()
                        
                        if let session = todaysWorkoutSession {
                            NavigationLink(destination: WorkoutSessionDetailView(session: session)) {
                                todaysWorkoutView(session: session)
                            }
                        } else {
                            Text("No workout scheduled for today.")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("DarkBlue"))
                                .cornerRadius(25)
                        }
                    }
                    .frame(height: 315) // Match height to maintain visual balance
                }
                .padding() // Padding around the VStack
            }
        }
        .navigationBarBackButtonHidden(fromLogin)
    }
    
    // MARK: - Subviews
    
    var headerView: some View {
        VStack {
            // Dynamic welcome message
            HStack {
                Spacer()
                Text("Welcome, \(user.fname)")
                    .font(.title)
                    .fontWeight(.heavy)
                    .padding(.bottom, 5)
                
                Spacer()
                NavigationLink(destination: UserProfileView(user: user, userPreference: sampleUserPreference)) {
                    Image(systemName: "person.circle.fill")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .padding(.trailing, 20)
                Spacer()
            }
            
            Divider()
                .padding(1)
                .background(Color("DarkBlue"), in: RoundedRectangle(cornerRadius: 25))
            
            Text(date, style: .date)
                .font(.title)
            
            Text(date, style: .time)
                .font(.title2)
        }
    }
    
    var progressView: some View {
        ZStack {
            Color("DarkBlue")
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(5)
            Text("View Progress")
                .font(.title3)
                .foregroundColor(.white)
        }
    }
    
    func todaysWorkoutView(session: WorkoutSession) -> some View {
        ZStack {
            
            Color("DarkBlue")
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(session.exercises.indices, id: \.self) { index in
                            HStack {
                                Text(session.exercises[index].name)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(session.exercises[index].sets.count) sets")
                                    .foregroundColor(.white)
                            }
                            .id(index)
                            .padding()
                            .background(Color("DarkBlue").cornerRadius(25))
                        }
                    }
                }
                .padding()
                .onReceive(timer) { _ in
                    withAnimation {
                        if scrollIndex < session.exercises.count - 1 {
                            scrollIndex += 1
                        } else {
                            scrollIndex = 0
                        }
                        proxy.scrollTo(scrollIndex, anchor: .bottom)
                    }
                }
            }
            NavigationLink(destination: WorkoutSessionDetailView(session: session)){
                Color(.clear)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(5)
    }
    
}

#Preview {
    WelcomeView(fromLogin: false, user: sampleUser)
}

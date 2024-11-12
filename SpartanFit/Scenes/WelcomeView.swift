import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var workoutPlanData: WorkoutPlanData
    @State var currentIndex: Int = 0
    //var barViews: ProgressView().BarChartView
    var body: some View {
        NavigationView {
            ZStack {
                Color("Cream").ignoresSafeArea()
                
//                if workoutPlanData.isLoading {
//                    SwiftUI.ProgressView("Loading Workout Plan...")
//                        .onAppear {
//                            refreshWorkoutData()
//                        }
//                } else {
                    VStack(spacing: 20) {
                        Spacer()
                        headerView
                        Spacer()
                        
                        NavigationLink(destination: ProgressView().environmentObject(sampleWorkoutHistory)) {
                            progressView
                                .scaledToFill()
                                .frame(height: 275)
                                
                        }
                        .padding(.bottom, 30)
                        .padding()
                        
                        workoutPreviewView()
                            .padding(.bottom, 10)
                    }
                    .padding()
                }
            //}
            .onAppear {
                refreshWorkoutData()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // Function to refresh workout data whenever WelcomeView appears
    private func refreshWorkoutData() {
        if let userId = userData.user?.id {
            workoutPlanData.isLoading = true
            workoutPlanData.fetchWorkoutPlan(userId: userId)
        }
    }
    
    var progview: [AnyView] {
        [
            /*
            AnyView(BarChartView(workout: "Squat", setData: DBSets.setsTest3, welcomeView: true).id(UUID())),
            AnyView(BarChartView(workout: "Bench Press", setData: DBSets.setsTest2, welcomeView: true).id(UUID())),
            AnyView(BarChartView(workout: "Deadlift", setData: DBSets.setsTest, welcomeView: true).id(UUID()))
             */
            AnyView(BarChartSubView(exname:"Bench Press").environmentObject(sampleWorkoutHistory)),
            AnyView(BarChartSubView(exname:"Squat").environmentObject(sampleWorkoutHistory))
        ]
    }
    
    // MARK: - Subviews
    
    var headerView: some View {
        VStack {
            HStack {
                Spacer()
                Text("Welcome, \(userData.user?.fname ?? "")")
                    .font(.title)
                    .fontWeight(.heavy)
                    .padding(.bottom, 5)
                    .foregroundColor(Color("DarkBlue"))
                
                Spacer()
                NavigationLink(destination: UserProfileView()) {
                    Image(systemName: "person.circle.fill")
                        .font(.title)
                        .foregroundColor(Color("DarkBlue"))
                }
                .padding(.trailing, 20)
                Spacer()
            }
            .padding(.top, 20)
            
            Divider()
                .padding(1)
                .background(Color("DarkBlue"), in: RoundedRectangle(cornerRadius: 25))
            
            Text(Date(), style: .date)
                .font(.title)
                .foregroundColor(Color("DarkBlue"))
            Spacer()
        }
    }
    
    var progressView: some View {
        ZStack {
            progview[currentIndex]
                .id(currentIndex)
                .transition(.asymmetric(
                    insertion: .slide,
                    removal: .opacity
                ))
                .animation(.easeInOut(duration: 0.8), value: currentIndex)
                .onAppear {
                    currentIndex = Int.random(in: 0..<progview.count)
                }
                .clipShape(RoundedRectangle(cornerRadius: 25))
        }
    }

    
    func workoutPreviewView() -> some View {
        VStack {
            if let workoutPlan = workoutPlanData.workoutPlan, !workoutPlan.workouts.isEmpty {
                NavigationLink(destination: WorkoutSessionDetailView()) {
                    workoutSummaryView()
                }
            } else {
                Text("No workout available.")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color("DarkBlue"))
                    .cornerRadius(25)
            }
        }
        .frame(height: 300)
    }
    
    func workoutSummaryView() -> some View {
        ZStack {
            Color("DarkBlue").ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Today's Workout")
                        .font(.title3)
                        .foregroundColor(Color("Cream"))
                        .padding(.bottom, 5)
                    
                    if let workoutPlan = workoutPlanData.workoutPlan {
                        ForEach(workoutPlan.workouts.first?.exercises ?? [], id: \.id) { exercise in
                            HStack {
                                Text(exercise.name)
                                    .font(.subheadline)
                                    .foregroundColor(Color("Cream"))
                                Spacer()
                                Text("\(exercise.planSets) sets")
                                    .foregroundColor(Color("Cream"))
                            }
                            .padding(10)
                            .background(Color("DarkBlue").cornerRadius(25))
                        }
                    }
                }
                .padding()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding()
    }
}

#Preview {
    WelcomeView()
        .environmentObject(UserData(user: sampleUser, userPreference: sampleUserPreference))
        .environmentObject(sampleWorkoutPlanData)
}

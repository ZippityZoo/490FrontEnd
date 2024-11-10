import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var workoutPlanData: WorkoutPlanData
    @State var currentIndex: Int = 0
    
    
    var body: some View {
        //remove this
        NavigationView{
            ZStack {
                Color("Cream").ignoresSafeArea()
                if workoutPlanData.isLoading {
                    SwiftUI.ProgressView("Loading Workout Plan...")
                        .onAppear {
                            if let userId = userData.user?.id {
                                workoutPlanData.fetchWorkoutPlan(userId: userId)
                            }
                        }
                }
                else
                {
                    VStack(spacing: 20) {
                        // Header
                        headerView
                            .padding(.bottom, 40)
                            .padding(.top, 20)
                        
                        // Progress View navigation
                        NavigationLink(destination: ProgressView()) {
                            progressView
                                .frame(height: 275)
                        }
                        .padding(.bottom, 40)
                        .padding()
                        workoutPreviewView()
                            .padding(.bottom, 10)
                        
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    var progview: [AnyView] {
        [
            AnyView(BarChartView(workout: "Squat", setData: DBSets.setsTest3, welcomeView: true).id(UUID())),
            AnyView(BarChartView(workout: "Bench Press", setData: DBSets.setsTest2, welcomeView: true).id(UUID())),
            AnyView(BarChartView(workout: "Deadlift", setData: DBSets.setsTest, welcomeView: true).id(UUID()))
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
                    // Set a random chart whenever the view appears
                    currentIndex = Int.random(in: 0..<progview.count)
                }
                .clipShape(RoundedRectangle(cornerRadius: 25))
        }
    }

    
    func workoutPreviewView() -> some View {
        VStack {
            if let workout = workoutPlanData.workoutPlan?.workouts.first {
                NavigationLink(destination: WorkoutSessionDetailView(workout: workout)) {
                    workoutSummaryView(workout: workout)
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
    
    
    func workoutSummaryView(workout: Workout) -> some View {
        ZStack {
            Color("DarkBlue").ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Today's Workout")
                        .font(.title3)
                        .foregroundColor(Color("Cream"))
                        .padding(.bottom, 5)
                    
                    ForEach(workout.exercises.indices, id: \.self) { index in
                        HStack {
                            Text(workout.exercises[index].name)
                                .font(.subheadline)
                                .foregroundColor(Color("Cream"))
                            Spacer()
                            Text("\(workout.exercises[index].planSets) sets")
                                .foregroundColor(Color("Cream"))
                        }
                        .padding(10)
                        .background(Color("DarkBlue").cornerRadius(25))
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

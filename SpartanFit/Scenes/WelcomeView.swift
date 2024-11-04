import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var workoutPlanData: WorkoutPlanData
    @State var currentIndex: Int = 0
    var progview = [
        BarChartView(workout:"Squat",setData:
            DBSets.setsTest3,welcomeView: true),
        BarChartView(workout:"Bench Press",setData: DBSets.setsTest2,welcomeView: true)
    ]
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
            } else {
                VStack(spacing: 1) {
                    Spacer()
                    
                    // Header
                    headerView
                    Spacer()
                    // Progress View navigation
                    NavigationLink(destination: ProgressView()) {
                        progressView
                            .frame(height: 275)
                    }
                    .padding()
                    
                    // Display the first workout in the plan with navigation to workout details
                    VStack {
                        Text("Upcoming Workout:")
                            .font(.title2)
                            .foregroundColor(Color("DarkBlue"))
                            .padding(.top, 10)
                            .fontWeight(.bold)
                        
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
                    .frame(height: 390)
                }
                .padding()
            }
            }
        }
        .navigationBarBackButtonHidden(true)

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

            Text(Date(), style: .time)
                .font(.title2)
                .foregroundColor(Color("DarkBlue"))
        }
    }

    var progressView: some View {
            ZStack {
                //.clipShape(RoundedRectangle(cornerRadius: 25))
                //.padding(5)
                progview[Int.random(in: 0...progview.count-1)]
                    .transition(.slide)
                    .animation(.easeInOut, value: 10)
                    .onAppear {
                        //if we got time
                        /*
                        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
                            withAnimation {
                                currentIndex = (currentIndex + 1) % progview.count
                            }
                         }
                         
                         */
                    }
                    .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                //NavigationLink(destination: ProgressView()) {
                  //  Color.clear
                //}
                //Text("View Progress")
                //.font(.title3)
                //.foregroundColor(Color("Cream"))

        }
    }


    func workoutSummaryView(workout: Workout) -> some View {
        ZStack {
            Color("DarkBlue").ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Workout: \(workout.exerciseName)")
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

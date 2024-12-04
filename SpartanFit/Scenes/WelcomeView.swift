import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var workoutPlanData: WorkoutPlanData
    @EnvironmentObject var workoutHistoryData:WorkoutHistoryData
    @State var pview:[AnyView] = []
    @State var currentIndex: Int = 0
    @State var past:Bool = false
    @State var exnames:[String] = []
    //var barViews: ProgressView().BarChartView
    var body: some View {
        //temp
        //NavigationView {
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
                    //Spacer()
                    if(past){
                        NavigationLink(destination: ProgressView().environmentObject(workoutHistoryData)) {
                                progressView
                                    .frame(height: 275)
                        }
                        .padding(.bottom, 10)
                        .padding()
                    }else{
                        NavigationLink(destination: ProgressView().environmentObject(workoutHistoryData)) {
                            ZStack{
                                Color("DarkBlue")
                                    .frame(height: 275)
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                                Text("Loading")
                                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                    .foregroundStyle(Color("Cream"))
                            }
                        }
                        .padding(.bottom, 10)
                        .padding()
                    }
                    workoutPreviewView()
                        .padding(.bottom, 10)
                }
                .padding()
                .onAppear {
                    refreshWorkoutData()
                    loadData()
                    
                    print(past)
                    if(!past){
                        exnames = pickRelevant()
                    }
                    pview = matchingHistory()
                    print(pview)
                    print(workoutHistoryData.performance)
                }
                .navigationBarBackButtonHidden(true)
            }
            //}
        //}
    }
    // Function to refresh workout data whenever WelcomeView appears
    private func refreshWorkoutData() {
        if let userId = userData.user?.id {
            workoutPlanData.isLoading = true
            workoutPlanData.fetchWorkoutPlan(userId: userId)
            workoutHistoryData.fetchWorkoutHistory(userId: userId)
        }
    }
    
    var progview: [AnyView] {
        [
            /*
             AnyView(BarChartView(workout: "Squat", setData: DBSets.setsTest3, welcomeView: true).id(UUID())),
             AnyView(BarChartView(workout: "Bench Press", setData: DBSets.setsTest2, welcomeView: true).id(UUID())),
             AnyView(BarChartView(workout: "Deadlift", setData: DBSets.setsTest, welcomeView: true).id(UUID()))
             */
            AnyView(BarChartSubView(exname:exnames[pickRandExname()],welcomeView: true).environmentObject(workoutHistoryData)),
        ]
    }
    func pickRandExname()->Int{
        let range = exnames.count - 1
        var n = 0
        if range > 0 {
            n = Int.random(in: 0...range)
        }
        return n
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
            if !pview.isEmpty {
                pview[currentIndex]
                    .id(currentIndex)
                    .transition(.asymmetric(
                        insertion: .slide,
                        removal: .opacity
                    ))
                    .animation(.easeInOut(duration: 0.8), value: currentIndex)
                    .onAppear {
                        // Ensure we only update currentIndex if pview is not empty
                        if !pview.isEmpty {
                            currentIndex = Int.random(in: 0..<pview.count)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            } else {
                // Placeholder or fallback view when pview is empty
                Text("Loading...")
                    .foregroundColor(Color("Cream"))
                    .font(.title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("DarkBlue"))
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
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
    func noHistory(){
        if let historycheck  =  workoutHistoryData.performance {
            if(historycheck.count > 0){
                self.past = true
                print(self.past)
                return
            }
        }
        past = false
    }
    func pickRelevant() -> [String]{
        var exnames:[String] = []
        if let workoutPlan = workoutPlanData.workoutPlan{
            for w in workoutPlan.workouts.first?.exercises ?? [] {
                exnames.append(w.name)
                //print(w.name)
            }
        }
        return exnames
    }
    func pickAll() -> [String]{
        var temp:[String] = []
        if let performance = workoutHistoryData.performance{
            for w in performance{
                temp.append(w.exerciseName)
            }
        }
        let exnames = Array(Set(temp))
        return exnames
    }
    func matchingHistory()-> [AnyView]{
        var progview:[AnyView] = []
        var names = pickAll() //not only pick relevant pick the history if no relevant ones
        //names.append(contentsOf: pickAll())
        for name in names{
            //if(past){
                print(name)
                progview.append( AnyView(BarChartSubView(exname:name,welcomeView: true).environmentObject(workoutHistoryData)))
            //}
        }
        return progview
    }
    func loadData (){
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            noHistory()
        }
    }
    
}

#Preview {
    let previewWorkoutPlanData = sampleWorkoutPlanData
    previewWorkoutPlanData.isLoading = false
    
    return WelcomeView()
        .environmentObject(UserData(user: sampleUser, userPreference: sampleUserPreference))
        .environmentObject(previewWorkoutPlanData)
        .environmentObject(sampleWorkoutHistory)
}

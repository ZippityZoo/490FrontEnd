import SwiftUI

struct WorkoutSessionDetailView: View {
    @EnvironmentObject var workoutPlanData: WorkoutPlanData
    @EnvironmentObject var userData: UserData
    
    @State private var expandedIndex: Int? = nil
    @State private var isShowingFeedbackView = false
    
    
    @State private var completedSets: [Int: Double] = [:]
    
    var body: some View {
        ZStack {
            Color("Cream").ignoresSafeArea()
            
            VStack(spacing: 0) {
                topNavigation()
                titleHeader()
                Spacer()
                exercisesScrollView()
                Spacer()
                feedbackView()
                
            }
            .navigationTitle("Workout Details")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadExpandedIndex()
                if let userId = userData.user?.id {
                    workoutPlanData.fetchWorkoutPlan(userId: userId)  // Refresh data on load
                }
            }
            .onDisappear {
                saveExpandedIndex()
            }
            .onChange(of: isShowingFeedbackView) {
                if !isShowingFeedbackView {  // When feedback view is dismissed
                    if let userId = userData.user?.id {
                        workoutPlanData.fetchWorkoutPlan(userId: userId) // Reload data
                    }
                }
            }
        }
    }
    
    private func loadExpandedIndex() {
        if let savedIndex = UserDefaults.standard.object(forKey: "expandedIndex") as? Int {
            expandedIndex = savedIndex
        } else {
            expandedIndex = 0
        }
    }
    
    private func saveExpandedIndex() {
        if let expandedIndex = expandedIndex {
            UserDefaults.standard.set(expandedIndex, forKey: "expandedIndex")
        }
    }
    
    private func topNavigation() -> some View {
        HStack {
            Spacer()
            NavigationLink(destination: WorkoutPlanView()) {
                Image(systemName: "list.bullet.rectangle")
                    .font(.title)
                    .foregroundColor(Color("DarkBlue"))
                    .padding(.trailing, 20)
            }
        }
        .zIndex(1)
    }
    
    private func titleHeader() -> some View {
        HStack {
            Spacer()
            Text("Today's Workout")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("DarkBlue"))
            Spacer()
        }
        .padding(.top, 10)
        .zIndex(1)
    }
    
    private func exercisesScrollView() -> some View {
        Group {
            if let workout = workoutPlanData.workoutPlan?.workouts.first {
                ScrollViewReader { proxy in
                    ScrollView {
                        AccordionView(expandedIndex: $expandedIndex, sectionCount: workout.exercises.count, label: { index in
                            exerciseLabel(workout.exercises[index].name)
                        }, content: { index in
                            exerciseContent(workout.exercises[index], index: index)
                        })
                    }
                    .onChange(of: expandedIndex, initial: false) { newValue, _ in
                        if let index = newValue {
                            withAnimation(.easeOut(duration: 0.4)) {
                                proxy.scrollTo(index, anchor: .top)
                            }
                        }
                    }
                }
            } else {
                Text("No workout available")
                    .foregroundColor(Color("DarkBlue"))
            }
        }
    }

    
    private func feedbackView() -> some View {
        Button(action: {
            isShowingFeedbackView.toggle()
        }) {
            Text("Submit Feedback")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("DarkBlue"))
                .foregroundColor(Color("Cream"))
                .cornerRadius(10)
                .padding()
        }
        .sheet(isPresented: $isShowingFeedbackView) {
            FeedbackView(isPresented: $isShowingFeedbackView)
                .environmentObject(userData)
                .environmentObject(workoutPlanData)
        }
    }
    
    private func exerciseLabel(_ name: String) -> some View {
        HStack {
            Text(name)
                .font(.title2)
                .foregroundColor(Color("Cream"))
            Spacer()
        }
        .padding(5)
        .background(Color("DarkBlue"))
    }
    
    private func exerciseContent(_ exercise: Exercise, index: Int) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            let totalSets = exercise.planSets
            
            HStack {
                Spacer()
                VStack(alignment: .leading) {
                    Text("Weight")
                        .font(.headline)
                        .foregroundColor(Color("Cream"))
                    Text("\(exercise.planWeight, specifier: "%.1f") lbs")
                        .foregroundColor(Color("Cream"))
                        .font(.subheadline)
                }
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Reps")
                        .font(.headline)
                        .foregroundColor(Color("Cream"))
                    Text("\(exercise.planReps)")
                        .foregroundColor(Color("Cream"))
                        .font(.subheadline)
                }
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Rest")
                        .font(.headline)
                        .foregroundColor(Color("Cream"))
                    Text("\(exercise.restTime)s")
                        .foregroundColor(Color("Cream"))
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding(.bottom, 10)
            
            HStack {
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        Text("Completed Sets")
                            .font(.headline)
                            .foregroundColor(Color("Cream"))
                        
                        Text("\(Int(completedSets[index] ?? 0)) / \(totalSets)")
                            .foregroundColor(Color("Cream"))
                            .font(.subheadline)
                    }
                }
                Spacer()
            }
            
            HStack {
                Text("0")
                    .foregroundColor(Color("Cream"))
                Slider(value: Binding(
                    get: { completedSets[index] ?? 0 },
                    set: { completedSets[index] = $0 }
                ), in: 0...Double(totalSets), step: 1)
                .accentColor(Color("DarkBlue"))
                .cornerRadius(5)
                .frame(height: 20)
                .padding(.horizontal)
                .tint(Color("Cream"))
                .foregroundColor(Color("Cream"))
                .onAppear {
                    if completedSets[index] == nil {
                        completedSets[index] = 0
                    }
                    if let thumbImage = UIImage(systemName: "circle.fill")?
                        .withTintColor(UIColor(named: "Cream") ?? .white, renderingMode: .alwaysOriginal)
                    {
                        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
                    }
                }
                Text("\(totalSets)")
                    .foregroundColor(Color("Cream"))
            }
            
            Spacer()
        }
        .padding()
        .background(Color("DarkBlue"))
        .cornerRadius(10)
        .padding(.horizontal)
    }

}

#Preview {
    WorkoutSessionDetailView()
        .environmentObject(WorkoutPlanData(workoutPlan: sampleWorkoutPlan))
        .environmentObject(UserData(user: sampleUser))
}

// Updated AccordionView to match the structure
struct AccordionView<Label, Content>: View where Label: View, Content: View {
    @Binding var expandedIndex: Int?
    let sectionCount: Int
    @ViewBuilder let label: (Int) -> Label
    @ViewBuilder let content: (Int) -> Content
    
    var body: some View {
        VStack(spacing: -1) {
            ForEach(0..<sectionCount, id: \.self) { index in
                VStack(spacing: -1) {
                    // Header
                    HStack {
                        label(index)
                            .foregroundColor(Color("Cream"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Image(systemName: expandedIndex == index ? "chevron.up" : "chevron.down")
                            .foregroundColor(Color("Cream"))
                    }
                    .padding()
                    .background(Color("DarkBlue"))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            expandedIndex = expandedIndex == index ? nil : index
                        }
                    }
                    
                    // Content that expands with animation
                    if expandedIndex == index {
                        content(index)
                            .background(Color("DarkBlue"))
                            .transition(.opacity)
                    }
                }
                .background(Color("DarkBlue"))
            }
        }
    }
}

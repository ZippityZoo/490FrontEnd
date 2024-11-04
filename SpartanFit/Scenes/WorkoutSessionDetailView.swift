import SwiftUI

struct WorkoutSessionDetailView: View {
    var workout: Workout // Pass the workout directly as a Workout object
    @EnvironmentObject var workoutPlanData: WorkoutPlanData
    @EnvironmentObject var userData: UserData

    @State private var expandedIndex: Int? = nil
    @State private var isShowingFeedbackView = false

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
            }
            .onDisappear {
                saveExpandedIndex()
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
            Text("Workout ID: \(workout.id)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("DarkBlue"))
            Spacer()
        }
        .padding(.top, 10)
        .zIndex(1)
    }

    private func exercisesScrollView() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                AccordionView(expandedIndex: $expandedIndex, sectionCount: workout.exercises.count, label: { index in
                    exerciseLabel(index: index)
                }, content: { index in
                    exerciseContent(index: index)
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
    }

    private func feedbackView() -> some View{
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
    private func exerciseLabel(index: Int) -> some View {
        HStack {
            Text(workout.exercises[index].name)
                .font(.title2)
                .foregroundColor(Color("Cream"))
            Spacer()
        }
        .padding(10)
        .background(Color("DarkBlue"))
    }

    private func exerciseContent(index: Int) -> some View {
        VStack(spacing: 0) {
            ForEach(workout.exercises[index].sets.indices, id: \.self) { setIndex in
                SetView(
                    workoutSet: workout.exercises[index].sets[setIndex],
                    setNumber: setIndex + 1
                )
                .padding(.horizontal)
                .padding(.vertical, -1)
            }
        }
        .padding()
        .background(Color("DarkBlue"))
        .transition(.opacity.combined(with: .push(from: .top)))
    }
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



#Preview {
    WorkoutSessionDetailView(workout: sampleWorkouts[0])
}

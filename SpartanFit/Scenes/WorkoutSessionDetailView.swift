import SwiftUI


struct WorkoutSessionDetailView: View {
    @State var session: WorkoutSession
    @State private var currentIndex: Int = 0
    let allSessions: [WorkoutSession] = sampleWorkoutSessions
    @State private var expandedIndex: Int? = nil

    var body: some View {
        ZStack {
            cream.ignoresSafeArea()
            VStack(spacing: 0) {
                topNavigation()
                dateHeader()
                Spacer()
                exercisesScrollView()
                Spacer()
            }
            .navigationTitle("Today's Workout")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func topNavigation() -> some View {
        HStack {
            Spacer()
            NavigationLink(destination: WorkoutPlanView(workoutPlan: sampleWorkoutPlan)) {
                Image(systemName: "list.bullet.rectangle")
                    .font(.title)
                    .foregroundColor(darkBlue)
                    .padding(.trailing, 20)
            }
        }
        .zIndex(1)
    }

    private func dateHeader() -> some View {
        HStack {
            Spacer()
            Button(action: previousWorkout) {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundColor(darkBlue)
            }
            Spacer()
            Text(session.date, style: .date)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(darkBlue)
            Spacer()
            Button(action: nextWorkout) {
                Image(systemName: "chevron.right")
                    .font(.title)
                    .foregroundColor(darkBlue)
            }
            Spacer()
        }
        .padding(.top, 10)
        .zIndex(1)
    }

    private func exercisesScrollView() -> some View {
        ScrollViewReader { proxy in
            ScrollView {
                AccordionView(expandedIndex: $expandedIndex, sectionCount: session.exercises.count, label: { index in
                    exerciseLabel(index: index)
                }, content: { index in
                    exerciseContent(index: index)
                })
            }
            .onChange(of: expandedIndex) { index in
                if let index = index {
                    withAnimation(.easeInOut(duration: 0.7)) {
                        proxy.scrollTo(index, anchor: .top)
                    }
                }
            }
        }
    }

    private func exerciseLabel(index: Int) -> some View {
        HStack {
            Text("Exercise: \(session.exercises[index].name)")
                .font(.title2)
                .foregroundColor(cream)
            Spacer()
        }
        .padding()
        .background(darkBlue)
    }

    private func exerciseContent(index: Int) -> some View {
        VStack(spacing: 0) {
            ForEach(session.exercises[index].sets.indices, id: \.self) { setIndex in
                SetView(
                    workoutSet: session.exercises[index].sets[setIndex],
                    setNumber: setIndex + 1
                )
                .padding(.horizontal)
                .padding(.vertical, -1)
            }
        }
        .padding()
        .background(darkBlue)
        .transition(.opacity.combined(with: .push(from: .top)))
    }

    private func previousWorkout() {
        if currentIndex > 0 {
            currentIndex -= 1
            session = allSessions[currentIndex]
        }
    }

    private func nextWorkout() {
        if currentIndex < allSessions.count - 1 {
            currentIndex += 1
            session = allSessions[currentIndex]
        }
    }
}

#Preview {
    WorkoutSessionDetailView(session: sampleWorkoutSessions[0])
}


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
                            .foregroundColor(cream)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Image(systemName: expandedIndex == index ? "chevron.up" : "chevron.down")
                            .foregroundColor(cream)
                    }
                    .padding()
                    .background(darkBlue)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            expandedIndex = expandedIndex == index ? nil : index
                        }
                    }

                    // Content that expands with animation
                    if expandedIndex == index {
                        content(index)
                            .background(darkBlue)
                            .transition(.opacity.combined(with: .push(from: .top)))
                    }
                }
                .background(darkBlue)
            }
        }
    }
}

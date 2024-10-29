import SwiftUI

struct AccordionView<Label, Content>: View
where Label : View, Content : View {
  @Binding var expandedIndex: Int?
  let sectionCount: Int
  @ViewBuilder let label: (Int) -> Label
  @ViewBuilder let content: (Int) -> Content

  var body: some View {
    VStack(spacing: 0) {
        ForEach(0..<sectionCount, id: \ .self) { index in
        DisclosureGroup(isExpanded: .init(get: {
          expandedIndex == index
        }, set: { value in
          expandedIndex = value ? index : nil
        }), content: {
          content(index)
        }, label: {
          label(index)
        })
        .background(cream)
        .cornerRadius(15)
        .padding(.vertical, -1) // Adjust padding to make items touch
      }
    }
  }
}

struct WorkoutSessionDetailView: View {
    @State var session: WorkoutSession
    @State private var currentIndex: Int = 0 // Tracks the index for the workout session
    let allSessions: [WorkoutSession] = sampleWorkoutSessions // Assuming sampleWorkoutSessions holds the list of all sessions
    @State private var expandedIndex: Int? = nil
    @State private var expandedSetIndex: Int? = nil

    var body: some View {
        ZStack {
            Color("DarkBlue").ignoresSafeArea()
            VStack(spacing: 0) { // Remove extra space to anchor to top
                // Button to go to the workout plan (Top Right)
                HStack {
                    Spacer()
                    NavigationLink(destination: WorkoutPlanView(workoutPlan: sampleWorkoutPlan)) {
                        Image(systemName: "list.bullet.rectangle")
                            .font(.title)
                            .foregroundColor(cream)
                            .padding(.trailing, 20)
                    }
                }
                .zIndex(1) // Keep the header on top
                
                // Header with arrows for navigating between workout dates
                HStack {
                    Spacer()
                    Button(action: previousWorkout) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(cream)
                    }
                    Spacer()
                    
                    Text(session.date, style: .date)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(cream)
                    
                    Spacer()
                    Button(action: nextWorkout) {
                        Image(systemName: "chevron.right")
                            .font(.title)
                            .foregroundColor(cream)
                    }
                    Spacer()
                }
                .padding(.top, 10)
                .zIndex(1) // Keep the header on top
        
                // Exercises in the session using AccordionView
                ScrollViewReader { proxy in
                    ScrollView {
                        AccordionView(expandedIndex: $expandedIndex, sectionCount: session.exercises.count, label: { index in
                            HStack {
                                Text("Exercise: \(session.exercises[index].name)")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: expandedIndex == index ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.black)
                            }
                            .padding()
                            .background(cream) // Make entire item cream
                            .cornerRadius(15)
                        }, content: { index in
                            VStack(spacing: 0) {
                                ForEach(session.exercises[index].sets.indices, id: \ .self) { setIndex in
                                    SetView(workoutSet: session.exercises[index].sets[setIndex], setNumber: setIndex + 1, expandedSetIndex: $expandedSetIndex)
                                        .padding(.horizontal)
                                }
                            }
                            .padding()
                            .background(cream)
                            .cornerRadius(15)
                        })
                        .padding(.top, 10)
                    }
                    .onChange(of: expandedIndex) { index in
                        if let index = index {
                            withAnimation {
                                proxy.scrollTo(index, anchor: .top)
                            }
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("Today's Workout")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // Function to go to the previous workout
    func previousWorkout() {
        if currentIndex > 0 {
            currentIndex -= 1
            session = allSessions[currentIndex]
        }
    }

    // Function to go to the next workout
    func nextWorkout() {
        if currentIndex < allSessions.count - 1 {
            currentIndex += 1
            session = allSessions[currentIndex]
        }
    }
}


#Preview {
    WorkoutSessionDetailView(session: sampleWorkoutSessions[1])
}

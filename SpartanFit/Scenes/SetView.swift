import SwiftUI

struct SetView: View {
    @ObservedObject var workoutSet: WorkoutSet
    var setNumber: Int

    var body: some View {
        VStack(spacing: -1) {
            HStack {
                Text("Set \(setNumber) - \(workoutSet.type.description)")
                    .font(.title3)
                    .foregroundColor(cream)
                Spacer()
            }
            //.padding(.vertical, -1)
            .background(darkBlue)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .listRowSeparatorLeading) {
                        Text("Weight")
                            .font(.headline)
                            .foregroundColor(cream)
                        Text("\(workoutSet.weight, specifier: "%.1f") lbs")
                            .foregroundColor(cream)
                            .font(.subheadline)
                        Spacer()
                    }
                    Spacer()
                    VStack(alignment: .listRowSeparatorLeading) {
                        Text("Goal Reps")
                            .font(.headline)
                            .foregroundColor(cream)
                        Text(workoutSet.repsAssumed.map { String($0) }.joined(separator: ", "))
                            .foregroundColor(cream)
                            .font(.subheadline)
                        Spacer()
                    }
                    Spacer()
                    VStack(alignment: .listRowSeparatorLeading) {
                        Text("Rest")
                            .font(.headline)
                            .foregroundColor(cream)
                        Text("\(workoutSet.restTime)s")
                            .foregroundColor(cream)
                            .font(.subheadline)
                        Spacer()
                    }
                    Spacer()
                    VStack(alignment: .listRowSeparatorLeading) {
                        Text("Completed Reps")
                            .font(.headline)
                            .foregroundColor(cream)
                        TextField("Completed Reps", value: $workoutSet.repsInput[0], formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                            .foregroundColor(cream)
                            .font(.subheadline)
                        Spacer()
                    }
                }
                .background(Color("Background"))
                .cornerRadius(10)
            }
            .padding()
            .background(darkBlue)
        }
        .padding(.vertical, -1)
    }
}

#Preview {
    WorkoutSessionDetailView(session: sampleWorkoutSessions[0])
}

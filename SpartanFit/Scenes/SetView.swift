import SwiftUI

struct SetView: View {
    @ObservedObject var workoutSet: WorkoutSet
    var setNumber: Int

    var body: some View {
        VStack(spacing: -1) {
            HStack {
                Text("Set \(setNumber) - \(workoutSet.type.description)")
                    .font(.title3)
                    .foregroundColor(Color("Cream"))
                Spacer()
            }
            //.padding(.vertical, -1)
            .background(Color("DarkBlue"))

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .listRowSeparatorLeading) {
                        Text("Weight")
                            .font(.headline)
                            .foregroundColor(Color("Cream"))
                        Text("\(workoutSet.weight, specifier: "%.1f") lbs")
                            .foregroundColor(Color("Cream"))
                            .font(.subheadline)
                        Spacer()
                    }
                    Spacer()
                    VStack(alignment: .listRowSeparatorLeading) {
                        Text("Goal Reps")
                            .font(.headline)
                            .foregroundColor(Color("Cream"))
                        Text(workoutSet.repsAssumed.map { String($0) }.joined(separator: ", "))
                            .foregroundColor(Color("Cream"))
                            .font(.subheadline)
                        Spacer()
                    }
                    Spacer()
                    VStack(alignment: .listRowSeparatorLeading) {
                        Text("Rest")
                            .font(.headline)
                            .foregroundColor(Color("Cream"))
                        Text("\(workoutSet.restTime)s")
                            .foregroundColor(Color("Cream"))
                            .font(.subheadline)
                        Spacer()
                    }
                    Spacer()
                    VStack(alignment: .listRowSeparatorLeading) {
                        Text("Completed Reps")
                            .font(.headline)
                            .foregroundColor(Color("Cream"))
                        TextField("Completed Reps", value: $workoutSet.repsInput[0], formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                            .foregroundColor(Color("Cream"))
                            .font(.subheadline)
                        Spacer()
                    }
                }
                .background(Color("DarkBlue"))
                .cornerRadius(10)
            }
            .padding()
            .background(Color("DarkBlue"))
        }
        .padding(.vertical, -1)
    }
}

#Preview {
    WorkoutSessionDetailView(workout: sampleWorkouts[0])
}

//
//  SetView.swift
//  SpartanFit
//
//  Created by Garrett Emerich on 10/17/24.
//
import SwiftUI

struct SetView: View {
    @ObservedObject var workoutSet: WorkoutSet  // ObservedObject to track changes
    var setNumber: Int
    @Binding var expandedSetIndex: Int?

    var body: some View {
        DisclosureGroup(
            isExpanded: .init(get: {
                expandedSetIndex == setNumber
            }, set: { value in
                expandedSetIndex = value ? setNumber : nil
            }),
            content: {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Weight")
                                .font(.headline)
                                .foregroundColor(Color("Foreground"))
                            Text("\(workoutSet.weight, specifier: "%.1f") lbs")
                                .foregroundColor(Color("Foreground"))
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Goal Reps")
                                .font(.headline)
                                .foregroundColor(Color("Foreground"))
                            Text(workoutSet.repsAssumed.map { String($0) }.joined(separator: ", "))
                                .foregroundColor(Color("Foreground"))
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("Rest")
                                .font(.headline)
                                .foregroundColor(Color("cream"))
                            Text("\(workoutSet.restTime) sec")
                                .foregroundColor(Color("Foreground"))
                        }
                    }
                    .padding(.bottom, 10)

                    TextField("Completed Reps", value: $workoutSet.repsInput[0], formatter: NumberFormatter())  // Adjust this to fit your data structure for completed reps
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                        .foregroundColor(Color("Foreground"))
                }
                .padding()
            },
            label: {
                HStack {
                    Text("Set \(setNumber) - \(workoutSet.type.description) - \(workoutSet.repsAssumed.first ?? 0) reps - \(workoutSet.weight, specifier: "%.1f") lbs")
                        .font(.headline)
                        .foregroundColor(Color("Foreground"))
                    Spacer()
                    Image(systemName: expandedSetIndex == setNumber ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color("Foreground"))
                }
                .background(Color("Background"))
                .cornerRadius(10)
            }
        )
    }
}



//#Preview {
//    SetView(workoutSet: WorkoutSet(type: .regular, weight: 135.0, repsAssumed: [10, 8], restTime: 60), setNumber: 1, expandedSetIndex: <#Binding<Int?>#>)
//}

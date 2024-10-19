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
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack{
                Text("Set \(setNumber)")
                    .font(.headline)
                    .foregroundColor(.yellow)
                Text("\(workoutSet.type.description)").font(.headline)
                    .foregroundColor(.yellow)
            }
            Divider()
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Weight")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(workoutSet.weight, specifier: "%.1f") lbs")
                        .foregroundColor(.white)
                        .padding(.top)
                        .padding(.bottom)
                }
                VStack(alignment: .leading) {
                    Text("Reps")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    // Editable TextField for reps input
                    ForEach(workoutSet.repsInput.indices, id: \.self) { index in
                        TextField("Reps", value: $workoutSet.repsInput[index], formatter: NumberFormatter())
                            .keyboardType(.numberPad)  // Enable number pad for easier input
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                            .minimumScaleFactor(1)
                            
                    }
                }
                VStack(alignment: .leading) {
                    Text("Goal Reps")
                        .font(.headline)
                        .foregroundColor(.white)
                    VStack{
                        ForEach(workoutSet.repsAssumed, id:\.self){goal in
                            Text("\(goal)").foregroundColor(.white)
                                .padding(4)
                            
                        }
                        
                    }
    
                }
                VStack(alignment: .leading) {
                    Text("Rest")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(workoutSet.restTime) sec")
                        .foregroundColor(.white)
                        .padding(.top)
                        .padding(.bottom)

                }
                
            }
                /*
                Spacer()
                VStack(alignment: .leading) {
                    Text("Weight")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(workoutSet.weight, specifier: "%.1f") lbs")
                        .foregroundColor(.white)
                    Spacer()
                }
                //Spacer()
                VStack(alignment: .leading) {
                    Text("Reps")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    // Editable TextField for reps input
                    ForEach(workoutSet.repsInput.indices, id: \.self) { index in
                        TextField("Reps", value: $workoutSet.repsInput[index], formatter: NumberFormatter())
                            .keyboardType(.numberPad)  // Enable number pad for easier input
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                    }.scaledToFit()
                }
                //Spacer()
                VStack(alignment: .leading) {
                    Text("Goal Reps")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(workoutSet.repsAssumed.map { String($0) }.joined(separator: ", "))
                        .foregroundColor(.white)
                    Spacer()
                }
               //Spacer()
                VStack(alignment: .leading) {
                    Text("Rest")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(workoutSet.restTime) sec")
                        .foregroundColor(.white)
                    Spacer()
                }
                 */
            
            Divider()
                .background(Color.white)
                
        }
        .padding()
        .background(Color("DarkBlue").cornerRadius(15))
    }
}

#Preview {
    SetView(workoutSet: WorkoutSet(type: .regular, weight: 135.0, repsAssumed: [10, 8], restTime: 60), setNumber: 1)
}

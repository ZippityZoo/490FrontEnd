//
//  WorkoutView.swift
//  SpartanFit
//
//  Created by Collin Harris on 10/10/24.
//

import SwiftUI

struct WorkoutView: View {
    var body: some View {
        Text("Workout View")
        SetView()
    }
}

struct SetView:View {
    @State private var weight = 120
    @State private var reps = 0
    @State private var goal = 10
    var body: some View {
        ZStack{
            Color(red:0.5,green:0.5,blue:0.5)
            VStack{
                Text(String(weight))
                Divider()
                Text(String(reps))
                Text(String(goal))
            }.padding(10).background().clipShape(RoundedRectangle(cornerRadius: 15.0))
        }
        
    }
}
#Preview {
    WorkoutView()
}

////
////  WorkoutView.swift
////  SpartanFit
////
////  Created by Collin Harris on 10/10/24.
////
//
//import SwiftUI
//
//struct WorkoutView: View {
//    var body: some View {
//        Text("Workout View")
//        Exercise_Page(setCount: 3)
//    }
//}
//struct Exercise_Page:View {
//    @State var setCount: Int
//    let setViews = [SetView]()
//    let threeSets = [
//        SetView(),
//        SetView(),
//        SetView()
//    ]
//    var id = UUID()
//    //var setview :Int
//    var body: some View{
//        ZStack{
//            Color(red:0.5,green:0.5,blue:0.5)
//            VStack{
//                Spacer()
//                HStack{
//                        //SetView()
//                    ForEach(threeSets, id:\.id) { view in
//                        view
//                    }
//                    
//                    }
//                }
//                Spacer()
//                HStack{
//                    ForEach(setViews, id: \.id){view in
//                        view
//                    }
//                }
//            }
//        }
//    /*
//    init(setCount: Int) {
//        self.setCount = setCount
//    }
//     */
//}
//
//
//
//
////so each set view has to
////UUID
////
//struct SetView:View {
//    var id = UUID()
//    //@Published var data = [SetData]()
//    @State private var weight = 120
//    @State private var reps = 0
//    @State private var goal = 10
//    @State private var sets = 0
//    var body: some View {
//        ZStack{
//            Color(red:0.5,green:0.5,blue:0.5)
//            HStack{
//                VStack{
//                    Text(String(weight))
//                    Divider()
//                    Text(String(reps))
//                    Text(String(goal))
//                }.padding(10).background().clipShape(RoundedRectangle(cornerRadius: 15.0))
//            }
//        }
//        
//    }
//}
//
//struct SetData: Identifiable {
//    var id = UUID()
//    var text = String()
//}
//
//#Preview {
//    WorkoutView()
//}

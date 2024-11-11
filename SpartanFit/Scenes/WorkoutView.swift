////
////  WorkoutView.swift
////  SpartanFit
////
////  Created by Collin Harris on 10/10/24.
////
//
import SwiftUI
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
import SwiftUI
import Charts
/*
struct ValuePerCategory {
    var category: String
    var value: Double
}


let data: [ValuePerCategory] = [
    .init(category: "A", value: 5),
    .init(category: "B", value: 9),
    .init(category: "C", value: 7)
]

struct ContentView: View {
    var body: some View {
        ZStack{
            Chart(data, id: \.category) { item in
                BarMark(
                    x: .value("Category", item.category),
                    y: .value("Value", item.value)
                )
            }
        }
    }
}
 */
//let workoutNamesTest:AllWorkoutNames = sampleWorkoutNames


struct LChartView: View {
    var body: some View {
        Text("Line Chart")
            .font(.largeTitle)
            .padding()
            .background(Color.blue.opacity(0.3))
            .cornerRadius(12)
    }
}

struct BChartView: View {
    var body: some View {
        Text("Bar Chart")
            .font(.largeTitle)
            .padding()
            .background(Color.green.opacity(0.3))
            .cornerRadius(12)
    }
}

struct PChartView: View {
    var body: some View {
        Text("Pie Chart")
            .font(.largeTitle)
            .padding()
            .background(Color.red.opacity(0.3))
            .cornerRadius(12)
    }
}
/*
struct ContentView: View {
    @State private var currentIndex: Int = 0
    let chartViews: [AnyView] = [
        AnyView(LChartView()),
        AnyView(BChartView()),
        AnyView(PChartView())
    ]

    var body: some View {
        VStack {
            chartViews[currentIndex]
                .transition(.slide)
                .animation(.easeInOut)

            HStack {
                Button("Previous") {
                    withAnimation {
                        currentIndex = (currentIndex - 1 + chartViews.count) % chartViews.count
                    }
                }
                .disabled(currentIndex == 0)

                Spacer()

                Button("Next") {
                    withAnimation {
                        currentIndex = (currentIndex + 1) % chartViews.count
                    }
                }
                .disabled(currentIndex == chartViews.count - 1)
            }
            .padding()
        }
        .padding()
    }
}

*/
struct ContentView : View {
    //var head:ProgressView = ProgressView()
    /*
    var progview:[AnyView] = [
        AnyView(BarChartSubView().environmentObject(sampleWorkoutHistory)),
        AnyView(BarChartSubView().environmentObject(sampleWorkoutHistory)),
        AnyView(BarChartSubView().environmentObject(sampleWorkoutHistory))
    ]
     */
    var body: some View{
        
        VStack{
            //progview[0]
            //BarChartSubView().environmentObject(sampleWorkoutHistory)
            Text("OHHHHH NOOOOOO")
        }
        //BarChartSubView().environmentObject(sampleWorkoutHistory)
    }
    
}

#Preview{
    ContentView()
}





/*so for sets we have to have
 rep number ex:10
 what set it is ex:set 2
 the date ex 10/22/24
 
*/
/*
struct ContentView: View {
    let numbers: [Double]
    
    var body: some View {
        Chart {
            ForEach(Array(numbers.enumerated()), id: \.offset) { index, value in
                LineMark(
                    x: .value("Index", index),
                    y: .value("Value", value)
                )
            }
        }.padding(50)
    }
}
 */



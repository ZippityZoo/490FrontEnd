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

struct SalesData {
    let month: String
    let productA: Double
    let productB: Double
    let productC: Double
}

let salesData: [SalesData] = [
    SalesData(month: "January", productA: 3000, productB: 2000, productC: 1500),
    SalesData(month: "February", productA: 4000, productB: 2500, productC: 2000),
    SalesData(month: "March", productA: 3500, productB: 3000, productC: 2500)
]


struct StackedBarGraph: View {
    let data: [SalesData]

    var body: some View {
        VStack {
            ForEach(data, id: \.month) { entry in
                HStack(spacing: 10) {
                    // Product A
                    Rectangle()
                        .fill(Color.red)
                        .frame(width: 30, height: CGFloat(entry.productA / 100)) // Scale for visibility
                    // Product B
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 30, height: CGFloat(entry.productB / 100)) // Scale for visibility
                    // Product C
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 30, height: CGFloat(entry.productC / 100)) // Scale for visibility
                }
                .frame(height: 200) // Set a fixed height for each row
                .overlay(
                    Text(entry.month)
                        .font(.caption)
                        .foregroundColor(.black)
                        .padding(.top, 5),
                    alignment: .top
                )
            }
        }
        .padding()
    }
}
#Preview{
    ContentView()
}

struct ContentView: View {
    var body: some View {
        VStack{
            Text("\(NSDate())")
            StackedBarGraph(data: salesData)
                .padding()
                .border(Color.black)
        }
    }
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
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(numbers:[1.0,5.0,3.0,7.0,7.0,8.0])
    }
}
*/

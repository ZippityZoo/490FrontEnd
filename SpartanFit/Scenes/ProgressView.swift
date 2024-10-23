//
//  ProgressView.swift
//  SpartanFit
//
//  Created by Collin Harris on 10/10/24.
//

import SwiftUI
import Charts

struct ProgressView: View {
    var body: some View {
        ZStack{
            Color("Gold").ignoresSafeArea()
            VStack{
                Text("Progress View")
                BarChartView()
                
            }
        }
    }
}


struct BarChartView: View {
    //let data: [(id:UUID,weight: Double, reps: Int)]
    let setData = DBSets.setsTest
    var body: some View {
        VStack{
            //Chart(setData){point in
            Chart(setData){ day in
                    ForEach(day.sets,id: \.id){set in
                        BarMark(
                            x:.value("X",set.reps),
                            y:.value("Y",set.date.formatted(date: .abbreviated, time: .omitted))
                        ).foregroundStyle(by:.value("Set",set.setNumber.rawValue)).annotation(position: .overlay){
                            Text(set.weight.formatted()).font(.caption.bold())
                        
                    }
                }
            }.frame(height: 300)
            .chartForegroundStyleScale([
                    "SetOne": .green, "SetTwo": .purple, "SetThree": .pink, "SetFour": .yellow,
                    "SetFive": .black,
                    "SetSix":.blue
                ])
        }
        .padding()
        .background(Color("DarkBlue"))
        .cornerRadius(10)
    }
}
//Stuff to simulate DB info
enum SetNum: String{
    case SetOne = "SetOne"
    case SetTwo = "SetTwo"
    case SetThree = "SetThree"
    case SetFour = "SetFour"
    case SetFive = "SetFive"
}
struct Sets:Identifiable{
    var id = UUID()
    var weight:Double//Label
    var reps:Int//Value
    var setNumber:SetNum//Label/Color
    var date:Date//Value
}
struct DBSets:Identifiable{
    var id = UUID()
    var sets: [Sets]
             
    func sum()->Int{
        var sum: Int = 0
        for rep in self.sets{
            sum += rep.reps
        }
        return sum
    }
}
extension DBSets: Hashable{
    static let setsTest:[DBSets] = [
        .init(sets: [Sets(weight: 50.0, reps:10,setNumber: .SetOne,date:Date().addingTimeInterval(86400) ),Sets(weight: 55.0, reps:8,setNumber: .SetTwo,date:Date().addingTimeInterval(86400)),Sets(weight: 60.0, reps:6,setNumber: .SetThree,date:Date().addingTimeInterval(86400))]),
        .init(sets: [Sets(weight: 55.0, reps:8,setNumber: .SetOne,date:Date().addingTimeInterval(86400*2)),Sets(weight: 55.0, reps:7,setNumber: .SetTwo,date:Date().addingTimeInterval(86400*2)),Sets(weight: 60.0, reps:6,setNumber: .SetThree,date:Date().addingTimeInterval(86400*2))]),
        .init(sets: [Sets(weight: 55.0, reps:10,setNumber: .SetOne,date:Date().addingTimeInterval(86400*3)),Sets(weight: 55.0, reps:9,setNumber: .SetTwo,date:Date().addingTimeInterval(86400*3)),Sets(weight: 60.0, reps:8,setNumber: .SetThree,date:Date().addingTimeInterval(86400*3))]),
        .init(sets: [Sets(weight: 60.0, reps:7,setNumber: .SetOne,date:Date().addingTimeInterval(86400*4)),Sets(weight: 60, reps:7,setNumber: .SetTwo,date:Date().addingTimeInterval(86400*4)),Sets(weight: 60.0, reps:6,setNumber: .SetThree,date:Date().addingTimeInterval(86400*4)),Sets(weight: 60.0, reps:4,setNumber: .SetFour,date:Date().addingTimeInterval(86400*4))])
        
    ]
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func ==(lhs:DBSets,rhs:DBSets)->Bool{
        let areEqual = lhs.id == rhs.id
            return areEqual
    }
    
}

#Preview {
    ProgressView()
}


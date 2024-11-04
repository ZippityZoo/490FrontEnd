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
        WorkoutProgressList()
    }
}
//Will Have a list of workouts for the user to select
struct WorkoutProgressList:View{
    var body: some View{
        
            ZStack{
                Color("Cream")
                VStack{
                    Text("Progress").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold()
                    List{
                        ForEach(workoutNames,id:\.self){ workout in
                            HStack{
                                NavigationLink(destination: BarChartView(workout: workout)){
                                    Text(workout)
                                }.foregroundStyle(Color.white)
                            }
                        }.listRowBackground(Color("DarkBlue"))
                    }.scrollContentBackground(.hidden)
                }.background(Color("Cream"))
            }
        
    }
}
struct NavBar: View{
    @State var isrecent:Bool = true
    @Binding var setData:[DBSets]
    var body: some View{
        ZStack{
            Color("Cream")
            HStack{
                Spacer()
                Button(action:recent){
                    Text("Recent")
                }
                Spacer()
                Divider()
                Spacer()
                Button(action:overall){
                    Text("Overall")
                }
                Spacer()
            }
        }.frame(height:40)
            .clipShape(RoundedRectangle(cornerRadius: 10)).padding(4).background(.black).clipShape(RoundedRectangle(cornerRadius: 10))
    }
    func recent(){
        isrecent = true
        setData = DBSets.setsTest
        print(isrecent)
    }
    func overall(){
        isrecent = false
        setData = DBSets.setsTest2
        print(isrecent)
    }
}

struct BarChartView: View {
    //let data: [(id:UUID,weight: Double, reps: Int)]
    var workout:String
    @State var setData = DBSets.setsTest2
    @State var welcomeView:Bool = false
    var body: some View {
        //just for testing
        ZStack{
            Color("Cream").ignoresSafeArea()
            VStack{
                if(welcomeView){
                    EmptyView()
                }else{
                    NavBar(setData:$setData)
                }
                VStack{
                    Text(workout).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold().foregroundStyle(.white)
                    //Chart(setData){point in
                    Chart(setData){ day in
                        ForEach(day.sets,id: \.id){set in
                            BarMark(
                                x:.value("X",set.date.formatted(date: .numeric, time: .omitted)),
                                y:.value("Y",set.reps)
                            )
                            .foregroundStyle(by:.value("Set",set.setNumber.rawValue)).annotation(position: .overlay){Text(set.weight.formatted()).font(.caption.bold())
                                
                           }
                        }
                    }.frame(height: 300)
                        .chartForegroundStyleScale([
                            "SetOne": Color("Set1"), "SetTwo": Color("Set2"), "SetThree": Color("Set3"), "SetFour": Color("Set4"),
                            "SetFive": Color("Set5"),
                            "SetSix": Color("SetOne")
                        ])
                        
                        .chartXAxis {
                                    AxisMarks {
                                        AxisValueLabel()
                                            .foregroundStyle(.white)
                                    }
                                    
                                }
                        .chartYAxis {
                                    AxisMarks {
                                        AxisValueLabel()
                                            .foregroundStyle(.white)
                                    }
                                
                                }
                    
                        
                        
                    
                }
                .padding()
                .background(Color("DarkBlue"))
                .cornerRadius(10)
            }
        }
    }
}
struct LineChartView: View {
    //let data: [(id:UUID,weight: Double, reps: Int)]
    var workout:String
    @State var setData = DBSets.setsTest2
    @State var welcomeView:Bool = false
    var body: some View {
        //just for testing
        ZStack{
            Color("Cream").ignoresSafeArea()
            VStack{
                if(welcomeView){
                    EmptyView()
                }else{
                    NavBar(setData:$setData)
                }
                VStack{
                    Text(workout).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold().foregroundStyle(.white)
                    //Chart(setData){point in
                    Chart(setData){ day in
                        ForEach(day.sets,id: \.id){set in
                            AreaMark(
                                x:.value("X",set.date.formatted(date: .numeric, time: .omitted)),
                                y:.value("Y",set.reps)
                            )
                            .foregroundStyle(by:.value("Set",set.setNumber.rawValue))
                           /* .annotation(position: .overlay){Text(set.weight.formatted()).font(.caption.bold())
                                
                           }
                            */
                        }
                    }.frame(height: 300)
                        .chartForegroundStyleScale([
                            "SetOne": Color("Set1"), "SetTwo": Color("Set2"), "SetThree": Color("Set3"), "SetFour": Color("Set4"),
                            "SetFive": Color("Set5"),
                            "SetSix": Color("SetOne")
                        ])
                        
                        .chartXAxis {
                                    AxisMarks {
                                        AxisValueLabel()
                                            .foregroundStyle(.white)
                                    }
                                    
                                }
                        .chartYAxis {
                                    AxisMarks {
                                        AxisValueLabel()
                                            .foregroundStyle(.white)
                                    }
                                
                                }
                    
                        
                        
                    
                }
                .padding()
                .background(Color("DarkBlue"))
                .cornerRadius(10)
            }
        }
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
        .init(sets: [Sets(weight: 55.0, reps:8,setNumber: .SetOne,date:Date().addingTimeInterval(86400*3)),Sets(weight: 55.0, reps:7,setNumber: .SetTwo,date:Date().addingTimeInterval(86400*3)),Sets(weight: 60.0, reps:6,setNumber: .SetThree,date:Date().addingTimeInterval(86400*3))]),
        .init(sets: [Sets(weight: 55.0, reps:10,setNumber: .SetOne,date:Date().addingTimeInterval(86400*6)),Sets(weight: 55.0, reps:9,setNumber: .SetTwo,date:Date().addingTimeInterval(86400*6)),Sets(weight: 60.0, reps:8,setNumber: .SetThree,date:Date().addingTimeInterval(86400*6))]),
        .init(sets: [Sets(weight: 60.0, reps:7,setNumber: .SetOne,date:Date().addingTimeInterval(86400*9)),Sets(weight: 60, reps:7,setNumber: .SetTwo,date:Date().addingTimeInterval(86400*9)),Sets(weight: 60.0, reps:6,setNumber: .SetThree,date:Date().addingTimeInterval(86400*9)),Sets(weight: 60.0, reps:4,setNumber: .SetFour,date:Date().addingTimeInterval(86400*9))]),
        .init(sets: [Sets(weight: 60.0, reps:9,setNumber: .SetOne,date:Date().addingTimeInterval(86400*12)),Sets(weight: 60, reps:7,setNumber: .SetTwo,date:Date().addingTimeInterval(86400*12)),Sets(weight: 65.0, reps:5,setNumber: .SetThree,date:Date().addingTimeInterval(86400*12)),Sets(weight: 65.0, reps:5,setNumber: .SetFour,date:Date().addingTimeInterval(86400*12))])
    ]
    static let setsTest2:[DBSets] = [
        .init(sets: [Sets(weight: 100.0, reps:10,setNumber: .SetOne,date:Date().addingTimeInterval(86400) ),Sets(weight: 100.0, reps:10,setNumber: .SetTwo,date:Date().addingTimeInterval(86400)),Sets(weight: 60.0, reps:10,setNumber: .SetThree,date:Date().addingTimeInterval(86400))]),
        .init(sets: [Sets(weight: 110.0, reps:8,setNumber: .SetOne,date:Date().addingTimeInterval(86400*3)),Sets(weight: 110.0, reps:7,setNumber: .SetTwo,date:Date().addingTimeInterval(86400*3)),Sets(weight: 110.0, reps:6,setNumber: .SetThree,date:Date().addingTimeInterval(86400*3))]),
        .init(sets: [Sets(weight: 110.0, reps:10,setNumber: .SetOne,date:Date().addingTimeInterval(86400*6)),Sets(weight: 110.0, reps:9,setNumber: .SetTwo,date:Date().addingTimeInterval(86400*6)),Sets(weight: 110.0, reps:8,setNumber: .SetThree,date:Date().addingTimeInterval(86400*6))]),
        .init(sets: [Sets(weight: 120.0, reps:8,setNumber: .SetOne,date:Date().addingTimeInterval(86400*9)),Sets(weight: 110.0, reps:8,setNumber: .SetTwo,date:Date().addingTimeInterval(86400*9)),Sets(weight: 110.0, reps:8,setNumber: .SetThree,date:Date().addingTimeInterval(86400*9)),Sets(weight: 110.0, reps:4,setNumber: .SetFour,date:Date().addingTimeInterval(86400*9)),Sets(weight: 110.0, reps:4,setNumber: .SetFive,date:Date().addingTimeInterval(86400*9))]),
        .init(sets: [Sets(weight: 110.0, reps:5,setNumber: .SetOne,date:Date().addingTimeInterval(86400*12)),Sets(weight: 110.0, reps:5,setNumber: .SetTwo,date:Date().addingTimeInterval(86400*12)),Sets(weight: 120.0, reps:5,setNumber: .SetThree,date:Date().addingTimeInterval(86400*12))])
        ]
    static let setsTest3:[DBSets] = [
        .init(sets: [Sets(weight: 195.0, reps:8,setNumber: .SetOne,date:Date().addingTimeInterval(86400)),Sets(weight: 200.0, reps:7,setNumber: .SetTwo,date:Date().addingTimeInterval(86400)),Sets(weight: 200.0, reps:6,setNumber: .SetThree,date:Date().addingTimeInterval(86400))]),
        .init(sets: [Sets(weight: 210.0, reps:10,setNumber: .SetOne,date:Date().addingTimeInterval(86400*6)),Sets(weight: 210.0, reps:9,setNumber: .SetTwo,date:Date().addingTimeInterval(86400*6)),Sets(weight: 210.0, reps:8,setNumber: .SetThree,date:Date().addingTimeInterval(86400*6))]),
        .init(sets: [Sets(weight: 210.0, reps:7,setNumber: .SetOne,date:Date().addingTimeInterval(86400*9)),Sets(weight: 210.0, reps:7,setNumber: .SetTwo,date:Date().addingTimeInterval(86400*9)),Sets(weight: 210.0, reps:6,setNumber: .SetThree,date:Date().addingTimeInterval(86400*9)),Sets(weight: 210.0, reps:4,setNumber: .SetFour,date:Date().addingTimeInterval(86400*9))]),
    ]
    static let setsTest4:[DBSets] = [
        .init(sets: [Sets(weight: 25.0, reps:10,setNumber: .SetOne,date:Date().addingTimeInterval(86400) ),Sets(weight: 25.0, reps:10,setNumber: .SetTwo,date:Date().addingTimeInterval(86400)),Sets(weight: 25.0, reps:10,setNumber: .SetThree,date:Date().addingTimeInterval(86400))]),
        .init(sets: [Sets(weight: 25.0, reps:8,setNumber: .SetOne,date:Date().addingTimeInterval(86400*3)),Sets(weight: 25, reps:7,setNumber: .SetTwo,date:Date().addingTimeInterval(86400*3)),Sets(weight: 25, reps:6,setNumber: .SetThree,date:Date().addingTimeInterval(86400*3))]),
        .init(sets: [Sets(weight: 30, reps:10,setNumber: .SetOne,date:Date().addingTimeInterval(86400*6)),Sets(weight: 30, reps:9,setNumber: .SetTwo,date:Date().addingTimeInterval(86400*6)),Sets(weight: 30, reps:8,setNumber: .SetThree,date:Date().addingTimeInterval(86400*6))]),
        .init(sets: [Sets(weight: 30, reps:10,setNumber: .SetOne,date:Date().addingTimeInterval(86400*9)),Sets(weight: 30, reps:10,setNumber: .SetTwo,date:Date().addingTimeInterval(86400*9)),Sets(weight: 30, reps:10,setNumber: .SetThree,date:Date().addingTimeInterval(86400*9))]),
        .init(sets: [Sets(weight: 30, reps:10,setNumber: .SetOne,date:Date().addingTimeInterval(86400*12)),Sets(weight: 30, reps:10,setNumber: .SetTwo,date:Date().addingTimeInterval(86400*12)),Sets(weight: 30, reps:10,setNumber: .SetThree,date:Date().addingTimeInterval(86400*12))])
    ]
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func ==(lhs:DBSets,rhs:DBSets)->Bool{
        let areEqual = lhs.id == rhs.id
        return areEqual
    }
    
}
let workoutNames = ["Bench Press","Squat","Deadlift","OverHead Press","Pull-Up","Barbell Row"]

#Preview {
    //NavBar()
    //ProgressView()
    //WorkoutProgressList()
    LineChartView(workout:"Default",welcomeView: true)
}


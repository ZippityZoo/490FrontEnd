//
//  ProgressView.swift
//  SpartanFit
//
//  Created by Collin Harris on 10/10/24.
//

import SwiftUI
import Charts

struct ProgressView: View {
    @EnvironmentObject var workoutHistoryData:WorkoutHistoryData
    
    //@State var setofexercises: Set<String> = []
    @State var workout: String = "Default"
    @State var setData = DBSets.setsTest2
    @State var welcomeView: Bool = false
    @State var isrecent:Bool = true
    let colorMapping: [String: Color] = [
        "Set1": Color("Set1"),
        "Set2": Color("Set2"),
        "Set3": Color("Set3"),
        "Set4": Color("Set4"),
        "Set5": Color("Set5"),
        "Set6": Color("Set1")
    ]
    
    var body: some View {
        //temp
        //NavigationView{
            WorkoutProgressList
        //}
    }
    var WorkoutProgressList: some View{
            ZStack{
                Color("Cream")
                VStack{
                    Text("Progress").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold()
                    List{
                        //not correct need less
                        
                        ForEach(countuniqeIds().sorted(),id: \.self){workoutname in
                                
                                HStack{
                                    NavigationLink(destination: BarChartSubView(exname: workoutname).environmentObject(sampleWorkoutHistory)){
                                        Text("\(workoutname)")
                                    }.foregroundStyle(Color.white)
                                        .onAppear{
                                            self.workout = workoutname
                                        }
                                }
                        }.listRowBackground(Color("DarkBlue"))
                    }.scrollContentBackground(.hidden)
                }.background(Color("Cream"))
            }
            
        }
    var NavBar: some View{
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
        //
    func countuniqeIds() -> Set<String>{
            if let performance = workoutHistoryData.performance{
               let setofexercises =  Set(performance.map { $0.exerciseName })
                return setofexercises
            }
        return []
        }

    var BarChartView:some View {
        
        ZStack{
            Color("Cream").ignoresSafeArea()
            VStack{
                if(welcomeView){
                    EmptyView()
                }else{
                    EmptyView()
                    NavBar
                }
                VStack{
                    Text(workout).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold().foregroundStyle(.white)
                    var setcount = 1
                    if let performance = workoutHistoryData.performance{
                    
                    Chart(performance){day in
                        let date = convertStringtoDate(datestr: day.dateCompleted)
                        BarMark(
                            x:.value("X",date.formatted(date:.numeric,time:.omitted)),
                            y:.value("Y", day.repPerf)
                        )
                        .foregroundStyle(by:.value("Set",String(setcount)))
                        .annotation(position:.overlay){Text("\(String(format:"%.1f",day.weightPerf))").font(.caption.bold())}
                            let _ = setcount += 1
                                if (day.setPerf < setcount){
                                    let _ = setcount = 1
                                }
                    }.chartForegroundStyleScale(["1": Color("Set1"), "2": Color("Set2"), "3": Color("Set3"), "4": Color("Set4"),"5": Color("Set5"),"6": Color("Set6")])
                     }
                     /*
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
                     */
                    /*HStack(spacing: 10) {
                        ForEach(["Set1", "Set2", "Set3", "Set4", "Set5", "Set6"], id: \.self) { setName in
                            HStack(spacing: 5) {
                                Circle()
                                    .fill(Color(setName))
                                    .frame(width: 10, height: 10)
                                Text(setName)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.top, 10)
                     */
                }
                .padding()
                .background(Color("DarkBlue"))
                .cornerRadius(10)
            }
        }
        
    }
    func convertStringtoDate(datestr:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'mm'-'dd' 'HH':'mm':'ss'"
        if let date = dateFormatter.date(from: datestr){
            return date
        }
        return Date.now
    }
}
struct BarChartSubView: View {
    //make this a specific exercise id
    @EnvironmentObject var workoutHistoryData:WorkoutHistoryData
    var exname:String
    //@State var randi:Int
    //var setCount:[Int] = []
    @State var lastDate:Date = Date.now
    @State var earliestDate:Date = Date.now
    @State var workout:String = "Default"
    @State var welcomeView:Bool = false
    var body: some View{
    ZStack{
        Color("Cream").ignoresSafeArea()
        VStack{
            if(welcomeView){
                EmptyView()
            }else{
                EmptyView()
                //NavBar(setData:$setData)
            }
            VStack{
                Text(exname).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold().foregroundStyle(.white)
                    
                    if let performance = workoutHistoryData.performance{
                        let ld = getLastDate(thisWorkout: performance)
                        let thisWorkout = copy(performance:performance,id:exname)
                        var setcount = 1
                        Chart(thisWorkout){day in
                            let date = convertStringtoDate(datestr: day.dateCompleted)
                            //let _  =  print(date)
                            BarMark(
                                //x:.value("X",date.formatted(date:.numeric,time:.omitted)),
                                x:.value("Date",date),
                                y:.value("Reps (units)", day.repPerf)
                            )
                            .foregroundStyle(by:.value("Set",String(setcount)))
                            .annotation(position:.overlay){
                                Text("\(String(format:"%.1f",day.weightPerf))").font(.caption.bold())
                                    .layoutPriority(1)
                            }
                            
                            let _ = setcount += 1
                            if (day.setPerf < setcount){
                                let _ = setcount = 1
                            }
                            
                        }.chartForegroundStyleScale(["1": Color("Set1"), "2": Color("Set2"), "3": Color("Set3"), "4": Color("Set4"),"5": Color("Set5"),"6": Color("Set6")])
                        
                            .chartXScale(
                                domain: earliestDate...lastDate,
                                range: .plotDimension(startPadding: 10, endPadding: 10)
                            )
                         
                         
                        //let _ = print("\(weekAgo)")
                        
                        
                    
                }
                /*
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
                 */
                /*HStack(spacing: 10) {
                 ForEach(["Set1", "Set2", "Set3", "Set4", "Set5", "Set6"], id: \.self) { setName in
                 HStack(spacing: 5) {
                 Circle()
                 .fill(Color(setName))
                 .frame(width: 10, height: 10)
                 Text(setName)
                 .font(.caption)
                 .foregroundColor(.white)
                 }
                 }
                 }
                 .padding(.top, 10)
                 */
            }
            .padding()
            .background(Color("DarkBlue"))
            .cornerRadius(10)
        }
        }
    }
    func convertStringtoDate(datestr:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'mm'-'dd' 'HH':'mm':'ss'"
        if let date = dateFormatter.date(from: datestr){
            return date
        }
        return Date.now
    }
    func copyOnlyRel(){
        //uhhh
    }
    func copy(performance:[WorkoutHistory],id:String)->[WorkoutHistory]{
        var thisWorkout:[WorkoutHistory] = []
        for  day in performance {
            if(id == day.exerciseName){
                thisWorkout.append(day)
            }
        }
        return thisWorkout
    }
    func setArray(thisWorkout:[WorkoutHistory])-> [Int]{
        var setCount:[Int] = []
        var n:Int = 1
        for day in thisWorkout{
            if(n > day.setPerf){
               n = 1
            }
            setCount.append(n)
            n += 1
        }
        return setCount
    }
    func getLastDate(thisWorkout:[WorkoutHistory]){
        var date:Date = Date.now
        if let datecompleted = thisWorkout.last{
            date = convertStringtoDate(datestr: datecompleted.dateCompleted)
        }
        lastDate = date
        /*
        if let datecompleted2 = thisWorkout.first{
            date = convertStringtoDate(datestr: datecompleted2.dateCompleted)
        }
         */
        earliestDate = date.addingTimeInterval(86400 * -7)
    }
    
}
//TODO: connect to db
//Will Have a list of workouts for the user to select


//Stuff to simulate DB info
enum SetNum: String {
    case SetOne = "Set1"
    case SetTwo = "Set2"
    case SetThree = "Set3"
    case SetFour = "Set4"
    case SetFive = "Set5"
    case SetSix = "Set6"
}
func convert(setNum:Int) ->SetNum{
    switch(setNum){
        case 1:
            return SetNum.SetOne
        case 2:
            return SetNum.SetTwo
        case 3:
            return SetNum.SetThree
        case 4:
            return SetNum.SetFour
        case 5:
            return SetNum.SetFive
        case 6:
            return SetNum.SetSix
        default:
            return SetNum.SetSix
    }
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
    ProgressView().environmentObject(sampleWorkoutHistory)
    //WorkoutProgressList
    //workout this later
    //BarChartSubView(exname:"Bench Press").environmentObject(sampleWorkoutHistory)
    //EmptyView()
}


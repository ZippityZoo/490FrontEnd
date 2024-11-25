//
//  ProgressView.swift
//  SpartanFit
//
//  Created by Collin Harris on 10/10/24.
//

import SwiftUI
import Charts
import UIKit


struct ProgressView: View {
    @EnvironmentObject var workoutHistoryData:WorkoutHistoryData
    
    //@State var setofexercises: Set<String> = []
    @State var workout: String = "Default"
    //@State var setData = DBSets.setsTest2
    @State var selected:Bool = false
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
        NavigationView{
            WorkoutProgressList
            
        }
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
                                    NavigationLink(destination: BarChartSubView(exname: workoutname)
                                        .environmentObject(workoutHistoryData)
                                        //.forceRotation(orientation: UIInterfaceOrientationMask.landscapeLeft)
                                    ){
                                        ZStack{
                                            Text("\(workoutname)")
                                        }
                                            
                                    }.foregroundStyle(Color.white)
                                        .onAppear{
                                            self.workout = workoutname
                                            print("appear")
                                            
                                        }
                                        .onDisappear{
                                            print("dissappear")
                                            
                                        }
                                }
                        }.listRowBackground(Color("DarkBlue"))
                    }.scrollContentBackground(.hidden)
                }.background(Color("Cream"))
            }
            
        }
        //
    func countuniqeIds() -> Set<String>{
            if let performance = workoutHistoryData.performance{
               let setofexercises =  Set(performance.map { $0.exerciseName })
                return setofexercises
            }
        return []
        }
/*
    var BarChartView:some View {
        
        ZStack{
            Color("Cream").ignoresSafeArea()
            VStack{
                if(welcomeView){
                    EmptyView()
                }else{
                    EmptyView()
                    //NavBar
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
*/
    func convertStringtoDate(datestr:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'mm'-'dd' 'HH':'mm':'ss'"
        if let date = dateFormatter.date(from: datestr){
            return date
        }
        return Date.now
    }
}
//Load all data separated by month and week
struct BarChartSubView: View {
    @EnvironmentObject var workoutHistoryData:WorkoutHistoryData
    //var bymonth :[ReducedHistory:Date] = [:]//the date value will be the first of the month of that year to better separate
    //var byweek:[[ReducedHistory]:Date] = [[]:]
    var exname:String
    @State var isPortrait:Bool = UIDevice.current.orientation.isPortrait
    @State var width:MarkDimension = 45
    @State private var isLandscape = UIDevice.current.orientation.isLandscape
    @State var isrecent:Bool = true
    @State var month:Date = Date.now
    @State var start:Date = Date.now
    @State var end:Date = Date.now
    //@State var workout:String = "Default"
    @State var welcomeView:Bool = false
    var body: some View{
        ZStack{
                Color("Cream").ignoresSafeArea()
                VStack{
                    if(welcomeView){
                        EmptyView()
                    }else{
                        EmptyView()
                        NavBar
                    }
                    GeometryReader { geometry in
                        //CurrentChart
                        TESTCHART
                            .gesture(
                                DragGesture()
                                    .onEnded { value in
                                        let threshold = geometry.size.width / 4
                                        if value.translation.width < -threshold {
                                            //if is recent go back 7 days
                                            print("go forward")
                                            if(isrecent){
                                                start = start.addingTimeInterval(86400 * 7)
                                                end  = end.addingTimeInterval(86400 * 7)
                                                
                                            }else{
                                                //print("go forward")
                                                //print(start)
                                                //print(end)
                                                getNextMonth()
                                            }
                                        } else if value.translation.width > threshold{
                                            print("go back")
                                            if(isrecent){
                                                start = start.addingTimeInterval(86400 * -7)
                                                end  = end.addingTimeInterval(86400 * -7)
                                                
                                            }else{//go back a month
                                                //print("go forward")
                                                getLastMonth()
                                            }
                                        }
                                        /*
                                         if value.translation.width < -threshold && currentIndex < colors.count - 1 {
                                         currentIndex += 1
                                         } else if value.translation.width > threshold && currentIndex > 0 {
                                         currentIndex -= 1
                                         }
                                         */
                                    }
                            )
                    }
                }.onAppear{
                    UIDevice.forceRotation(to: UIInterfaceOrientation.landscapeLeft)
                /*
                 NotificationCenter.default.addObserver(
                 forName: UIDevice.orientationDidChangeNotification,
                 object: nil,
                 queue: .main
                 ) { _ in
                 self.isLandscape = UIDevice.current.orientation.isLandscape
                 }
                 */
                }
                .onDisappear{
                    UIDevice.forceRotation(to: UIInterfaceOrientation.portrait)
                }
        }
    }
    var TESTCHART:some View{
        VStack{
            Text(exname).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold().foregroundStyle(Color("Cream"))
            if let performance = workoutHistoryData.performance{
                if performance.count > 0 {
                    let rp = reducePerfomance(perfomance: performance)
                    let crp = copy(performance:rp,id: exname)
                    //let thisWorkout = copy(performance:performance,id:exname)
                    if crp.count > 0 {
                    }
                    var setcount = 1
                    Chart(){
                        ForEach(crp){day in
                            //let date = convertStringtoDate(datestr: day.dateCompleted)
                            //let _ = print(day)
                            BarMark(
                                
                                x:.value("Date",day.dateCompleted),
                                y:.value("Reps (units)", day.repPerf),width: width
                                
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
                        }
                    }.chartForegroundStyleScale(["1": Color("Set1"), "2": Color("Set2"), "3": Color("Set3"), "4": Color("Set4"),"5": Color("Set5"),"6": Color("Set6")])
                        .foregroundStyle(.white)
                        
                        .chartXScale(
                            domain: start...end,
                            range: .plotDimension(startPadding: 20, endPadding: 20)
                            
                        )
                        .chartXAxis {
                            AxisMarks(preset: .aligned,values:.stride(by:.day)){
                                AxisValueLabel().foregroundStyle(Color("Cream")).font(.caption)  // Adjust font and color
                                    .offset()
                                
                            }
                        }
                        .chartYAxis {
                            AxisMarks {
                                AxisValueLabel().foregroundStyle(Color("Cream")).font(.caption)  // Adjust font and color
                            }
                        }
                        .onAppear{
                            //let _ = print(start)
                            //let _ = print(end)
                            end = getLastDayOfSpecificMonth(date: start)
                            UIDevice.forceRotation(to: .landscapeLeft)
                        }
                        .onDisappear{
                            UIDevice.forceRotation(to: .portrait)
                        }
                }
                
            }
            
        }
        .padding()
        .background(Color("DarkBlue"))
        .cornerRadius(10)
    }
    var NavBar: some View{
            ZStack{
                Color("Cream")
                HStack{
                    Spacer()
                    Button(action:recent){
                        Text("Past 7 Days")
                    }
                    Spacer()
                    Divider()
                    Spacer()
                    Button(action:overall){
                        Text("This Month")
                    }
                    Spacer()
                }
            }.frame(height:40)
                .clipShape(RoundedRectangle(cornerRadius: 10)).padding(4).background(.black).clipShape(RoundedRectangle(cornerRadius: 10))
        }
        func recent(){
            if(!isrecent){
                isrecent = true
                width = 45
                end = Date.now
                start = end.addingTimeInterval(86400 * -7)
                print(isrecent)
            }
        }
        func overall(){
            if(isrecent){
                isrecent = false
                width = 45
                start = Date.now
                start = getFirstDayOfSpecificMonth(date: start)
                //print(start)
                end = getLastDayOfSpecificMonth(date: start)
                print(isrecent)
            }
        }
        func retRecentOrOverall(thisWorkout:[ReducedHistory]) -> Date{
            let date:Date = getLatestDate(thisWorkout: thisWorkout)
            if(isrecent){
                self.start = date.addingTimeInterval(86400 * -7)
                return date.addingTimeInterval(86400 * -7)
            }
            //date = getEarliestDate(thisWorkout: thisWorkout)
            self.start = getFirstDayOfSpecificMonth(date: date)
            return getFirstDayOfSpecificMonth(date: date)
            //return date
            
        }
    func convertStringtoDate(datestr:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss'"
        if let date = dateFormatter.date(from: datestr){
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let datereduced = dateFormatter.string(from: date)
            
            if let finalDate = dateFormatter.date(from: datereduced){
                //print(finalDate)
                return finalDate
            }
        }
        return Date.now
    }
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Desired format
        return dateFormatter.string(from: date)
    }
    func convertDateAtoWHA(month:[Date],workout:String) -> [ReducedHistory]{
        var out:[ReducedHistory] = []
        var id = -1
        for date in month {
            //let d = formatDate(date: date)
            let dummy = ReducedHistory(id: 0, exerciseName: workout, setPerf: 0, repPerf: 0, weightPerf: 0, dateCompleted: date)
            out.append(dummy)
            id -= 1
        }
        //print(out)
        return out
    }
    //temp perfomance is all good
    func fillin(thisWorkout:[ReducedHistory],start:Date) -> [ReducedHistory]{
        //get all dates convert these dates to the same data type
        var dummys:[ReducedHistory] = []
        let month = getWholeMonth(date: start)
        if let first = thisWorkout.first{
            dummys = convertDateAtoWHA(month: month, workout: first.exerciseName)
        }
        let this = reduceWorkout(this: thisWorkout, startdate: month.first!, enddate: month.last!)
        //print(this)
        return mergeSort(dummys: dummys, this: this)
        
        //print(final)
        //now combine them
        //for each date
        //insert date after
        //merge sort
    }
    
    func copy(performance:[ReducedHistory],id:String)->[ReducedHistory]{
        var thisWorkout:[ReducedHistory] = []
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
            //let _  = print(setCount)
            setCount.append(n)
            n += 1
        }
        return setCount
    }
    func getLatestDate(thisWorkout:[ReducedHistory]) -> Date{
        var date:Date = Date.now
        if let datecompleted = thisWorkout.last{
            date = datecompleted.dateCompleted
            //date = convertStringtoDate(datestr: datecompleted.dateCompleted)
            //let _ = print("Latest Date \(date)")
        }
        return date
        
    }
    func getEarliestDate(thisWorkout:[WorkoutHistory]) -> Date{
        var date:Date = Date.now
        if let datecompleted = thisWorkout.first{
            date = convertStringtoDate(datestr: datecompleted.dateCompleted)
            //let _ = print("Earliest Date \(date)")
        }
        return date
    }
    //trendline stuff
    func trendline(thisWorkout:[ReducedHistory]) -> [Point]{
        var progressIndex:[Point] = []
        let q1 = q1(thisWorkout: thisWorkout)
        let q3 = q3(thisWorkout: thisWorkout)
        for workout in thisWorkout{
            let progin = ((workout.weightPerf - q1) * Double(workout.repPerf)) + q3
            //let date = convertStringtoDate(datestr: workout.dateCompleted)
            print(progin)
            progressIndex.append(.init(date:workout.dateCompleted, val:progin/10))
        }
        //print(progressIndex)
        return progressIndex
    }
    func q1(thisWorkout:[ReducedHistory]) -> Double{
        let  n = thisWorkout.count/4
        return thisWorkout[n+1].weightPerf
    }
    func q3(thisWorkout:[ReducedHistory]) -> Double{
        let  n = (thisWorkout.count/4) * 3
        return thisWorkout[n+1].weightPerf
    }
    //temp
    func getMonthlys(thisWorkout:[WorkoutHistory]){
        let c = setArray(thisWorkout: thisWorkout)
        var n:Int = 0
        for day in thisWorkout {
            print(day)
            print(c[n])
            n += 1
        }
    }
    func getFirstDayOfSpecificMonth(date:Date) -> Date{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year,.month], from: date)
        if let firstDays = calendar.date(from: components){
            return firstDays
        }
        return date
    }
    func getLastDayOfSpecificMonth(date:Date) -> Date {
        let calendar = Calendar.current
        if let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: date){
            let firstOfNextMonth = getFirstDayOfSpecificMonth(date:startOfNextMonth)
            
            if let lastDays = calendar.date(byAdding: .day, value: -1, to: firstOfNextMonth){
                //print(lastDays)
                return lastDays
            }
        }
        
        return date
    }
    func getWholeMonth(date:Date) -> [Date]{
        var allDates:[Date] = []
        let calendar = Calendar.current
        let start = getFirstDayOfSpecificMonth(date: date)
        let end = getLastDayOfSpecificMonth(date: date)
        var inc = start
        var n = 0
        while(inc < end){
            allDates.append(inc)
            if let inc2 = calendar.date(byAdding: .day, value: 1, to: inc){
                inc = inc2
            }
        }
        return allDates
    }
    func mergeSort(dummys:[ReducedHistory],this:[ReducedHistory])->[ReducedHistory]{
        var i = 0
        var j = 0
        var mergedArray: [ReducedHistory] = []
            
            // Merge elements from both arrays
            while i < dummys.count && j < this.count {
                if dummys[i] < this[j] {
                    mergedArray.append(dummys[i])
                    i += 1
                } else {
                    mergedArray.append(this[j])
                    j += 1
                }
            }
            
            // Append remaining elements from array1 (if any)
            while i < dummys.count {
                mergedArray.append(dummys[i])
                i += 1
            }
            
            // Append remaining elements from array2 (if any)
            while j < this.count {
                mergedArray.append(this[j])
                j += 1
            }
            //print(mergedArray)
            return mergedArray
    }
    //reduce workout by month by giving start date and end date
    func reduceWorkout(this:[ReducedHistory],startdate:Date,enddate:Date)->[ReducedHistory]{
        var reduced:[ReducedHistory] = []
        
        for workout in this{
            let wd = workout.dateCompleted
            if wd >= startdate && wd <= enddate{
                reduced.append(workout)
            }
        }
        //print(reduced)
        return reduced
        //print(reduced)
    }
    func getNextMonth(starts: inout Date,ends: inout Date){
        let calendar = Calendar.current
        if let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: end){
            start = startOfNextMonth
            starts = startOfNextMonth
        }
        ends = getLastDayOfSpecificMonth(date: starts)
    }
    func getNextMonth(){
        let calendar = Calendar.current
        if let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: start){
            start = startOfNextMonth
        }
        end  = getLastDayOfSpecificMonth(date: start)
        //print(start)
        //print(end)
    }
    func getLastMonth(starts: inout Date,ends: inout Date){
        let calendar = Calendar.current
        if let endOflastMonth = calendar.date(byAdding: .month, value: -1, to: end){
            ends = endOflastMonth
            end = endOflastMonth
        }
        starts = getFirstDayOfSpecificMonth(date: ends)
    }
    func getLastMonth(){
        let calendar = Calendar.current
        if let endOflastMonth = calendar.date(byAdding: .month, value: -1, to: end){
            end = endOflastMonth
        }
        start = getFirstDayOfSpecificMonth(date: end)
    }
    
}
extension View {
    @ViewBuilder
    func forceRotation(orientation: UIInterfaceOrientationMask) -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.onAppear() {
                AppDelegate.orientationLock = orientation
            }
            // Reset orientation to previous setting
            let currentOrientation = AppDelegate.orientationLock
            self.onDisappear() {
                AppDelegate.orientationLock = currentOrientation
            }
        } else {
            self
        }
    }
}
class AppDelegate: NSObject, UIApplicationDelegate {

    static var orientationLock = UIInterfaceOrientationMask.portrait {
        didSet {
            if #available(iOS 16.0, *) {
                UIApplication.shared.connectedScenes.forEach { scene in
                    if let windowScene = scene as? UIWindowScene {
                        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientationLock))
                    }
                }
                UIViewController.attemptRotationToDeviceOrientation()
            } else {
                if orientationLock == .landscape {
                    UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                } else {
                    UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
extension UIDevice {
    static func forceRotation(to orientation: UIInterfaceOrientation) {
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        //UIViewController.attemptRotationToDeviceOrientation()
    }
}


struct ReducedHistory:Identifiable,Hashable{
    var id: Int
    var exerciseName: String
    var setPerf:Int
    var repPerf:Int
    var weightPerf:Double
    var dateCompleted:Date
    
    init(id:Int, exerciseName:String, setPerf:Int, repPerf:Int, weightPerf:Double, dateCompleted:Date){
        self.id = id
        self.exerciseName = exerciseName
        self.setPerf = setPerf
        self.repPerf = repPerf
        self.weightPerf = weightPerf
        self.dateCompleted = Date.now
    }
    
    init(history:WorkoutHistory){
        self.id = history.id
        self.exerciseName = history.exerciseName
        self.setPerf = history.setPerf
        self.repPerf = history.repPerf
        self.weightPerf = history.weightPerf
        self.dateCompleted = Date.now
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss'"
        if let date = dateFormatter.date(from: history.dateCompleted){
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let datereduced = dateFormatter.string(from: date)
            
            if let finalDate = dateFormatter.date(from: datereduced){
                //print(finalDate)
                self.dateCompleted = finalDate
            }
        }
    }
    /*
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
    }
     */
    static func <(lhs:ReducedHistory,rhs:ReducedHistory) -> Bool{
        return lhs.dateCompleted < rhs.dateCompleted
    }
    static func  ==(lhs:ReducedHistory,rhs:ReducedHistory)-> Bool{
        return lhs.id == rhs.id
    }
}
func reducePerfomance(perfomance:[WorkoutHistory]) -> [ReducedHistory]{
    var reducedPerf:[ReducedHistory] = []
    for workout in perfomance{
        let red = ReducedHistory(history:workout)
        reducedPerf.append(red)
    }
    return reducedPerf
}

let emptyHistory = WorkoutHistory(userId: 0, firstName: "", lastName: "", id: -1, exerciseName:"" , setPerf: 0, repPerf: 0, weightPerf: 0.0, dateCompleted: "")

struct Point: Identifiable{
    var id = UUID()
    var date:Date
    var val:Double
}
//TODO: connect to db
//Will Have a list of workouts for the user to select

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY)) // Top point
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)) // Bottom left point
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // Bottom right point
        path.closeSubpath() // Closes the path to form a triangle
        return path
    }
}
/*
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        return .landscapeLeft // Set the desired orientation
    }
}
 */

class CustomViewController: UIViewController {
    var selected:Bool = false
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if selected {
            return .landscapeLeft
        } else {
            return [.landscapeLeft, .landscapeRight, .portrait]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Trigger an update if conditions change
        self.setNeedsUpdateOfSupportedInterfaceOrientations()
    }
}

//Stuff to simulate DB info
enum SetNum: String {
    case SetOne = "Set1"
    case SetTwo = "Set2"
    case SetThree = "Set3"
    case SetFour = "Set4"
    case SetFive = "Set5"
    case SetSix = "Set6"
}

/*
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
*/
#Preview {
    //NavBar()
    ProgressView().environmentObject(sampleWorkoutHistory)

    //WorkoutProgressList
    //workout this later
    //BarChartSubView(exname:"Bench Press").environmentObject(sampleWorkoutHistory)
    //EmptyView()
}



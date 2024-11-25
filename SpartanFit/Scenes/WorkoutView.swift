////
////  WorkoutView.swift
////  SpartanFit
////
////  Created by Collin Harris on 10/10/24.
////
//
import SwiftUI
import Charts
import Foundation

struct Test: View {
    @EnvironmentObject var workoutHistoryData:WorkoutHistoryData
    var exname:String
    @State var width:MarkDimension = 45
    @State private var isPortrait = UIDevice.current.orientation.isPortrait
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
            }
            
        }.onAppear{
            
            /*NotificationCenter.default.addObserver(
             forName: UIDevice.orientationDidChangeNotification,
             object: nil,
             queue: .main
             ) { _ in
             self.isPortrait = UIDevice.current.orientation.isPortrait
             }
             */
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
                    }
                }
            }
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
            isrecent = true
            width = 45
            print(isrecent)
        }
        func overall(){
            isrecent = false
            width = 45
            print(isrecent)
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
}
#Preview{
    Test(exname:"Bench").environmentObject(sampleWorkoutHistory)
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



//
//  WelcomeView.swift
//  SpartanFit
//
//  Created by Collin Harris on 10/10/24.
//

import SwiftUI

struct WelcomeView: View {
    @State var fromLogin:Bool//will hide the back button if we navigated here from the login or signup views
    @State var date:Date = .now
    @State var scrollIndex:Int = 0
    var workoutSubView = WorkoutPlanBody(workoutPlan: sampleWorkoutPlan)
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    var body: some View {
        NavigationView{
            ZStack{
                Color("Gold").ignoresSafeArea()
                VStack{
                    Text("Welcome to SpartanFit").font(.largeTitle).fontWeight(.heavy).padding(.bottom,5)
                    Divider().padding(5).background(in:RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                    Text(date,style: .date).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Text(date,style: .time)
                    Spacer()
                    //Progress View
                    ZStack{
                        Color("DarkBlue")
                    }.clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)).padding(5)
                    //Workout View
                    ZStack{
                        Color("DarkBlue")
                        //TODO: find out if  possible to auto scroll preview
                        ScrollViewReader{ proxy in
                            ScrollView{
                                NavigationLink(destination: WorkoutPlanView(workoutPlan: sampleWorkoutPlan)){
                                    workoutSubView.disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/).scaledToFit()
                                }
                                /*
                                workoutSubView.onReceive(timer) { _ in
                                    withAnimation {
                                        if scrollIndex < workoutSubView.workoutPlan.sessions.count - 1{
                                            scrollIndex += 1
                                        }
                                        else {
                                            scrollIndex = 0
                                        }
                                        proxy.scrollTo(scrollIndex,anchor: .bottom)
                                        print("do something")
                                    }
                                    */
                                //WorkoutPlanView(workoutPlan: sampleWorkoutPlan).disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                //workoutSubView.scaledToFit()
                                //proxy.scrollTo(workoutSubView.topId)
                                
                                //}
                            }
                        }.scaledToFit()
                        
                    }.clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)).padding(5)
                }
            }
        }.navigationBarBackButtonHidden(fromLogin)
    }
}
/*
 NavigationLink(destination: { WelcomeView(fromLogin: true)} ,label:{
     Text("Login").frame(alignment: .bottomTrailing).padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)).background().clipShape(RoundedRectangle(cornerRadius: 15.0)).bold().padding(EdgeInsets(top: 15, leading: 5, bottom: 5, trailing: 10))
 })
 */

#Preview {
    WelcomeView(fromLogin: false)
}

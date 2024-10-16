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
    var body: some View {
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
                }.clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)).padding(5)
            }.navigationBarBackButtonHidden(fromLogin)
        }
    }
}


#Preview {
    WelcomeView(fromLogin: false)
}

//
//  ContentView.swift
//  SpartanFit
//
//  Created by Collin Harris on 10/7/24.
//

import SwiftUI

struct LoginView: View {
    @State private var showingWorkoutScreen = false
    @State private var showingSignUpScree = false
    @State private var path = NavigationPath()
        @State var email = ""
        @State var password = ""
     var user: User
    var body: some View {
        NavigationView{
            ZStack{
                Color("cream").ignoresSafeArea()
                
                VStack{
                    Text(" SPARTANFIT").font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/).fontWeight(.heavy).foregroundColor(Color("DarkBlue"))
                    ZStack{
                        Color("DarkBlue")//.frame(width:393,height:200,alignment: .center)
                        VStack{
                            
                            HStack{
                                
                                Spacer()
                                TextField("Enter Email",text: $email).textFieldStyle(RoundedBorderTextFieldStyle()).background().clipShape(RoundedRectangle(cornerRadius: 5.0)).padding(.bottom,20)
                                Spacer()
                            }
                            HStack{
                                Spacer()
                                SecureField("Enter Password",text: $password).textFieldStyle(RoundedBorderTextFieldStyle()).background().clipShape(RoundedRectangle(cornerRadius: 5.0))
                                Spacer()
                            }
                            HStack{
                                Spacer()
                                NavigationLink(destination: { WelcomeView(fromLogin: true, user: user)} ,label:{
                                    Text("Login").frame(alignment: .bottomTrailing).padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)).background().clipShape(RoundedRectangle(cornerRadius: 15.0)).bold().padding(EdgeInsets(top: 15, leading: 5, bottom: 5, trailing: 10)).foregroundColor(Color("DarkBlue"))
                                })
                                /*
                                 Button("Login") {
                                 authenticateUser(email: email, password: password)
                                 
                                 }.frame(alignment: .bottomTrailing).padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)).background().clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)).bold().padding(.trailing, 5)
                                 */
                            }
                            
                            
                            
                            
                            
                        }
                        
                    }.padding(.vertical,200).clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                }
            }
        }
          
    }
    func authenticateUser(email: String,password:String){
        if(email.lowercased() == ""){
            if(password == ""){
                print("valid password")
                showingWorkoutScreen = true
            }else{
                print("invalid password")
            }
        }else{
            print("invalid email")
        }
        
    }
}


#Preview {
    LoginView(user: sampleUser)
}


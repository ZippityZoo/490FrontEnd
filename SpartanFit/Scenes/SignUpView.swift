//
//  SignUpView.swift
//  SpartanFit
//
//  Created by Collin Harris on 10/10/24.
//

import SwiftUI

struct SignUpView: View {
    @State var email:String = ""
    @State var username:String = ""
    @State var password:String = ""
    @State var passwordCheck: String = ""
    @State var match: Bool = false
    var body: some View {
        //remove this
        NavigationView{
            ZStack{
                Color("Foreground").ignoresSafeArea()
                VStack{
                    Text(" SPARTANFIT").font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/).fontWeight(.heavy).foregroundColor(Color("Background"))
                    ZStack{
                        Color("Background").frame(width:390,height:400,alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                        VStack{
                            Text(" Sign Up").font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/).fontWeight(.heavy).foregroundColor(.white)
                            HStack{
                                
                                Spacer()
                                TextField("Enter Email",text: $email).textFieldStyle(RoundedBorderTextFieldStyle()).background().clipShape(RoundedRectangle(cornerRadius: 5.0)).padding(.bottom,20)
                                Spacer()
                            }
                            HStack{
                                Spacer()
                                TextField("Username",text: $username).textFieldStyle(RoundedBorderTextFieldStyle()).background().clipShape(RoundedRectangle(cornerRadius: 5.0)).padding(.bottom,20)
                                Spacer()
                            }
                            HStack{
                                Spacer()
                                SecureField("Enter Password",text: $password).textFieldStyle(RoundedBorderTextFieldStyle()).background().clipShape(RoundedRectangle(cornerRadius: 5.0)).padding(.bottom,20)
                                Spacer()
                            }
                            
                            HStack{
                                Spacer()
                                SecureField("Re-Enter Password",text: $passwordCheck).textFieldStyle(RoundedBorderTextFieldStyle()).background().clipShape(RoundedRectangle(cornerRadius: 5.0)).padding(.bottom,20)
                                Spacer()
                            }
                            if(!password.isEmpty || !passwordCheck.isEmpty){
                                comparePasswords(password: password, passwordCheck: passwordCheck, match: $match)
                                let _ = print(match)
                                
                            }
                            HStack{
                                Spacer()
                                ZStack{
                                    NavigationLink (destination:{ SignUpView2()
                                    }, label: {
                                        Text("Next").foregroundStyle(.black).bold()
                                    })
                                    .padding(5)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                    .padding(.trailing,10)
                                    Color("\((!email.isEmpty && !username.isEmpty ) && (!password.isEmpty && !passwordCheck.isEmpty)&&(password == passwordCheck) ? "":"Background")").scaledToFit()
                                }
                            }
                        }
                    }.padding(.vertical,165).clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                }
            }
        }
        
    }
    
}

func comparePasswords(password: String,passwordCheck: String,match:Binding<Bool>)->some View{
    while(true){
        if(password == passwordCheck){
            match.wrappedValue = true
            return Text("Valid").foregroundStyle(.green)
        }else{
            match.wrappedValue = false
            return Text("Password must match").foregroundStyle(.red)
        }
    }
}


struct SignUpView2: View{
    var body: some View{
        ZStack{
            Color("Foreground").ignoresSafeArea()
            Text("HI")
        }
    }
}


#Preview {
    SignUpView()
}

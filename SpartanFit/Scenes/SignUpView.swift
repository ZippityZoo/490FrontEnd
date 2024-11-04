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
                Color("Cream").ignoresSafeArea()
                VStack{
                    Text(" SPARTANFIT").font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/).fontWeight(.heavy).foregroundColor(Color("DarkBlue"))
                    ZStack{
                        Color("DarkBlue").frame(width:390,height:400,alignment: .center)
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
                                    Color("\((!email.isEmpty && !username.isEmpty ) && (!password.isEmpty && !passwordCheck.isEmpty)&&(password == passwordCheck) ? "":"DarkBlue")").scaledToFit()
                                }
                            }
                        }
                    }.padding(.vertical,165).clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                }
            }
        }
        
    }
    
}
//Also add password checking
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

//Goal Choices
struct SignUpView2: View{
    @State var goalSelection:String = "Strength"
    let choices:[String] = ["Strength","Hypertrophy","Endurance","General Fitness","Weight Loss"]
    var body: some View{
        //temp
        
        ZStack{
            Color("Cream").ignoresSafeArea()
            VStack{
                Text("Select A Goal").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold()
                Divider().padding().foregroundStyle(Color("DarkBlue"))
                ZStack{
                    VStack{
                        Picker("Select an option", selection: $goalSelection) {
                            ForEach(choices, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .foregroundStyle(.black)
                        .background(Color.gray.opacity(0.2))
                        
                        .cornerRadius(8)
                        HStack{
                            Spacer()
                            NavigationLink (destination:{ SignUpView3()
                            }, label: {
                                Text("Next").foregroundStyle(.black).bold()
                            })
                            .padding(5)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            .padding(.trailing,10)
                        }
                    }
                    
                }
            }
        }
        
    }
}

struct SignUpView3: View{
    var body: some View{
        ZStack{
            Color("Cream")
            Text("Add Injury")
        }
    }
}



struct InjuryForm: View{
    @State var muscleSelection:String = ""
    @State var muscleIndex:Int = 0
    @State var intensitySelection:String = ""
    @State var pos:String = ""
    var body: some View{
        ZStack{
            VStack{
                HStack{
                    Text("Muscle:").foregroundStyle(.white).bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Picker("Select an option", selection: $muscleSelection) {
                        ForEach(muscles, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .foregroundStyle(.black)
                    .background(Color.gray.opacity(0.2))
                }
                HStack{
                    Text("Position:").foregroundStyle(.white).bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Picker("Select an option", selection: $pos) {
                        ForEach(mposition, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .foregroundStyle(.black)
                    .background(Color.gray.opacity(0.2))
                }
                HStack{
                    Text("Injury Intensity:").foregroundStyle(.white).bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Picker("Select an option", selection: $intensitySelection) {
                        ForEach(intensity, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .foregroundStyle(.black)
                    .background(Color.gray.opacity(0.2))
                    
                }
                HStack{
                    Spacer()
                    //on submit return a view of the injury
                    Button(
                        action:{
                            print("submit")
                        },label: {
                            Text("Submit")
                        }
                    )
                }.padding()
            }
        }
        .padding(20)
        .background(Color("DarkBlue"))
    }
}
#Preview {
    //SignUpView3()
    InjuryForm()
}

let muscles: [String] = [
    // Head and Neck Muscles
    "Frontalis",
    "Temporalis",
    "Orbicularis Oculi",
    "Zygomaticus Major",
    "Orbicularis Oris",
    "Sternocleidomastoid",
    
    // Shoulder and Arm Muscles
    "Deltoid",
    "Biceps Brachii",
    "Triceps Brachii",
    "Brachialis",
    "Coracobrachialis",
    
    // Chest Muscles
    "Pectoralis Major",
    "Pectoralis Minor",
    
    // Back Muscles
    "Trapezius",
    "Latissimus Dorsi",
    "Rhomboid Major",
    "Rhomboid Minor",
    "Erector Spinae",
    
    // Abdomen Muscles
    "Rectus Abdominis",
    "External Oblique",
    "Internal Oblique",
    "Transverse Abdominis",
    
    // Hip and Thigh Muscles
    "Iliopsoas",
    "Quadriceps Femoris",
    "Hamstrings",
    "Gluteus Maximus",
    "Gluteus Medius",
    "Gluteus Minimus",
    
    // Leg Muscles
    "Gastrocnemius",
    "Soleus",
    "Tibialis Anterior",
    
    // Foot Muscles
    "Flexor Hallucis Longus",
    "Extensor Digitorum Longus",
    
    // Additional Muscles
    "Sartorius",
    "Adductor Longus",
    "Adductor Magnus",
    "Pectineus",
    "Gracilis"
]
let intensity = [
    "Low",
    "Moderate",
    "Severe"
]
let mposition = [
    "Left",
    "Right"
]

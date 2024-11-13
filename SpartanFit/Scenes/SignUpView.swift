//
//  SignUpView.swift
//  SpartanFit
//
//  Created by Collin Harris on 10/10/24.
//

import SwiftUI

//TODO: Insert Into DB
struct SignUpView: View {
    @EnvironmentObject var newUser:UserData//integrate this 
    @State var fname:String = ""
    @State var lname:String = ""
    @State var email:String = ""
    @State var username:String = ""
    @State var password:String = ""
    @State var passwordCheck: String = ""
    @State var match: Bool = false
    var body: some View {
            ZStack{
                Color("Cream").ignoresSafeArea()
                VStack{
                    Text(" SPARTANFIT").font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/).fontWeight(.heavy).foregroundColor(Color("DarkBlue"))
                    ZStack{
                        Color("DarkBlue").frame(width:390,height:435,alignment: .center)
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
                                TextField("First Name",text: $fname).textFieldStyle(RoundedBorderTextFieldStyle()).background().clipShape(RoundedRectangle(cornerRadius: 5.0)).padding(.bottom,20)
                                TextField("Last Name",text: $lname).textFieldStyle(RoundedBorderTextFieldStyle()).background().clipShape(RoundedRectangle(cornerRadius: 5.0)).padding(.bottom,20)
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
                                    .padding(10)
                                    
                                    Color("\(ifAllAreTrue() ? "":"DarkBlue")")
                                        .padding(5)
                                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                }
                            }
                        }
                    }.padding(.vertical,145).clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                }
            }
        }
    func inputIntoUser(){
        newUser.user?.fname = fname
    }
    func ifAllAreTrue() -> Bool{
        if(!email.isEmpty && !username.isEmpty){
            if(!username.isEmpty && !password.isEmpty){
                if(!fname.isEmpty && !lname.isEmpty){
                    if(password == passwordCheck){
                        return true
                    }
                }
            }
        }
        return false
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
    @State var showForm:Bool = false
    @State var shown:Int = 0
    @State var listedInjuries:[String] = []
    @State var muscleImages:[String] = [
        "Biceps Brachii-Left",
        "Biceps Brachii-Right",
        "Brachioradialis-Left",
        "Brachioradialis-Right",
        "Extensor Carpi Ulnaris-Left",
        "Extensor Carpi Ulnaris-Right",
        "Front Deltoid-Left",
        "Front Deltoid-Right",
        "Gastrocnemius-Left",
        "Gastrocnemius-Right",
        "Gluteus Maximus-Left",
        "Gluteus Maximus-Right",
        "Hamstrings-Left",
        "Hamstrings-Right",
        "Latissimus Dorsi-Left",
        "Latissimus Dorsi-Right",
        "Pectoralis Major-Left",
        "Pectoralis Major-Right",
        "Quadriceps Femoris-Left",
        "Quadriceps Femoris-Right",
        "Rear Deltoid-Left",
        "Rear Deltoid-Right",
        "Rectus Abdominis",
        "Tibialis Anterior-Left",
        "Tibialis Anterior-Right",
        "Trapezius-Left",
        "Trapezius-Right",
        "Triceps Brachii-Left",
        "Triceps Brachii-Right"
    ]
    var body: some View{
        ZStack{
            Color("Cream").ignoresSafeArea()
            VStack{
                let _ = displayMuscle()
                Text("Injuries").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold().padding(.top,10)
                if(shown <= 0){
                    Text("Please submit you injuries below")
                    Text("Click on Injury to remove it")
                }
                Divider()
                ForEach(listedInjuries.indices,id:\.self){injury in
                    Button(action: {
                        listedInjuries.remove(at: injury)
                    }, label: {
                        Text(listedInjuries[injury])
                            .padding(5)
                            .background(Color("DarkBlue"))
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            .foregroundStyle(.white)
                    })
                    
                }
                if(!showForm){
                    Button (action:{
                        showForm.toggle()
                        shown += 1
                    },label:{
                        Text("Add Injury")
                    })
                }
                else{
                    InjuryForm(listedInjuries:$listedInjuries,showForm: $showForm)
                        .scaledToFit()
                        //.animation(.easeInOut)
                       
                }
                Spacer()
                Divider()
                HStack{
                    Spacer()
                    NavigationLink (destination:{ WelcomeView()
                    }, label: {
                        Text("Finish").foregroundStyle(.black).bold()
                    })
                    .padding(5)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    .padding(.trailing,10)
                }
                Spacer()
                ZStack{
                    Image("0BASE").resizable(capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0), resizingMode: .stretch).cornerRadius(10).aspectRatio(contentMode:.fit)
                        .onHover(perform: { hovering in
                            let _ = print("on body")
                        }).onTapGesture(perform:{_ in
                            print("hi")
                        }
                        )
                    ForEach(muscleImages,id:\.self){ name in
                        Image(name).resizable(capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0), resizingMode: .stretch).cornerRadius(10).aspectRatio(contentMode:.fit)
                            .onTapGesture(perform:{_ in
                                print(name)
                            })
                    }
                   
                }
            }
        }
    }
    func displayMuscle(){
        for listedInjury in listedInjuries {
            if let filename = listedInjury.firstIndex(of: "("){
                print(filename)
            }
        }
    }
}



struct InjuryForm: View{
    @Binding var listedInjuries:[String]
    @Binding var showForm:Bool
    @State var muscleSelection:String = "Front Deltoid"
    @State var muscleIndex:Int = 0
    @State var intensitySelection:String = "Low"
    @State var pos:String = "Left"
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
                            listedInjuries.append("\(muscleSelection + "-" + pos + " (" +  intensitySelection))")
                            showForm.toggle()
                        },label: {
                            Text("Submit")
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        }
                    )
                }.padding()
            }
        }
        .padding(20)
        .background(Color("DarkBlue"))
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
    }
}
#Preview {
    SignUpView3()
    //InjuryForm()
}

let muscles: [String] = [
    // Shoulder and Arm Muscles
    "Front Deltoid",//front shoulder and back?
    "Rear Deltoid",
    "Biceps Brachii",
    "Triceps Brachii",
    "Brachioradialis",//forearm
    "Extensor Carpi Ulnaris",//back of forearm
    // Chest Muscles
    "Pectoralis Major",//pec
    // Back Muscles
    "Trapezius",
    "Latissimus Dorsi",
    // Abdomen Muscles
    "Rectus Abdominis",
    // Hip and Thigh Muscles
    "Quadriceps Femoris",
    "Hamstrings",
    "Gluteus Maximus",
    // Leg Muscles
    "Gastrocnemius",//calf
    "Tibialis Anterior"//shin area
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


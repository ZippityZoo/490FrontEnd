//
//  SignUpView.swift
//  SpartanFit
//
//  Created by Collin Harris on 10/10/24.
//

import SwiftUI

//TODO: Insert Into DB
struct SignUpViewMain: View {
    @State var newUser:UserData = UserData()//integrate this
    @State var fname:String = ""
    @State var lname:String = ""
    @State var email:String = ""
    @State var username:String = ""
    @State var password:String = ""
    @State var passwordCheck: String = ""
    @State var match: Bool = false
    @State var goalSelection:String = choices[0]
    @State var experinceSelection:String = experince[0]
    @State var showForm:Bool = false
    @State var shown:Int = 0
    @State var listedInjuries:[String] = []
    @State var intensity:[String] = []
    @State var muscleSelection:String = muscles[0]//"Front Deltoid"
    @State var muscleIndex:Int = 0
    @State var intensitySelection:String = intensityc[0]//"Low"
    @State var pos:String = mposition[0] //"Left"
    @State var showConfirmation:Bool = false
    @State var showConfetti:Bool = false
    @State var isPresented:Bool = false
    var body: some View{
            SignUpView
    }
    var SignUpView: some View {
        //NavigationView{
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
                                    NavigationLink (destination:{ SignUpView2
                                    }, label: {
                                        Text("Next").foregroundStyle(.black).bold()
                                    })
                                    .padding(5)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                    .padding(10)
                                    
                                    Color("\(ifAllAreTrue() ? "Clear":"DarkBlue")")
                                        .padding(5)
                                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                }
                            }
                        }
                    }.padding(.vertical,145).clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
                        .onDisappear{
                            var user = newUser.user
                            user?.fname = fname
                            user?.lname = lname
                            user?.email = email
                            user?.exp_level = ""
                            user?.fit_goal = ""
                        }
                }
            }
        //}
    }
    var SignUpView2: some View{
            //needs
            ZStack{
                Color("Cream").ignoresSafeArea()
                VStack{
                    selectExperince
                    selectGoal
                }
            }
    }
    var selectGoal: some View{
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
                        NavigationLink (destination:{ SelectInjuries
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
    var selectExperince: some View{
        VStack{
            Text("Select Experince Level").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold()
            Divider().padding().foregroundStyle(Color("DarkBlue"))
            ZStack{
                VStack{
                    Picker("Select an option", selection: $experinceSelection) {
                        ForEach(experince, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .foregroundStyle(.black)
                    .background(Color.gray.opacity(0.2))
                    
                    .cornerRadius(8)
                }
            }
        }
    }
    var SelectInjuries: some View{
        NavigationView{
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
                        InjuryForm
                            .scaledToFit()
                            .animation(.easeInOut, value: 2)
                        
                    }
                    Spacer()
                    Divider()
                    HStack{
                        Spacer()
                        Button(action:{
                            initNewUser()
                            createUser()
                        },label: {
                            Text("Submit").foregroundStyle(.black).bold()
                        })
                        .padding(5)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .padding(.trailing,10)
                        
                        NavigationLink (destination:{
                            WelcomeView().environmentObject(newUser)
                            
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
                        ForEach(listedInjuries,id:\.self){ name in
                            Image(name).resizable(capInsets: EdgeInsets(top: 0.0, leading: 0.0, bottom: 0.0, trailing: 0.0), resizingMode: .stretch).cornerRadius(10).aspectRatio(contentMode:.fit)
                                .onTapGesture(perform:{_ in
                                    print(name)
                                })
                        }
                        
                    }
                }
            }
        }
    }
    var InjuryForm:  some View{
            ZStack{
                VStack(alignment: .leading){
                    HStack{
                        Text("Muscle:").foregroundStyle(.white).bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        Spacer()
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
                        Spacer()
                        Picker("Select an option", selection: $pos) {
                            ForEach(mposition, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .foregroundStyle(.black)
                        .background(Color.gray.opacity(0.2))
                        .scaledToFill()
                        
                    }
                    HStack{
                        Text("Injury Intensity:")
                            .foregroundStyle(.white).bold().font(.title)
                        Spacer()
                        Picker("Select an option", selection: $intensitySelection) {
                            ForEach(intensityc, id: \.self) { option in
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
                                listedInjuries.append("\(muscleSelection + "-" + pos )")//+ " (" +  intensitySelection))"
                                intensity.append("\(intensitySelection))")
                                showForm.toggle()
                                imgparser(muscle: muscleSelection, position: intensitySelection)
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
    func displayMuscle(){
        for listedInjury in listedInjuries {
            if let filename = listedInjury.firstIndex(of: "("){
                print(filename)
            }
        }
    }
    func imgparser(muscle:String, position:String){
        let img = muscle + "-" + position
        print(img)
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
    
    func initNewUser(){
        let randomInt = Int.random(in: Int.min...Int.max)//pray
        let date = Date.now.formatted()
        newUser.user = User(id: randomInt, fname: fname, lname: lname, username: username, password: password, email: email, fit_goal: goalSelection, exp_level: experinceSelection, created_at: date)
        
    }
    private func createUser() {
        guard
            let user = newUser.user,
            let email = newUser.user?.email
        else { return }

        // Convert intensity to estimated calories burned
        
        let userData: [String: Any] = [
            "user_id": user.id,
            "fname": user.fname,
            "lname": user.lname,
            "username": user.username,
            "password": user.password,
            "email": user.email,
            "fit_goal": user.fit_goal,
            "exp_level": user.exp_level,
            "created_at": user.created_at
        ]

        let urlString = "\(apiBaseUrl)/users/create"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: userData)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error submitting feedback:", error)
                    return
                }

                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        showConfirmation = true
                        showConfetti = true
                        
                        // Refresh workoutPlan
                        if let user = newUser.user {
                            UserData(user: user)
                        }
                        
                        // Automatically dismiss confirmation and feedback view
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showConfirmation = false
                                showConfetti = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                isPresented = false
                            }
                        }
                    }
                } else {
                    print("Failed to submit feedback")
                }
            }.resume()
        } catch {
            print("Failed to encode feedback data:", error)
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


#Preview {
    SignUpViewMain()
    //SignUpView2
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
let intensityc = [
    "Low",
    "Moderate",
    "Severe"
]
let mposition = [
    "Left",
    "Right"
]
let choices:[String] = ["Strength","Hypertrophy","Endurance","General Fitness","Weight Loss"]

let experince:[String] = ["Beginner","Intermediate","Advanced"]

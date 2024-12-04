import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var userData: UserData
    @State private var isEditingProfile = false
    @State private var isEditingInjury = false
    @State var injuries:[Injury] = []
    @State var listedInjuries:[String] = []
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            Color("Cream").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                HStack {
                    Button(action: {
                        // Logout action: navigate back to LoginView
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Logout")
                            .bold()
                            .padding(10)
                            .background(Color("DarkBlue"))
                            .foregroundColor(Color("Cream"))
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    Button(action: {
                        isEditingProfile.toggle()
                    }) {
                        Text("Edit Profile")
                            .bold()
                            .padding(10)
                            .background(Color("DarkBlue"))
                            .foregroundColor(Color("Cream"))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                if let user = userData.user {
                    VStack(alignment: .leading, spacing: 10) {
                        userInfoRow(label: "First Name", value: user.fname)
                        userInfoRow(label: "Last Name", value: user.lname)
                        userInfoRow(label: "Username", value: user.username)
                        //userInfoRow(label: "Password", value: "••••••••")
                        userInfoRow(label: "Email", value: user.email)
                        userInfoRow(label: "Fitness Goal", value: user.fit_goal)
                        userInfoRow(label: "Experience Level", value: user.exp_level)
                        userInfoRow(label: "Member Since", value: dateFormatter(user.created_at))
                    }
                    .padding()
                    .background(Color("DarkBlue"))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                HStack{
                    Spacer()
                    
                }
                if let user = userData.user {
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Injury Information")
                                .font(.headline)
                                .foregroundColor(Color("Cream"))
                            
                            Spacer()
                            
                            Button(action: {
                                isEditingInjury.toggle()
                            }) {
                                Text("Edit Injuries")
                                    .bold()
                                    .padding(10)
                                    .background(Color("Cream").opacity(0.1))
                                    .foregroundColor(Color("Cream"))
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(userData.injuries, id: \.self) { injury in
                                VStack(alignment: .leading, spacing: 8) {
                                    userInfoRow(label: "Muscle Name", value: injury.muscle)
                                    userInfoRow(label: "Muscle Position", value: injury.position)
                                    userInfoRow(label: "Injury Intensity", value: injury.intensity)
                                }
                                .background(Color("DarkBlue"))
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding()
                    .background(Color("DarkBlue"))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                
            }
            
            NavigationLink(destination: UserPreferencesView()) {
                Text("View Preferences")
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("DarkBlue"))
                    .foregroundColor(Color("Cream"))
                    .cornerRadius(10)
            }
            .padding(.horizontal, -10)
            
            Spacer()
        }
        .navigationTitle("User Profile")
        .sheet(isPresented: $isEditingProfile) {
            EditProfileView(isPresented: $isEditingProfile)
                .environmentObject(userData)
        }
        .sheet(isPresented: $isEditingInjury) {
            SelectInjuries(isPresented: $isEditingInjury,
                           injuries: $userData.injuries,
                           listedInjuries: .constant([]))
        }
        .environmentObject(userData)
    }
}

func userInfoRow(label: String, value: String) -> some View {
    HStack {
        Text(label + ":")
            .fontWeight(.bold)
            .foregroundColor(Color("Cream"))
        Spacer()
        Text(value)
            .foregroundColor(Color("Cream"))
    }
    .padding(8)
    .background(Color.gray.opacity(0.15))
    .cornerRadius(10)
}

func dateFormatter(_ dateString: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if let date = formatter.date(from: dateString) {
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    return dateString
}

struct SelectInjuries: View {
    
    @State var shown:Int = 0
    @State var showForm:Bool = false
    @State var muscleSelection:String = muscles[0]
    @State var pos:String = mposition[0]
    @State var intensitySelection:String = intensityc[0]
    @State var intensity:[String] = []
    @Binding var isPresented:Bool
    @Binding var injuries:[Injury]
    @Binding var listedInjuries:[String]
    var body: some View{
        NavigationView{
            ZStack{
                Color("Cream").ignoresSafeArea()
                VStack{
                    let _ = displayMuscle()
                    Text("Injuries").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold().padding(.top,10)
                    if(shown <= 0){
                        Text("Please submit your injuries below")
                        Text("Click on an injury to remove it")
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
                        Button (action:{
                            isPresented.toggle()
                            
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
                    Text("Muscle:").foregroundStyle(.white).bold().font(.subheadline)
                    Spacer()
                    Picker("Select an option", selection: $muscleSelection) {
                        ForEach(muscles, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(-1)
                    .foregroundStyle(.black)
                    .background(Color.gray.opacity(0.2))
                }
                HStack{
                    Text("Position:").foregroundStyle(.white).bold().font(.subheadline)
                    Spacer()
                    Picker("Select an option", selection: $pos) {
                        ForEach(mposition, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(-1)
                    .foregroundStyle(.black)
                    .background(Color.gray.opacity(0.2))
                    .scaledToFill()
                    
                }
                HStack{
                    Text("Injury Intensity:")
                        .foregroundStyle(.white).bold().font(.subheadline)
                    Spacer()
                    Picker("Select an option", selection: $intensitySelection) {
                        ForEach(intensityc, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(-1)
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
                            createInjury()
                            //imgparser(muscle: muscleSelection, position: intensitySelection)
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
    func createInjury(){
        injuries.append(Injury(muscle: muscleSelection, position: pos, intensity: intensitySelection))
    }
}
struct Injury: Hashable{
    var muscle:String
    var position:String
    var intensity:String
    
}

#Preview {
    UserProfileView()
        .environmentObject(UserData(user: sampleUser))
}


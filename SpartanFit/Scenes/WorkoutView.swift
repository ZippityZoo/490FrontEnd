////
////  WorkoutView.swift
////  SpartanFit
////
////  Created by Collin Harris on 10/10/24.
////
//
import SwiftUI
//
//struct WorkoutView: View {
//    var body: some View {
//        Text("Workout View")
//        Exercise_Page(setCount: 3)
//    }
//}
//struct Exercise_Page:View {
//    @State var setCount: Int
//    let setViews = [SetView]()
//    let threeSets = [
//        SetView(),
//        SetView(),
//        SetView()
//    ]
//    var id = UUID()
//    //var setview :Int
//    var body: some View{
//        ZStack{
//            Color(red:0.5,green:0.5,blue:0.5)
//            VStack{
//                Spacer()
//                HStack{
//                        //SetView()
//                    ForEach(threeSets, id:\.id) { view in
//                        view
//                    }
//                    
//                    }
//                }
//                Spacer()
//                HStack{
//                    ForEach(setViews, id: \.id){view in
//                        view
//                    }
//                }
//            }
//        }
//    /*
//    init(setCount: Int) {
//        self.setCount = setCount
//    }
//     */
//}
//
//
//
//
////so each set view has to
////UUID
////
//struct SetView:View {
//    var id = UUID()
//    //@Published var data = [SetData]()
//    @State private var weight = 120
//    @State private var reps = 0
//    @State private var goal = 10
//    @State private var sets = 0
//    var body: some View {
//        ZStack{
//            Color(red:0.5,green:0.5,blue:0.5)
//            HStack{
//                VStack{
//                    Text(String(weight))
//                    Divider()
//                    Text(String(reps))
//                    Text(String(goal))
//                }.padding(10).background().clipShape(RoundedRectangle(cornerRadius: 15.0))
//            }
//        }
//        
//    }
//}
//
//struct SetData: Identifiable {
//    var id = UUID()
//    var text = String()
//}
//
//#Preview {
//    WorkoutView()
//}
import SwiftUI

struct AutoScrollView: View {
    // Sample data
    let items = Array(1...100).map { "Item \($0)" }
    
    // State to track the scroll position
    @State private var scrollToIndex: Int = 0
    
    // Timer to control the auto-scroll
    let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack {
                    ForEach(items.indices, id: \.self) { index in
                        Text(items[index])
                            .font(.headline)
                            .padding()
                            .background(Color.blue.opacity(0.3))
                            .cornerRadius(8)
                            .id(index) // Assign an id for scrolling
                    }
                }
                .onReceive(timer) { _ in
                    withAnimation {
                        if scrollToIndex < items.count - 1 {
                            scrollToIndex += 1
                        } else {
                            scrollToIndex = 0 // Reset to top if at the end
                        }
                        proxy.scrollTo(scrollToIndex, anchor: .bottom) // Scroll to the new index
                    }
                }
            }
            .padding()
        }
    }
}

struct AutoScrollView_Previews: PreviewProvider {
    static var previews: some View {
        AutoScrollView()
    }
}


#Preview {
    AutoScrollView()
}

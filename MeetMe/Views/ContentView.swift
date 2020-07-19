//
//  ContentView.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/12/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var networkAgent: NetworkAgent
    @Binding var auth: String
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var me: Attributes?

    @State private var selected = 1
    var body: some View {
        VStack {
            if self.selected == 0 {
                Spacer()
                Text("Hi, asshole!")
                Spacer()
            }else if self.selected == 1 && me != nil{
                Profile(me: $me)
            }else if self.selected == 2{
                Spacer()
                Button(action: {
                    self.me = nil
                    if let appDomain = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: appDomain)
                    }
                    networkAgent.logOut()
                    self.auth = "main"
                }){
                    HStack {
                        Text("Sign Out")
                    }
                    .foregroundColor(Color(.label))
                    .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                    .background(Color("textViewColor"))
                    .clipShape(Capsule())
                }
                Spacer()
            }else {
                Spacer()
                Text("Loading...")
                Spacer()
            }
            me != nil ? SegmentedControlView(selected: self.$selected).padding(1) : nil
        }.onAppear{if self.me == nil {self.updateProfile()};print("here")}
    }
    
    func updateProfile(){
        if let udMe = UserDefaults.standard.object(forKey: "me") as? Data {
            let decoder = JSONDecoder()
            if let profile = try? decoder.decode(Attributes.self, from: udMe) {
                self.me = profile
            }
        } else if networkAgent.myProfile.count != 0{
            me = networkAgent.myProfile[0]
        } else {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                self.updateProfile()
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    @State static var auth: String = "yo"
//    @ObservedObject static var networkAgent = NetworkAgent()
//    static var previews: some View {
//        ContentView(networkAgent: networkAgent, auth: $auth)
//    }
//}

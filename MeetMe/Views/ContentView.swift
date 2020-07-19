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
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var me: Attributes?

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
                    if let appDomain = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: appDomain)
                    }
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
            SegmentedControlView(selected: self.$selected)
                .padding(1)
        }.onAppear{self.updateProfile()}
    }
    
    func updateProfile(){
        if let udMe = UserDefaults.standard.object(forKey: "me") as? Data {
            let decoder = JSONDecoder()
            if let profile = try? decoder.decode(Attributes.self, from: udMe) {
                self.me = profile
            }
//            me = Attributes(id: ud.integer(forKey: "my_id"), full_name: ud.string(forKey: "my_full_name")!, email: ud.string(forKey: "my_email")!, phone_number: ud.string(forKey: "my_phone_number")!, location: ud.string(forKey: "my_location")!, linkedin_link: ud.string(forKey: "my_linkedin_link")!, twitter_link: ud.string(forKey: "my_twitter_link")!, facebook_link: ud.string(forKey: "my_facebook_link")!, portfolio_link: ud.string(forKey: "my_portfolio_link")!, bio: ud.string(forKey: "my_bio")!, picture: ud.string(forKey: "my_picture")!)
        } else if networkAgent.myProfile.count != 0{
            me = networkAgent.myProfile[0]
        } else {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
                self.updateProfile()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @ObservedObject static var networkAgent = NetworkAgent()
    static var previews: some View {
        ContentView(networkAgent: networkAgent)
    }
}

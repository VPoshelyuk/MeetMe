//
//  ContentView.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/12/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI
import URLImage

enum UpdateType: Hashable, Identifiable {
   case picture, basic, links, about
    
    var id: Int {
        return self.hashValue
    }
}

struct ContentView: View {
    @ObservedObject var networkAgent: NetworkAgent
    @Binding var auth: String
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var me: Attributes?
    
    @State private var updateType: UpdateType? = nil
    @State private var presentingUpdateView = false
    @State var picToUpdate: UIImage?

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
                HStack{
                    URLImage(URL(string: me!.picture)!, placeholder: {
                        ProgressView($0) { progress in
                            ZStack {
                                if progress > 0.0 {
                                    // The download has started. CircleProgressView displays the progress.
                                    CircleProgressView(progress).stroke(lineWidth: 8.0)
                                }
                                else {
                                    // The download has not yet started. CircleActivityView is animated activity indicator that suits this case.
                                    CircleActivityView().stroke(lineWidth: 20.0)
                                }
                            }
                        }
                            .frame(width: 120, height: 120)
                    },content:  {
                        $0.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    }).padding(.trailing, 10)
                    VStack {
                        Text(me!.full_name)
                            .font(.custom("Ubuntu-Bold", size: 28))
                        Text(me!.email)
                    }.padding(.leading, 10)
                }
                .frame(width: UIScreen.main.bounds.width - 50, height: 130)
                .background(Color(.tertiaryLabel))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color("textViewColor"), lineWidth: 1.5))
                .padding(.bottom)
                Button(action: {
                    self.presentingUpdateView = true
                    self.updateType = .picture
                }){
                    Text("Edit Picture")
                    .foregroundColor(Color(.label))
                    .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                    .clipShape(Capsule())
                    .overlay(Capsule().strokeBorder(Color("textViewColor"), lineWidth: 1.5))
                }.padding(.bottom)
                Button(action: {
                    print("yo")
                }){
                    Text("Edit Basic Inforamtion")
                    .foregroundColor(Color(.label))
                    .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                    .clipShape(Capsule())
                    .overlay(Capsule().strokeBorder(Color("textViewColor"), lineWidth: 1.5))
                }.padding(.bottom)
                Button(action: {
                    print("yo")
                }){
                    Text("Edit Links")
                    .foregroundColor(Color(.label))
                    .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                    .clipShape(Capsule())
                    .overlay(Capsule().strokeBorder(Color("textViewColor"), lineWidth: 1.5))
                }.padding(.bottom)
                Button(action: {
                    print("yo")
                }){
                    Text("Edit About")
                    .foregroundColor(Color(.label))
                    .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                    .clipShape(Capsule())
                    .overlay(Capsule().strokeBorder(Color("textViewColor"), lineWidth: 1.5))
                }.padding(.bottom)
                Spacer()
                Button(action: {
                    self.me = nil
                    if let appDomain = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: appDomain)
                    }
                    self.networkAgent.logOut()
                    self.auth = "main"
                }){
                    Text("Sign Out")
                    .foregroundColor(Color(.label))
                    .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                    .background(Color("textViewColor"))
                    .clipShape(Capsule())
                }
            }else {
                Spacer()
                Text("Loading...")
                Spacer()
            }
            me != nil ? SegmentedControlView(selected: self.$selected).padding(1) : nil
        }.onAppear{self.updateProfile()}
//        .sheet(item: $updateType) { item in
//            if item == .picture {
//                let data = try? Data(contentsOf: URL(string: me!.picture)!)
//                picToUpdate = UIImage(data: data!)
//            }
//        }
    }
    
    func updateProfile(){
        if let udMe = UserDefaults.standard.object(forKey: "me") as? Data {
            let decoder = JSONDecoder()
            if let profile = try? decoder.decode(Attributes.self, from: udMe) {
                self.me = profile
            }
        } else {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                self.updateProfile()
            }
        }
    }
}

//struct UpdateView: View {
//    @Binding var presentingUpdateView: Bool
//    @Binding var URL: String
//    var body: some View {
//        VStack {
//        }
//    }
//}

//struct ContentView_Previews: PreviewProvider {
//    @State static var auth: String = "yo"
//    @ObservedObject static var networkAgent = NetworkAgent()
//    static var previews: some View {
//        ContentView(networkAgent: networkAgent, auth: $auth)
//    }
//}

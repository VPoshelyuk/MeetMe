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
    @State var basicInfo: [String]?
    @State var linksInfo: [String]?

    @State private var selected = 1
    var body: some View {
        VStack {
            if self.selected == 0 {
                if #available(iOS 14.0, *) {
                    GridView()
                } else {
                    Text("iOS 14 is not available")
                    // Fallback on earlier versions
                }
            }else if self.selected == 1 && me != nil{
                Profile(me: $me)
            }else if self.selected == 2 && me != nil{
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
                    self.presentingUpdateView = true
                    self.updateType = .basic
                }){
                    Text("Edit Basic Inforamtion")
                    .foregroundColor(Color(.label))
                    .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                    .clipShape(Capsule())
                    .overlay(Capsule().strokeBorder(Color("textViewColor"), lineWidth: 1.5))
                }.padding(.bottom)
                Button(action: {
                    self.presentingUpdateView = true
                    self.updateType = .links
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
                    if let appDomain = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: appDomain)
                    }
                    self.auth = "main"
                    self.me = nil
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
        .sheet(item: $updateType) { item in
            if item == .picture {
                PicturePage(pickedImage: Binding($picToUpdate)!, currentPage: nil, auth: nil, presentingUpdateView: $presentingUpdateView)
            } else if item == .basic  {
                SignUpPage(pageName: "Edit Basic Info", tfArray: Binding($basicInfo)!, placeholders: ["Full Name", "Location", "E-Mail", "Phone #"], currentPage: nil, auth: nil, value: nil, presentingUpdateView: $presentingUpdateView)
//                ["LinkedIn", "Twitter", "Facebook", "GitHub", "Portfolio"]
            }
        }
    }
    
    func updateProfile(){
        if let udMe = UserDefaults.standard.object(forKey: "me") as? Data {
            let decoder = JSONDecoder()
            if let profile = try? decoder.decode(Attributes.self, from: udMe) {
                self.me = profile
                let data = try? Data(contentsOf: URL(string: profile.picture)!)
                picToUpdate = UIImage(data: data!)
                basicInfo = [profile.full_name, profile.location, profile.email, profile.phone_number]
                linksInfo = [profile.linkedin_link, profile.twitter_link, profile.facebook_link, profile.github_link, profile.portfolio_link]
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

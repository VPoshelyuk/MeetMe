//
//  MainView.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/14/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var networkAgent = NetworkAgent()
    
    @State var auth = ""
    @State var me: Attributes?
    
    
    var body: some View {
        VStack {
            if UserDefaults.standard.object(forKey: "me") != nil && auth == ""{
                ContentView(networkAgent: networkAgent, auth: $auth, me: $me)
            } else {
                if auth == "logIn" {
                    LogInView(networkAgent: networkAgent, auth: $auth).transition(.slide).animation(.easeInOut(duration: 0.3))
                } else if auth == "signUp" {
                    SignUpView(networkAgent: networkAgent, auth: $auth, me: $me).transition(.slide).animation(.easeInOut(duration: 0.3))
                } else {
                    Group {
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .transition(AnyTransition.slide.animation(.easeInOut(duration: 100.0)))
                        Button(action: {
                            self.auth = "signUp"
                        }){
                            Text("SIGN UP")
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                                .background(Color("textViewColor"))
                                .clipShape(Capsule())
                        }.padding()
                        Button(action: {
                            self.auth = "logIn"
                        }){
                            Text("LOG IN")
                                .foregroundColor(.white)
                                .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                                .background(Color("textViewColor"))
                                .clipShape(Capsule())
                        }.padding()
                    }
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

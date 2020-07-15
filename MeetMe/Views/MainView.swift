//
//  MainView.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/14/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var signedIn: Bool = UserDefaults.standard.bool(forKey: "signedIn")
    @State var auth = ""
    var body: some View {
        VStack {
            if signedIn {
               ContentView()
            } else {
                if auth == "logIn" {
                    LogInView(auth: $auth)
                } else if auth == "signUp" {
                    SignUpView(auth: $auth).transition(.opacity).id("My" + auth) //doesn't work
                } else {
                    Group {
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width - 50)
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
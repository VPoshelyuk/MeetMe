//
//  LogInView.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/14/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI

struct LogInView: View {
    
    @ObservedObject var networkAgent: NetworkAgent
    @Binding var auth: String
    
    @State var email = ""
    @State var password = ""
    @State var success = false
    @State var value: CGFloat = 0

    var body: some View {
        VStack {
            if success {
                ContentView(networkAgent: networkAgent, auth: $auth)
            } else {
                HStack {
                    Text("Back")
                        .onTapGesture { self.auth = "" }
                    Spacer()
                }
                HStack{
                    Text("Hi there! Let's log you in:")
                        .font(.custom("Ubuntu-Bold", size: 34))
                    Spacer()
                }.padding(.top, 50).padding(.bottom, 50)
                self.value == 0 ? Spacer() : nil
                GlowingTextField(placeholder: "E-Mail", tField: $email)
                GlowingTextField(placeholder: "Password", tField: $password)
                Spacer()
                Button(action: {
                    self.networkAgent.logIn(email: self.email, password: self.password)
                }){
                    HStack {
                        Text("Log me in")
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                    .background(Color("textViewColor"))
                    .clipShape(Capsule())
                }
                .padding(.bottom)
                self.value != 0 ? Spacer(minLength: self.value) : nil
            }
        }.padding(.horizontal)
            .animation(.easeInOut(duration: 0.16))
            .onAppear{
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main){ notification in
                    let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    self.value = value.height
                }

                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){ notification in
                    self.value = 0
                }
            }
    }
    
    func successfulLogIn() {
        if UserDefaults.standard.object(forKey: "me") != nil {
            self.success = true
        } else {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                self.successfulLogIn()
            }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    @ObservedObject static var networkAgent = NetworkAgent()
    @State static var auth: String = "yo"
    static var previews: some View {
        LogInView(networkAgent: networkAgent, auth: $auth)
    }
}

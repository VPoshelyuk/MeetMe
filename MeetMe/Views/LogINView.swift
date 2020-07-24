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
    @State var showProgressView = false

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Back")
                        .onTapGesture { self.auth = "main" }
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
                    self.showProgressView = true
                    self.networkAgent.logIn(email: self.email, password: self.password)
                    self.successfulLogIn()
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
            }.padding(.horizontal)
                .onAppear{
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main){ notification in
                        let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                        self.value = value.height
                    }

                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){ notification in
                        self.value = 0
                    }
                }
            if #available(iOS 14.0, *) {
                self.showProgressView ? ProgressView().zIndex(100) : nil
            }
        }.animation(.easeInOut(duration: 0.16))
    }
    
    func successfulLogIn() {
        if UserDefaults.standard.object(forKey: "me") != nil {
            self.auth = ""
        } else {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
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

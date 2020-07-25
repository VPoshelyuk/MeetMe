//
//  SignUpView.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/12/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    
    @State var about = ""
    @State var currentPage = 1
    @State var pickedImage = UIImage()
    
    
    @State private var firstPageFields = ["test@gda.com", "123456qwerty"]
    let firstPagePlaceholders = ["E-Mail", "Password"]
    
    @State private var secondPageFields = ["Slava P", "9293098458", "New York"]
    let secondPagePlaceholders = ["Full Name", "Phone #", "Location"]
    
    @State private var thirdPageFields = ["https://www.linkedin.com/in/", "https://twitter.com/", "https://www.facebook.com/", "https://www.github.com/", "https://www.google.com/"]
    let thirdPagePlaceholders = ["LinkedIn", "Twitter", "Facebook", "GitHub", "Portfolio"]
    
    @State private var editing = false
    @State var value: CGFloat = 0
    
    @State var showProgressView = false
    
    @ObservedObject var networkAgent: NetworkAgent
    @Binding var auth: String
    @Binding var me: Attributes?
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                    if currentPage == 1 {
                            SignUpPage(pageName: "1. E-Mail and Password", tfArray: $firstPageFields, placeholders: firstPagePlaceholders, currentPage: $currentPage, auth: $auth, value: $value)
                        } else if currentPage == 2 {
                            SignUpPage(pageName: "2. Full Name, Phone Number and Location", tfArray: $secondPageFields, placeholders: secondPagePlaceholders, currentPage: $currentPage, auth: $auth, value: $value)
                        } else if currentPage == 3 {
                            SignUpPage(pageName: "3. Social Media Links", tfArray: $thirdPageFields, placeholders: thirdPagePlaceholders, currentPage: $currentPage, auth: $auth, value: $value)
                        } else if currentPage == 4 {
                            PicturePage(pickedImage: $pickedImage, currentPage: $currentPage, auth: $auth, presentingUpdateView: nil)
                        } else if currentPage == 5 {
                            AboutPage(currentPage: $currentPage, about: $about, auth: $auth, value: $value, showProgressView: $showProgressView, me: $me, firstPageFields: $firstPageFields, secondPageFields: $secondPageFields, thirdPageFields: $thirdPageFields, pickedImage: $pickedImage, networkAgent: networkAgent)
                        }
                    }.padding(.horizontal)
                    .padding(.bottom, self.value)
                    .offset(y: -self.value)
                    .onAppear{
                        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main){ notification in
                            let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                            self.value = value.height/2
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
    
    func updateProfile(){
        if let udMe = UserDefaults.standard.object(forKey: "me") as? Data {
            let decoder = JSONDecoder()
            if let profile = try? decoder.decode(Attributes.self, from: udMe) {
                self.me = profile
                self.auth = ""
            }
        } else {
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
                self.updateProfile()
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

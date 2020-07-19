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
    
//    var drag: some Gesture {
//        DragGesture(minimumDistance: 300)
//            .onChanged({gesture in
//                if gesture.startLocation.x < CGFloat(100.0){
//                    if self.currentPage == 1 {
//                        self.auth = ""
//                        print("auth", self.currentPage)
//                    }else {
//                        self.currentPage -= 1
//                        print("current", self.currentPage)
//                    }
//                }
//             }
//        )
//    }
    
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
                            VStack {
                                HStack {
                                    Text("Back")
                                        .onTapGesture {
                                            if self.currentPage == 1 {
                                                self.auth = "main"
                                            } else {
                                                self.currentPage -= 1
                                            }
                                        }
                                    Spacer()
                                }
                                HStack{
                                    Text("4. Photo")
                                        .font(.custom("Ubuntu-Bold", size: 34))
                                    Spacer()
                                }.padding(.top, 50).padding(.bottom, 50)
                                ImagePicker(pickedImage: $pickedImage).padding(.top, 50)
                                Spacer()
                                Button(action: {
                                    self.currentPage += 1
                                }){
                                    HStack {
                                        Text("Next")
                                        Image(systemName: "arrow.right")
                                    }
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                                    .background(Color("textViewColor"))
                                    .clipShape(Capsule())
                                }
                                .padding(.bottom)
                            }
                        } else if currentPage == 5 {
                            VStack {
                                HStack {
                                    Text("Back")
                                        .onTapGesture {
                                            if self.currentPage == 1 {
                                                self.auth = "main"
                                            } else {
                                                self.currentPage -= 1
                                            }
                                        }
                                    Spacer()
                                }
                                Spacer()
                                HStack{
                                    Text("5. Let people know a bit about yourself")
                                        .font(.custom("Ubuntu-Bold", size: 34))
                                    Spacer()
                                }
                                TextView(text: $about, placeholder: "About")
                                    .frame(width: UIScreen.main.bounds.width - 50, height: 300)
                                self.value == 0 ? Spacer() : nil
                                Button(action: {
                                    UIApplication.shared.endEditing()
                                    self.showProgressView = true
                                    let newUser = LocalUser(full_name: self.secondPageFields[0], email: self.firstPageFields[0], phone_number: self.secondPageFields[1], location: self.secondPageFields[2], linkedin_link: self.thirdPageFields[0], twitter_link: self.thirdPageFields[1], facebook_link: self.thirdPageFields[2], github_link: self.thirdPageFields[3], portfolio_link: self.thirdPageFields[4], picture: self.pickedImage.pngData()!.base64EncodedString(), bio: self.about, password: self.firstPageFields[1])
                                    self.networkAgent.signUp(user: newUser)
                                    self.updateProfile()
                                }){
                                    Text("Done")
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                                    .background(Color("textViewColor"))
                                    .clipShape(Capsule())
                                }
                                .padding(.bottom)
                            }.onTapGesture {
                                UIApplication.shared.endEditing()
                            }
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
        } else if networkAgent.myProfile.count != 0{
            me = networkAgent.myProfile[0]
            auth = ""
        } else {
            Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { timer in
                self.updateProfile()
            }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//struct SignUpView_Previews: PreviewProvider {
//    @ObservedObject static var networkAgent = NetworkAgent()
//    @State static var auth: String = "yo"
//    static var previews: some View {
//        SignUpView(networkAgent: networkAgent, auth: $auth, me: $me)
//    }
//}

struct TextView: UIViewRepresentable {
    
    @Binding var text: String
    var placeholder: String
 
    func makeUIView(context: UIViewRepresentableContext<TextView>) -> UITextView {
        let textView = UITextView()
        textView.text = placeholder
        textView.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.delegate = context.coordinator
        textView.textColor = UIColor.tertiaryLabel
        textView.layer.borderColor = UIColor(named: "textViewColor")?.cgColor
        textView.layer.borderWidth = 1.2
        textView.layer.cornerRadius = 20
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
 
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
    }
    
    func makeCoordinator() -> TextView.Coordinator {
        return Coordinator(text: $text, placeholder: placeholder)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        @Binding var text: String
        var placeholder: String
        
        init(text: Binding<String>, placeholder: String) {
            _text = text
            self.placeholder = placeholder
        }

        func textViewDidChange(_ textView: UITextView) {
            if let str = textView.text, str.count == placeholder.count + 1, str.substring(fromIndex: 1) == placeholder{
                textView.textColor = UIColor.label
                textView.text = String(str[0])
            }
            if (textView.text == "")
            {
                textView.text = placeholder
                textView.textColor = UIColor.tertiaryLabel
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
            self.$text.wrappedValue = textView.text == placeholder ? "" : textView.text
        }
        
        func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            textView.layer.borderColor = UIColor.orange.cgColor
            return true
        }
        
        func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
            textView.layer.borderColor = UIColor(named: "textViewColor")!.cgColor
            return true
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            if textView.textColor == UIColor.tertiaryLabel {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

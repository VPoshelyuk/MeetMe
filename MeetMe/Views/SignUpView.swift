//
//  SignUpView.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/12/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
//    @State private var full_name = ""
//    @State private var email = ""
//    @State private var password = ""
//    @State private var phone_number = ""
//    @State private var location = ""
//    @State private var linkedin_link = "https://www.linkedin.com/in/"
//    @State private var twitter_link = "https://twitter.com/"
//    @State private var facebook_link = "https://www.facebook.com/"
//    @State private var portfolio_link = "https://www."
//    @State private var fields = ["", "", "", "", "https://www.linkedin.com/in/", "https://twitter.com/", "https://www.facebook.com/", "https://www."]
//    let fieldNames = ["Full Name", "E-Mail", "Phone #", "Location", "LinkedIn", "Twitter", "Facebook", "Portfolio"]
    
    @State var about = ""
    @State var currentPage = 1
    
    
    @State private var firstPageFields = ["", ""]
    let firstPagePlaceholders = ["E-Mail", "Password"]
    
    @State private var secondPageFields = ["", "", ""]
    let secondPagePlaceholders = ["Full Name", "Phone #", "Location"]
    
    @State private var thirdPageFields = ["", "", "", ""]
    let thirdPagePlaceholders = ["LinkedIn", "Twitter", "Facebook", "Portfolio"]
    
    @State private var editing = false
    @State var value: CGFloat = 0
    
    
    @Binding var auth: String
    
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
                                        self.auth = ""
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
                        ImagePicker().padding(.top, 50)
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
                                        self.auth = ""
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
                            self.currentPage += 1
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
                } else if currentPage == 6 {
                    ContentView()
                }
            }.padding(.horizontal)
            .padding(.bottom, self.value)
            .offset(y: -self.value)
            .animation(.easeInOut(duration: 0.16))
            .onAppear{
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main){ notification in
                    let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    self.value = value.height/2
                }

                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){ notification in
                    self.value = 0
                }
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct SignUpView_Previews: PreviewProvider {
    @State static var auth: String = "yo"
    static var previews: some View {
        SignUpView(auth: $auth)
    }
}

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

//
//struct SignUpView: View {
////    @State var full_name = ""
////    @State private var email = ""
////    @State private var phone_number = ""
////    @State private var location = ""
////    @State private var linkedin_link = "https://www.linkedin.com/in/"
////    @State private var twitter_link = "https://twitter.com/"
////    @State private var facebook_link = "https://www.facebook.com/"
////    @State private var portfolio_link = "https://www."
//    @State private var fields = ["", "", "", "", "https://www.linkedin.com/in/", "https://twitter.com/", "https://www.facebook.com/", "https://www."]
//    @State var about = ""
//
//    @State private var editing = false
//    @State var value: CGFloat = 0
//
//    let fieldNames = ["Full Name", "E-Mail", "Phone #", "Location", "LinkedIn", "Twitter", "Facebook", "Portfolio"]
//
//    @Binding var auth: String
//
//    var drag: some Gesture {
//        DragGesture()
//            .onChanged({gesture in
//                if gesture.startLocation.x < CGFloat(100.0){
//                    self.auth = ""
//                }
//             }
//        )
//    }
//
//    var body: some View {
//        ScrollView(showsIndicators: false){
//            VStack {
//                HStack{
//                    Text("Welcome to MeetMe! \nYou are on your way to sign up! Please start by choosing your picture:")
//                    .frame(width: (UIScreen.main.bounds.width - 50)/2, height: 150)
//                    Spacer()
//                    ImagePicker()
//                }
//                .frame(width: UIScreen.main.bounds.width - 50)
//                ForEach(0..<fieldNames.count, id: \.self){ index in
//                    GlowingTextField(placeholder: self.fieldNames[index], tField: self.$fields[index])
//                }
//                TextView(text: $about, placeholder: "About")
//                    .frame(width: UIScreen.main.bounds.width - 50, height: 300)
//                Button(action: {
//                    print("Form submitted!", self.fields)
//                }){
//                    Text("Done")
//                        .foregroundColor(.white)
//                        .frame(width: UIScreen.main.bounds.width - 50, height: 50)
//                        .background(Color("textViewColor"))
//                        .clipShape(Capsule())
//                }
//                .padding(.bottom)
//            }.padding(.horizontal)
//            .padding(.bottom, self.value)
//            .offset(y: -self.value)
//            .animation(.easeInOut(duration: 0.16))
//            .onAppear{
//                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main){ notification in
//                    let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//                    self.value = value.height/2
//                }
//
//                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main){ notification in
//                    self.value = 0
//                }
//            }
//        }.gesture(drag)
//    }
//}

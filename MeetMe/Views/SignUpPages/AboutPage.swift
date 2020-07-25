//
//  AboutPage.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/24/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI

struct AboutPage: View {
    @Binding var currentPage: Int
    @Binding var about: String
    @Binding var auth: String
    @Binding var value: CGFloat
    @Binding var showProgressView: Bool
    
    
    @Binding var me: Attributes?
    @Binding var firstPageFields: [String]
    @Binding var secondPageFields: [String]
    @Binding var thirdPageFields: [String]
    @Binding var pickedImage:UIImage
    
    @ObservedObject var networkAgent: NetworkAgent
    
    var body: some View {
        VStack {
            HStack {
                Text("Back")
                    .onTapGesture { self.currentPage -= 1 }
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

//struct AboutPage_Previews: PreviewProvider {
//    static var previews: some View {
//        AboutPage()
//    }
//}


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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

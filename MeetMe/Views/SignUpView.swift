//
//  SignUpView.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/12/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
//    @State var full_name = ""
//    @State private var email = ""
//    @State private var phone_number = ""
//    @State private var location = ""
//    @State private var linkedin_link = ""
//    @State private var twitter_link = ""
//    @State private var facebook_link = ""
//    @State private var portfolio_link = ""
    @State private var fields = Array<String>.init(repeating: "", count: 8)
    @State var about = ""
    
    @State private var editing = false
    
    let fieldNames = ["Full Name", "E-Mail", "Phone #", "Location", "LinkedIn", "Twitter", "Facebook", "Portfolio"]
    
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack {
                HStack{
                    Text("Welcome to MeetMe! \nYou are on your way to sign up! Please start by choosing your picture:")
                    .frame(width: (UIScreen.main.bounds.width - 50)/2)
                    Spacer()
                    ImagePicker()
                }
                .frame(width: UIScreen.main.bounds.width - 50)
                ForEach(0..<fieldNames.count, id: \.self){ index in
                    GlowingTextField(placeholder: self.fieldNames[index], tField: self.$fields[index])
                }
                TextView(text: $about, placeholder: "About")
                    .frame(width: UIScreen.main.bounds.width - 50, height: 300)
                Button(action: {
                    print("Form submitted!", self.fields)
                }){
                    Text("Done")
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                        .background(Color("textViewColor"))
                        .clipShape(Capsule())
                }
            }.padding()
        }
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
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

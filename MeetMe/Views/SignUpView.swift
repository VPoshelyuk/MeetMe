//
//  SignUpView.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/12/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @State private var full_name = ""
    @State private var email = ""
    @State private var phone_number = ""
    @State private var location = ""
    @State private var linkedin_link = ""
    @State private var twitter_link = ""
    @State private var facebook_link = ""
    @State private var portfolio_link = ""
    @State var about = ""
    
    var body: some View {
        VStack{
            Text("Look: \($about.wrappedValue)")
            VStack {
                ImagePicker()
                TextField("Full Name", text: $full_name)
                TextField("E-Mail", text: $email)
                TextField("Phone #", text: $phone_number)
                TextField("Location", text: $location)
                TextField("LinkedIn", text: $linkedin_link)
                TextField("Twitter", text: $twitter_link)
                TextField("Facebook", text: $facebook_link)
                TextField("Portfolio", text: $portfolio_link)
                TextView(text: $about, placeholder: "About")
            }
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
        textView.textColor = UIColor.lightGray
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
                textView.textColor = .black
                textView.text = String(str[0])
            }
            if (textView.text == "")
            {
                textView.text = placeholder
                textView.textColor = .lightGray
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
            self.$text.wrappedValue = textView.text == placeholder ? "" : textView.text
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            if textView.textColor == UIColor.lightGray {
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

//
//  SignUpPage.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/15/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI

struct SignUpPage: View {
    let pageName: String
    @Binding var tfArray: [String]
    let placeholders: [String]
    @Binding var currentPage: Int
    @Binding var auth: String
    @Binding var value: CGFloat
    @Binding var presentingUpdateView: Bool
    
    init(pageName: String, tfArray: Binding<[String]>, placeholders: [String], currentPage: Binding<Int>?, auth: Binding<String>?, value: Binding<CGFloat>?, presentingUpdateView: Binding<Bool>?) {
        self.pageName = pageName
        self._tfArray = tfArray
        self.placeholders = placeholders
        self._currentPage = currentPage ?? Binding.constant(-1)
        self._auth = auth ?? Binding.constant("default")
        self._value = value ?? Binding.constant(-1)
        self._presentingUpdateView = presentingUpdateView ?? Binding.constant(false)
    }


    var body: some View {
        VStack() {
            HStack {
                Text("Back")
                    .onTapGesture {
                        if self.currentPage != -1 {
                            if self.currentPage == 1 {
                                self.auth = "main"
                            } else {
                                self.currentPage -= 1
                            }
                        } else {
                            self.presentingUpdateView = false
                        }
                    }
                Spacer()
            }.padding(.bottom, self.value == -1 ? 30 : 0)
            self.value == -1 ? nil : Spacer()
            HStack{
                Text(pageName)
                    .font(.custom("Ubuntu-Bold", size: 34))
                Spacer()
            }
            ForEach(0..<tfArray.count, id: \.self){ index in
                GlowingTextField(placeholder: self.placeholders[index], tField: self.$tfArray[index])
            }
            self.value == 0 ? Spacer() : nil
            Button(action: {
                if self.currentPage != -1 {
                    self.currentPage += 1
                }else{
                    self.presentingUpdateView = false
                }
            }){
                HStack {
                    Text("Next")
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(tfArray.allSatisfy{ $0 != ""} ? .white : Color(.label))
                .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                .background(tfArray.allSatisfy{ $0 != ""} ? Color("textViewColor") : .accentColor)
                .clipShape(Capsule())
            }
            .disabled(!tfArray.allSatisfy{ $0 != ""})
            .padding(.bottom)
            self.value == -1 ? Spacer() : nil
        }
    }
}

//struct SignUpPage_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpPage()
//    }
//}

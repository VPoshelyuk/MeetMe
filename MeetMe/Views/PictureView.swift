//
//  PictureView.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/24/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI

struct PictureView: View {
    @Binding var pickedImage: UIImage
    @Binding var currentPage: Int
    @Binding var auth: String
    @Binding var presentingUpdateView: Bool
    
    init(pickedImage: Binding<UIImage>, currentPage: Binding<Int>?, auth: Binding<String>?, presentingUpdateView: Binding<Bool>?) {
        self._pickedImage = pickedImage
        self._currentPage = currentPage ?? Binding.constant(-1)
        self._auth = auth ?? Binding.constant("default")
        self._presentingUpdateView = presentingUpdateView ?? Binding.constant(false)
    }

    
    var body: some View {
        VStack {
            HStack {
                Text("Back")
                    .onTapGesture {
                        if self.currentPage != -1 {
                            if self.currentPage == 1 {
                                self.auth = "main"
                            } else {
                                self.currentPage -= 1
                            }
                        }
                    }
                Spacer()
            }.padding(.top, auth == "default" ? 5 : 0).padding(.leading, auth == "default" ? 5 : 0)
            HStack{
                Text(auth != "default" ? "4. Photo" : "Update Profile Picture:")
                    .font(.custom("Ubuntu-Bold", size: 34))
                Spacer()
            }.padding(.top, 50).padding(.bottom, 50)
            ImagePicker(pickedImage: $pickedImage).padding(.top, 50)
            Spacer()
            Button(action: {
                if self.currentPage != -1 {
                    self.currentPage += 1
                }else{
                    self.presentingUpdateView = false
                }
            }){
                HStack {
                    Text(auth != "default" ? "Next" : "Update")
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                .background(Color("textViewColor"))
                .clipShape(Capsule())
            }
            .padding(.bottom)
        }
    }
}

//struct PictureView_Previews: PreviewProvider {
//    static var previews: some View {
//        PictureView()
//    }
//}

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

    
    var body: some View {
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
    }
}

//struct PictureView_Previews: PreviewProvider {
//    static var previews: some View {
//        PictureView()
//    }
//}

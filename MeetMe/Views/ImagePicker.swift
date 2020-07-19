//
//  ImagePicker.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/12/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI

struct ImagePicker: View {
    @Binding var pickedImage: UIImage
    
    @State private var isPresented = false
    @State private var imagePicked = false
    
    var body: some View {
        Button(action: {self.isPresented.toggle()}){
            ZStack {
                Text(!imagePicked ? "Choose..." : "Update")
                .zIndex(1)
                Image(uiImage: pickedImage)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill) //update with framework
                .frame(width: 300, height: 300)
                .clipShape(Circle())
                    .overlay(Circle().strokeBorder(isPresented ? .orange : Color("textViewColor"), lineWidth: 1.2))
            }
        }
        .sheet(isPresented: $isPresented, content: { ImagePickerView(isPresented: self.$isPresented, pickedImage: self.$pickedImage, imagePicked: self.$imagePicked) })
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var pickedImage: UIImage
    @Binding  var imagePicked: Bool
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIViewController {
        let tvC = UIImagePickerController()
        tvC.delegate = context.coordinator
        return tvC
    }
    
    func makeCoordinator() -> ImagePickerView.Coordinator {
        return Coordinator(isPresented: $isPresented, pickedImage: $pickedImage, imagePicked: $imagePicked)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var isPresented: Bool
        @Binding var pickedImage: UIImage
        @Binding  var imagePicked: Bool
        
        init(isPresented: Binding<Bool>, pickedImage: Binding<UIImage>, imagePicked: Binding<Bool>) {
            _isPresented = isPresented
            _pickedImage = pickedImage
            _imagePicked = imagePicked
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selected = info[.originalImage] as? UIImage {
                pickedImage = selected
                imagePicked = true
                isPresented = false
            }
        }
    }
    
    func updateUIViewController(_ uiViewController: ImagePickerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePickerView>) {
    }
}

struct ImagePicker_Previews: PreviewProvider {
    @State static var pickedImage = UIImage()
    static var previews: some View {
        ImagePicker(pickedImage: $pickedImage)
    }
}

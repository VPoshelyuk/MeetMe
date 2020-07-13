//
//  ImagePicker.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/12/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI

struct ImagePicker: View {
    @State private var isPresented = false
    @State var pickedImage = UIImage()
    
    var body: some View {
        Button(action: {self.isPresented.toggle()}){
            ZStack {
                Text("Edit")
                .zIndex(1)
                Image(uiImage: pickedImage)
                .renderingMode(.original)
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(Color.gray, lineWidth: 3))
            }
        }
        .sheet(isPresented: $isPresented, content: { ImagePickerView(isPresented: self.$isPresented, pickedImage: self.$pickedImage) })
    }
}

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var pickedImage: UIImage
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIViewController {
        let tvC = UIImagePickerController()
        tvC.delegate = context.coordinator
        return tvC
    }
    
    func makeCoordinator() -> ImagePickerView.Coordinator {
        return Coordinator(isPresented: $isPresented, pickedImage: $pickedImage)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var isPresented: Bool
        @Binding var pickedImage: UIImage
        
        init(isPresented: Binding<Bool>, pickedImage: Binding<UIImage>) {
            _isPresented = isPresented
            _pickedImage = pickedImage
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selected = info[.originalImage] as? UIImage {
                pickedImage = selected
                isPresented = false
            }
        }
    }
    
    func updateUIViewController(_ uiViewController: ImagePickerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ImagePickerView>) {
    }
}

struct ImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        ImagePicker()
    }
}

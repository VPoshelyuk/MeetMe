//
//  GlowingTextField.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/13/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI

struct GlowingTextField: View {
    var placeholder: String
    @Binding var tField: String
    @State private var editing = false
    
    var body: some View {
        TextField(placeholder, text: $tField, onEditingChanged: {edit in self.editing = edit})
        .frame(width: UIScreen.main.bounds.width - 50)
        .textFieldStyle(CustomTextFieldStyle(focused: $editing))
    }
}

struct GlowingTextField_Previews: PreviewProvider {
    @State static var tField = ""
    static var previews: some View {
        GlowingTextField(placeholder: "Yo", tField: $tField)
    }
}

struct CustomTextFieldStyle : TextFieldStyle {
    @Binding var focused: Bool
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 15)
            .padding(.horizontal, 10)
            .background(
                Capsule()
                    .stroke(focused ? .orange : Color("textViewColor"), lineWidth: 1)
            )
    }
}

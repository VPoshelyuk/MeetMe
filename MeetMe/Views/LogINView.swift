//
//  LogInView.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/14/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI

struct LogInView: View {
    
    @ObservedObject var networkAgent: NetworkAgent
    @Binding var auth: String
    
    @State var email = ""
    @State var password = ""
    var drag: some Gesture {
        DragGesture()
            .onChanged({gesture in
                if gesture.startLocation.x < CGFloat(100.0) && gesture.predictedEndLocation.x > CGFloat(UIScreen.main.bounds.width - 100){
                    self.auth = ""
                }
             }
        )
    }
    var body: some View {
        VStack {
            GlowingTextField(placeholder: "E-Mail", tField: $email)
            GlowingTextField(placeholder: "Password", tField: $password)
            }.gesture(drag).padding()
    }
}

struct LogInView_Previews: PreviewProvider {
    @ObservedObject static var networkAgent = NetworkAgent()
    @State static var auth: String = "yo"
    static var previews: some View {
        LogInView(networkAgent: networkAgent, auth: $auth)
    }
}

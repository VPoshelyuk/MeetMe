//
//  ContentView.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/12/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI
import MessageUI

struct ContentView: View {
    enum ActiveSheet: Hashable, Identifiable {
       case web, mail
        
        var id: Int {
            return self.hashValue
        }
    }
    
    @Environment(\.colorScheme) var colorScheme
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var presentingModal = false
    @State private var activeSheet: ActiveSheet? = nil
    @State var link = ""
    @State private var selected = 1
    var body: some View {
        VStack {
            if self.selected == 0 {
                Spacer()
                Text("Hi, asshole!")
                Spacer()
            }else if self.selected == 1 {
                Spacer()
                Image("test")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .clipShape(Circle())
                    .overlay(Circle().strokeBorder(Color.gray, lineWidth: 3))
                Text("Viachaslau Pashaliuk")
                    .font(.custom("Ubuntu-Bold", size: 34))
                HStack(spacing: 20) {
                    Image("facebook")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 50, height: 50)
                        .onTapGesture { self.presentingModal = true; self.activeSheet = .web; self.link =  "https://www.facebook.com/slava.poshelyk"}
                    Image("twitter")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 50, height: 50)
                        .onTapGesture { self.presentingModal = true; self.activeSheet = .web; self.link =  "https://twitter.com/SPoshelyk"}
                    Image("linkedin")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 50, height: 50)
                        .onTapGesture { self.presentingModal = true; self.activeSheet = .web; self.link =  "https://www.linkedin.com/in/viachaslau-pashaliuk/"}
                    Image("github")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 50, height: 50)
                        .onTapGesture { self.presentingModal = true; self.activeSheet = .web; self.link =  "https://github.com/VPoshelyuk/"}
                    Image("email")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 50, height: 50)
                        .onTapGesture { self.activeSheet = .mail; self.presentingModal = true }
                    Image("portfolio")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 50, height: 50)
                        .onTapGesture {self.activeSheet = .web; self.link =  "https://www.linkedin.com/in/viachaslau-pashaliuk/"; self.presentingModal = true; print(self.link) }
                }
                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                .disabled(!MFMailComposeViewController.canSendMail())
                .sheet(item: $activeSheet) { item in
                    if item == .web {
                        ModalView(presentedAsModal: self.$presentingModal, URL: self.$link)
                    }else if item == .mail {
                        MailView(result: self.$result, toRecipents: ["v.pashaliuk@gmail.com"])
                    }
                }
                Divider()
                .background(Color.gray)
                .frame(width: UIScreen.main.bounds.width - 30)
                Text("About")
                    .font(.custom("Ubuntu-Bold", size: 34))
                    .multilineTextAlignment(.center)
                Divider()
                    .background(Color.gray)
                    .frame(width: UIScreen.main.bounds.width - 30)
                ScrollView(){
                    Text("First things first, I like everything about computers, especially the fact that they are good at following instructions. It was fascinating to me since early childhood to see how machines are able to do so much just switching between 0's and 1's. My actual programming experience started with a calculator app that was written in Objective-C and it still can be found somewhere on my GitHub.\nDuring my studying journey, I had a chance to attend Flatiron School's Software Engineering Immersive program, where I learned the tools for Full-Stack Web-Development, such as Ruby on Rails for Backend and JavaScript with React and Redux frameworks for Frontend. Studying at Flatiron School included a lot of collaboration with other students which I enjoyed since working on a team is a great opportunity to share your knowledge and learn from others.")
                        .font(.custom("Ubuntu-Light", size: 18))
                        .multilineTextAlignment(.center)
                }
            }else {
                Spacer()
                Text("Bye, asshole!")
                Spacer()
            }
            SegmentedControlView(selected: self.$selected)
                .padding(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ModalView: View {
    @Binding var presentedAsModal: Bool
    @Binding var URL: String
    var body: some View {
        VStack {
            HStack{
                Button("Back") { self.presentedAsModal = false }
            }
            .frame(maxHeight: 12.0)
            .padding()
            DetailView(url: URL)
        }
    }
}

struct MailView: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    var toRecipents = [String]()

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?
        var toRecipents = [String]()

        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>, toRecipents: [String]) {
            _presentation = presentation
            _result = result
            self.toRecipents = toRecipents
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result, toRecipents: toRecipents)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients(toRecipents)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}

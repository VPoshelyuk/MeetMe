//
//  Profile.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/18/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI
import MessageUI

struct Profile: View {
    enum ActiveSheet: Hashable, Identifiable {
       case web, mail
        
        var id: Int {
            return self.hashValue
        }
    }
    
    @Binding var me: Attributes?
    
    @Environment(\.colorScheme) var colorScheme
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var presentingModal = false
    @State private var activeSheet: ActiveSheet? = nil
    @State var link = ""
    
    var body: some View {
        VStack {
            Spacer()
            Image("test")
                .resizable()
                .frame(width: 300, height: 300)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(Color("textViewColor"), lineWidth: 3))
            Text(me!.full_name)
                .font(.custom("Ubuntu-Bold", size: 34))
            HStack(spacing: 20) {
                if me!.facebook_link.contains("facebook") {
                    Image("facebook")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 50, height: 50)
                        .onTapGesture { self.presentingModal = true; self.activeSheet = .web; self.link =  "https://www.facebook.com/slava.poshelyk"}
                }
                if me!.twitter_link.contains("twitter") {
                Image("twitter")
                .resizable()
                .renderingMode(.template)
                .frame(width: 50, height: 50)
                    .onTapGesture { self.presentingModal = true; self.activeSheet = .web; self.link =  "https://twitter.com/SPoshelyk"}
                }
                if me!.linkedin_link.contains("linkedin") {
                Image("linkedin")
                .resizable()
                .renderingMode(.template)
                .frame(width: 50, height: 50)
                    .onTapGesture { self.presentingModal = true; self.activeSheet = .web; self.link =  "https://www.linkedin.com/in/viachaslau-pashaliuk/"}
                }
                if me!.github_link.contains("github") {
                Image("github")
                .resizable()
                .renderingMode(.template)
                .frame(width: 50, height: 50)
                    .onTapGesture { self.presentingModal = true; self.activeSheet = .web; self.link =  "https://github.com/VPoshelyuk/"}
                }
                Image("email")
                .resizable()
                .renderingMode(.template)
                .frame(width: 50, height: 50)
                    .onTapGesture { self.activeSheet = .mail; self.presentingModal = true }
                if me!.portfolio_link.contains(".") {
                Image("portfolio")
                .resizable()
                .renderingMode(.template)
                .frame(width: 50, height: 50)
                    .onTapGesture {self.activeSheet = .web; self.link =  "https://www.linkedin.com/in/viachaslau-pashaliuk/"; self.presentingModal = true; print(self.link) }
                }
            }
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            .disabled(!MFMailComposeViewController.canSendMail())
            .sheet(item: $activeSheet) { item in
                if item == .web {
                    ModalView(presentedAsModal: self.$presentingModal, URL: self.$link)
                }else if item == .mail {
                    MailView(result: self.$result, toRecipents: [self.me!.email])
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
                Text(me!.bio)
                    .font(.custom("Ubuntu-Light", size: 18))
                    .multilineTextAlignment(.center)
            }
        }.onAppear{print(self.me as Any)}
    }
}

struct Profile_Previews: PreviewProvider {
    @State static var me: Attributes? = Attributes(id: 1, full_name: "Viachaslau Pashaliuk", email: "v.pashaliuk", phone_number: "9293098458", location: "New York", linkedin_link: "", twitter_link: "", facebook_link: "", github_link: "", portfolio_link: "", bio: "Cheeeck", picture: "https://meetme-assets.s3.amazonaws.com/9293098458_profile_picture.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIELZLJXFXKRQZTVA%2F20200719%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200719T021702Z&X-Amz-Expires=900&X-Amz-SignedHeaders=host&X-Amz-Signature=6a821cfce8bbd974dd999cb8563a2d9857c6aa1f94bfbc4cabf7c7d8a395b1df")
    static var previews: some View {
        Profile(me: $me)
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

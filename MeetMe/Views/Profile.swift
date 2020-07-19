//
//  Profile.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/18/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI
import URLImage
import MessageUI

enum ActiveSheet: Hashable, Identifiable {
   case web, mail
    
    var id: Int {
        return self.hashValue
    }
}

struct Profile: View {
    @Binding var me: Attributes?
    
    @Environment(\.colorScheme) var colorScheme
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var presentingModal = false
    @State private var activeSheet: ActiveSheet? = nil
    @State var link = ""
    @State var links: [(link: String, sample: String)] = []
    
    var body: some View {
        VStack {
            Spacer()
            URLImage(URL(string: me!.picture)!, placeholder: {
                ProgressView($0) { progress in
                    ZStack {
                        if progress > 0.0 {
                            // The download has started. CircleProgressView displays the progress.
                            CircleProgressView(progress).stroke(lineWidth: 8.0)
                        }
                        else {
                            // The download has not yet started. CircleActivityView is animated activity indicator that suits this case.
                            CircleActivityView().stroke(lineWidth: 20.0)
                        }
                    }
                }
                    .frame(width: 250, height: 250)
            },content:  {
                $0.image
                    .resizable()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .overlay(Circle().strokeBorder(Color("textViewColor"), lineWidth: 3))
            })
            Text(me!.full_name)
                .font(.custom("Ubuntu-Bold", size: 34))
            Text(me!.location)
            HStack(spacing: 20) {
                ForEach(0..<links.count, id: \.self) { i in
                    LinkLogos(linkTuple: self.links[i], presentingModal: self.$presentingModal, activeSheet: self.$activeSheet, link: self.$link)
                }
            }
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            .disabled(!MFMailComposeViewController.canSendMail())
            .sheet(item: $activeSheet) { item in
                if item == .web {
                    ModalView(presentingModal: self.$presentingModal, URL: self.$link)
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
        }.onAppear{
            self.links = [(link: self.me!.facebook_link, sample: "facebook.com/"), (link: self.me!.twitter_link, sample: "twitter.com/"), (link: self.me!.email, sample: "@"), (link: self.me!.portfolio_link, sample: "."), (link: self.me!.linkedin_link, sample: "linkedin.com/in/"), (link: self.me!.github_link, sample: "github.com/")]
        }
    }
}

struct LinkLogos: View {
    let linkTuple: (link: String, sample: String)
    @Binding var presentingModal: Bool
    @Binding var activeSheet: ActiveSheet?
    @Binding var link: String
    var body: some View {
        VStack{
            if linkTuple.link.contains(linkTuple.sample) {
                Image(linkTuple.sample != "." && linkTuple.sample != "@" ? String(linkTuple.sample.split(separator: ".")[0]) : linkTuple.sample == "@" ? "email": "portfolio")
                .resizable()
                .renderingMode(.template)
                .frame(width: 50, height: 50)
                .onTapGesture {
                    if self.linkTuple.sample != "@" {
                        self.presentingModal = true; self.activeSheet = .web; self.link =  self.linkTuple.link
                    } else {
                        self.activeSheet = .mail; self.presentingModal = true
                    }
                }
            }
        }
    }
}
    
    

struct Profile_Previews: PreviewProvider {
    @State static var me: Attributes? = Attributes(id: 1, full_name: "Viachaslau Pashaliuk", email: "v.pashaliuk", phone_number: "9293098458", location: "New York", linkedin_link: "", twitter_link: "", facebook_link: "", github_link: "", portfolio_link: "", bio: "Cheeeck", picture: "https://meetme-assets.s3.amazonaws.com/9293098458_profile_picture.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIELZLJXFXKRQZTVA%2F20200719%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200719T021702Z&X-Amz-Expires=900&X-Amz-SignedHeaders=host&X-Amz-Signature=6a821cfce8bbd974dd999cb8563a2d9857c6aa1f94bfbc4cabf7c7d8a395b1df")
    static var previews: some View {
        Profile(me: $me)
    }
}


struct ModalView: View {
    @Binding var presentingModal: Bool
    @Binding var URL: String
    var body: some View {
        VStack {
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

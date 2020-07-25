//
//  GridView.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/24/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct GridView: View {
    private var columns: [GridItem] = [
        GridItem(.fixed(UIScreen.main.bounds.width/2 - 20), spacing: 15),
            GridItem(.fixed(UIScreen.main.bounds.width/2 - 20), spacing: 15)
        ]

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 15,
                pinnedViews: [.sectionHeaders, .sectionFooters]
            ) {
                Section(header: Text("Cards collection").font(.title)) {
                        VStack{
                            Spacer()
                            Text("New Connections").padding(.bottom, 5)
                        }
                        .frame(width: UIScreen.main.bounds.width/2 - 20, height: UIScreen.main.bounds.width/2 - 20)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                        .onTapGesture {
                            print("New Connections tapped")
                        }
                        VStack{
                            Spacer()
                            Text("Old Connections").padding(.bottom, 5)
                        }
                        .frame(width: UIScreen.main.bounds.width/2 - 20, height: UIScreen.main.bounds.width/2 - 20)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(15)
                        .onTapGesture {
                            print("Old Connections tapped")
                        }
                }
            }
        }
    }
}

//struct GridView_Previews: PreviewProvider {
//    static var previews: some View {
//        GridView()
//    }
//}

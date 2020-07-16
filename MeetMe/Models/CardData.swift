//
//  CardData.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/12/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import Foundation

struct Card: Decodable, Identifiable {
    let id: Int?
    let full_name: String
    let email: String
    let profile_pic_path: String
    let phone_number: String
    let location: String
    let linkedin_link: String
    let twitter_link: String
    let fb_link: String
    let portfolio_link: String
    let db_link: String
    let bio: String
}

//
//  UserData.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/12/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import Foundation

struct User: Decodable, Identifiable {
    let id: String? = nil
    let full_name: String
    let email: String
    let phone_number: String
    let location: String
    let linkedin_link: String?
    let twitter_link: String?
    let facebook_link: String?
    let portfolio_link: String?
    let bio: String?
    let password: String?
}

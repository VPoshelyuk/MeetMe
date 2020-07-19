//
//  ReceivedUserData.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/18/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import Foundation

struct Response: Decodable {
    let user: User
}

struct User: Decodable {
    let data: UData
}

struct UData: Decodable {
    let attributes: Attributes
}

struct Attributes: Codable, Identifiable {
    static var supportsSecureCoding: Bool = true
    let id: Int
    let full_name: String
    let email: String
    let phone_number: String
    let location: String
    let linkedin_link: String
    let twitter_link: String
    let facebook_link: String
    let github_link: String
    let portfolio_link: String
    let bio: String
    let picture: String
}

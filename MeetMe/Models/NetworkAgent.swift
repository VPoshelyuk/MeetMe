//
//  NetworkAgent.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/12/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import Foundation

class NetworkAgent: ObservableObject {
    
    @Published var cards = [Card]()
    static let session = URLSession(configuration: .default)
    
    func fetchAllCards(_ id: String) {
        fetchAll(with: createStringURL(id: id))
    }
    
    func createStringURL(id: String) -> String{
        return "https://cloud.iexapis.com/stable/stock/\(id)/batch?types=quote,news&token=pk_871ea244ab314546a2c5c16427f7e86f"
    }
    
    func fetchAll(with urlString: String) {
        if let url = URL(string: urlString) {
            let task = NetworkAgent.session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    let decoder = JSONDecoder()
                    if let safeData = data {
                        do {
                            let result = try decoder.decode(Card.self, from: safeData)
                            DispatchQueue.main.async {
                                print(result.full_name)
                            }
                        }catch {
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func signUp(user: User) {
        let json: [String: Any] = ["full_name": user.full_name,
                                   "email": user.email,
                                   "profile_pic_path": user.profile_pic_path,
                                   "phone_number": user.phone_number,
                                   "location": user.location,
                                   "linkedin_link": user.linkedin_link ?? "",
                                   "twitter_link": user.twitter_link ?? "",
                                   "fb_link": user.fb_link ?? "",
                                   "portfolio_link": user.portfolio_link ?? "",
                                   "bio": user.bio ?? ""]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "https://meetme-api-v1.herokuapp.com/api/v1/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // insert json data to the request
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }

        task.resume()
    }
    
    func logIn(email: String, password: String) {
        let json: [String: Any] = ["title": "ABC",
                                   "dict": ["1":"First", "2":"Second"]]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "http://httpbin.org/post")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // insert json data to the request
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }

        task.resume()
    }
}

//
//  NetworkAgent.swift
//  MeetMe
//
//  Created by Slava Pashaliuk on 7/12/20.
//  Copyright © 2020 Viachaslau Pashaliuk. All rights reserved.
//

import Foundation

class NetworkAgent: ObservableObject {
    
    let baseURL = "https://meetme-api-v1.herokuapp.com"
    
    @Published var myProfile = [Attributes]()
    @Published var cards = [User]()
    static let session = URLSession(configuration: .default)
    
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
    
    func signUp(user: LocalUser) {
        var json: Dictionary<String, AnyObject>!
        json = ["full_name": user.full_name as AnyObject,
                   "email": user.email as AnyObject,
                   "phone_number": user.phone_number as AnyObject,
                   "location": user.location  as AnyObject,
                   "linkedin_link": (user.linkedin_link ?? "") as AnyObject,
                   "twitter_link": (user.twitter_link ?? "") as AnyObject,
                   "facebook_link": (user.facebook_link ?? "") as AnyObject,
                   "github_link": (user.github_link ?? "") as AnyObject,
                   "portfolio_link": (user.portfolio_link ?? "") as AnyObject,
                   "bio": (user.bio ?? "") as AnyObject,
                   "picture": user.picture as AnyObject,
                   "password": user.password  as AnyObject]
        let url = URL(string: "\(baseURL)/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json as Any, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = NetworkAgent.session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.async {
                    self.myProfile = [result.user.data.attributes]
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(result.user.data.attributes) {
                        UserDefaults.standard.set(encoded, forKey: "me")
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    func logIn(email: String, password: String) {
        let json = ["email": email,
                "password": password]

        let url = URL(string: "\(baseURL)/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json as Any, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = NetworkAgent.session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.async {
                    self.myProfile = [result.user.data.attributes]
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(result.user.data.attributes) {
                        UserDefaults.standard.set(encoded, forKey: "me")
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}

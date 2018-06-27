//
//  UpdateUser.swift
//  Petspot
//
//  Created by Athanasios on 27/06/2018.
//  Copyright © 2018 Athanasios. All rights reserved.
//

import Foundation
import UIKit

func update_user(username: String) {
    let url = URL(string: "http://localhost:7000/user_data")
    var request = URLRequest(url: url!)
    
    request.httpMethod = "POST"
    request.httpBody = "username=\(username)".data(using: String.Encoding.utf8)
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if error == nil {
            if let d = data {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers)
                    
                    DispatchQueue.main.sync(execute: {
                        if let json = jsonData as? NSDictionary {
                            print(json)
                            if String(describing: json["message"]!) == "ERROR" {
                                print("Internal server error.")
                            }
                            else if String(describing: json["message"]!) == "NOT_FOUND" {
                                print("User not found at the moment.")
                            }
                            else if String(describing: json["message"]!) == "FOUND" {
                                print("Success")
                                global_user = (json["user"]! as? NSDictionary)!
                            }
                            else {
                                print("Internal server error.")
                            }
                        }
                    })
                }
                catch {
                    print("Do/Catch failed.")
                }
            }
        }
        else {
            print(error ?? "Error")
        }
    }
    
    task.resume()
}

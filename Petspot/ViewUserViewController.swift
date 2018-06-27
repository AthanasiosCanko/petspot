//
//  ViewUserViewController.swift
//  Petspot
//
//  Created by Athanasios on 10/06/2018.
//  Copyright © 2018 Athanasios. All rights reserved.
//

import UIKit

class ViewUserViewController: UIViewController {
    
    // To prevent multiple requests and error crashes
    var clicked = false
    
    @IBOutlet weak var username_label: UILabel!
    @IBOutlet weak var pet_name_label: UILabel!
    @IBOutlet weak var pet_category_label: UILabel!
    @IBOutlet weak var pet_type_label: UILabel!
    @IBOutlet weak var number_of_friends_label: UILabel!
    @IBOutlet weak var request_output_label: UILabel!
    @IBOutlet weak var add_friend_button_outlet: UIBarButtonItem!
    
    @IBAction func add_friend_button(_ sender: Any) {
        if clicked == false {
            clicked = true
            
            add_friend_button_outlet.tintColor = UIColor.gray
            let username = view_user["username"] ?? "--"
            //        request_output_label.text = "\(username)"
            
            let url = URL(string: "http://localhost:7000/send_request")
            var request = URLRequest(url: url!)
            
            request.httpMethod = "POST"
            request.httpBody = "username=\(global_user["username"]!)&request_username=\(username)".data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    if let d = data {
                        do {
                            let jsonData = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers)
                            
                            DispatchQueue.main.sync(execute: {
                                if let json = jsonData as? NSDictionary {
                                    print(json)
                                    if String(describing: json["message"]!) == "ERROR" {
                                        self.request_output_label.text = "Internal server error."
                                    }
                                    else if String(describing: json["message"]!) == "NOT_FOUND" {
                                        self.request_output_label.text = "User not found at the moment."
                                    }
                                    else if String(describing: json["message"]!) == "NOT_UPDATED" {
                                        self.request_output_label.text = "Could not send friend request. Try later."
                                    }
                                    else if String(describing: json["message"]!) == "UPDATED" {
                                        self.request_output_label.text = "Request sent."
                                    }
                                    else if String(describing: json["message"]!) == "ALREADY_SENT" {
                                        self.request_output_label.text = "Request already sent once."
                                    }
                                    else if String(describing: json["message"]!) == "YOURSELF" {
                                        self.request_output_label.text = "You can't add yourself."
                                    }
                                    else {
                                        self.request_output_label.text = "Internal server error."
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
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true) {
            print("View User dismissed.")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        print(view_user)
        username_label.text = "Username: \(view_user["username"] ?? "--")"
        pet_name_label.text = "Pet name: \(view_user["pet_name"] ?? "--")"
        pet_category_label.text = "Pet category: \(view_user["pet_category"] ?? "--")"
        pet_type_label.text = "Pet type: \(view_user["pet_type"] ?? "--")"
        
        if let list_of_friends = view_user["friends"] as? NSArray {
            number_of_friends_label.text = "Number of friends: \(String(describing: list_of_friends.count))"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

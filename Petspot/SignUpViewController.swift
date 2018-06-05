//
//  SignUpViewController.swift
//  Petspot
//
//  Created by Athanasios on 05/06/2018.
//  Copyright © 2018 Athanasios. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username_input: UITextField!
    @IBOutlet weak var email_input: UITextField!
    @IBOutlet weak var password_input: UITextField!
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true) {
            print("Sign up dismissed.")
        }
    }
    
    @IBAction func sign_up_button(_ sender: Any) {
        let username = username_input.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let email = email_input.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = password_input.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if email.components(separatedBy: "@").count == 1 || email == "" || username == "" || password == "" {
            print("Please fill all fields correctly.")
        }
        else {
            let url = URL(string: "http://localhost:7000/sign_up")
            var request = URLRequest(url: url!)
            
            request.httpMethod = "POST"
            request.httpBody = "username=\(username)&email=\(email)&password=\(password)".data(using: String.Encoding.utf8)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if error == nil {
                    if let d = data {
                        do {
                            let jsonData = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers)
                            
                            DispatchQueue.main.sync(execute: {
                                if let json = jsonData as? NSDictionary {
                                    if String(describing: json["message"]!) == "ERROR" {
                                        print("Internal server error.")
                                    }
                                    else if String(describing: json["message"]!) == "NO_HASH" {
                                        print("Could not create hash.")
                                    }
                                    else if String(describing: json["message"]!) == "NOT_CREATED" {
                                        print("Could not create account at the moment.")
                                    }
                                    else if String(describing: json["message"]!) == "CREATED" {
                                        print("Success.")
                                    }
                                    else if String(describing: json["message"]!) == "USERNAME_FOUND" {
                                        print("Username in use.")
                                    }
                                    else if String(describing: json["message"]!) == "EMAIL_FOUND" {
                                        print("Email in use.")
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
                    print(error)
                }
            }
            task.resume()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

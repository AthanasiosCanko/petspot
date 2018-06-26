//
//  ViewController.swift
//  Petspot
//
//  Created by Athanasios on 08/05/2018.
//  Copyright © 2018 Athanasios. All rights reserved.
//

import UIKit

var global_user = NSDictionary()
class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username_input: UITextField!
    @IBOutlet weak var password_input: UITextField!
    
    @IBAction func sign_up_button(_ sender: Any) {
        self.performSegue(withIdentifier: "sign_up", sender: [])
    }
    
    @IBAction func log_in_button(_ sender: Any) {
        let username = username_input.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = password_input.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if username == "" || password == "" {
            print("Please type on both fields.")
        }
        else {
            let url = URL(string: "http://localhost:7000/log_in")
            var request = URLRequest(url: url!)
            
            request.httpMethod = "POST"
            request.httpBody = "username=\(username)&password=\(password)".data(using: String.Encoding.utf8)
            
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
                                    else if String(describing: json["message"]!) == "INCORRECT_CREDENTIALS" {
                                        print("Incorrect credentials.")
                                    }
                                    else if String(describing: json["message"]!) == "CORRECT_CREDENTIALS" {
                                        global_user = (json["user"]! as? NSDictionary)!
                                        print(global_user)
                                        self.performSegue(withIdentifier: "log_in", sender: [])
                                        print("Home shown.")
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
                    // print error in a label
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


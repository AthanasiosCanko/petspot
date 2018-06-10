//
//  SignUpViewController.swift
//  Petspot
//
//  Created by Athanasios on 05/06/2018.
//  Copyright © 2018 Athanasios. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr_of_pets.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arr_of_pets[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pet_category_input.text = arr_of_pets[row]
    }
    
    var arr_of_pets = [
        "--",
        "Dog",
        "Cat",
        "Lizard",
        "Fish",
        "Other"
    ]
    
    @IBOutlet weak var username_input: UITextField!
    @IBOutlet weak var email_input: UITextField!
    @IBOutlet weak var password_input: UITextField!
    @IBOutlet weak var pet_name_input: UITextField!
    @IBOutlet weak var pet_category_input: UITextField!
    @IBOutlet weak var pet_type_input: UITextField!
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true) {
            print("Sign up dismissed.")
        }
    }
    
    @IBAction func sign_up_button(_ sender: Any) {
        let username = username_input.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let email = email_input.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = password_input.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let pet_name = pet_name_input.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let pet_category = pet_category_input.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let pet_type = pet_type_input.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if email.components(separatedBy: "@").count == 1 || email == "" || username == "" || password == "" || pet_name == "" || pet_category == "" || pet_category == "--" || pet_type == "" {
            print("Please fill all fields correctly.")
        }
        else {
            let url = URL(string: "http://localhost:7000/sign_up")
            var request = URLRequest(url: url!)
            
            request.httpMethod = "POST"
            request.httpBody = "username=\(username)&email=\(email)&password=\(password)&pet_name=\(pet_name)&pet_category=\(pet_category)&pet_type=\(pet_type)".data(using: String.Encoding.utf8)
            
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
                    print(error ?? "Error")
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
    
        let petCategoryPickerView = UIPickerView()
        petCategoryPickerView.delegate = self
        pet_category_input.inputView = petCategoryPickerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//
//  SearchViewController.swift
//  Petspot
//
//  Created by Athanasios on 10/06/2018.
//  Copyright © 2018 Athanasios. All rights reserved.
//

import UIKit

var view_user = NSDictionary()
class SearchViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    var results = [NSDictionary]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = (results[indexPath.row]["username"]! as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view_user = results[indexPath.row]
        print(view_user)
        self.performSegue(withIdentifier: "view_user", sender: [])
    }
    
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
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var output_label: UILabel!
    @IBOutlet weak var username_input: UITextField!
    @IBOutlet weak var pet_name_input: UITextField!
    @IBOutlet weak var pet_category_input: UITextField!
    @IBOutlet weak var pet_type_input: UITextField!
    
    var arr_of_pets = [
        "--",
        "Dog",
        "Cat",
        "Lizard",
        "Fish",
        "Other"
    ]
    
    @IBAction func search_by_username_button(_ sender: Any) {
        reset_all_query()
        self.view.endEditing(true)
        
        let username = username_input.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if username == "" {
            output_label.text = "Please fill the username field."
        }
        else {
            let query = "username=\(username)".data(using: String.Encoding.utf8)
            search_request(query: query!)
        }
    }
    
    @IBAction func search_by_pet_name_button(_ sender: Any) {
        reset_all_query()
        self.view.endEditing(true)
        
        let pet_name = pet_name_input.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if pet_name == "" {
            output_label.text = "Please fill the pet name field."
        }
        else {
            let query = "pet_name=\(pet_name)".data(using: String.Encoding.utf8)
            search_request(query: query!)
        }
    }
    
    @IBAction func search_by_pet_category_button(_ sender: Any) {
        reset_all_query()
        self.view.endEditing(true)
        
        let pet_category = pet_category_input.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if pet_category == "" || pet_category == "--" {
            output_label.text = "Please fill the pet category field."
        }
        else {
            let query = "pet_category=\(pet_category)".data(using: String.Encoding.utf8)
            search_request(query: query!)
        }
    }
    
    @IBAction func search_by_pet_type_button(_ sender: Any) {
        reset_all_query()
        self.view.endEditing(true)
        
        let pet_type = pet_type_input.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if pet_type == "" {
            output_label.text = "Please fill the pet type field."
        }
        else {
            let query = "pet_type=\(pet_type)".data(using: String.Encoding.utf8)
            search_request(query: query!)
        }
    }
    
    func search_request(query: Data) {
        let url = URL(string: "http://localhost:7000/search")
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        request.httpBody = query
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error ?? "Error")
            }
            else {
                if let d = data {
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        DispatchQueue.main.sync(execute: {
                            if let json = jsonData as? NSDictionary {
                                print(json)
                                
                                if String(describing: json["message"]!) == "ERROR" {
                                    print("Internal server error.")
                                }
                                else if String(describing: json["message"]!) == "NO_RESULTS" {
                                    self.output_label.text = "0 results."
                                    print("No results for your query.")
                                }
                                else if String(describing: json["message"]!) == "RESULTS_FOUND" {
                                    print("Results found.")
                                    
                                    if let items = json["item"]! as? NSArray {
                                        if items.count == 1 {
                                            self.output_label.text = "1 result."
                                        }
                                        else if items.count > 1 {
                                            self.output_label.text = "\(items.count) results."
                                        }
                                        
                                        for item in items {
                                            if let result = item as? NSDictionary {
                                                self.results.append(result)
                                                self.table.reloadData()
                                            }
                                        }
                                    }
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
        }
        task.resume()
    }
    
    func reset_all_query() {
        view_user = NSDictionary()
        results = []
        table.reloadData()
        output_label.text = ""
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true) {
            print("Search dismissed.")
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

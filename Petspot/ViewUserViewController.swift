//
//  ViewUserViewController.swift
//  Petspot
//
//  Created by Athanasios on 10/06/2018.
//  Copyright © 2018 Athanasios. All rights reserved.
//

import UIKit

class ViewUserViewController: UIViewController {
    
    @IBOutlet weak var username_label: UILabel!
    @IBOutlet weak var pet_name_label: UILabel!
    @IBOutlet weak var pet_category_label: UILabel!
    @IBOutlet weak var pet_type_label: UILabel!
    @IBOutlet weak var number_of_friends_label: UILabel!
    
    @IBAction func add_friend_button(_ sender: Any) {
        // To do
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
        print(view_user)
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

//
//  ProfileViewController.swift
//  Petspot
//
//  Created by Athanasios on 27/06/2018.
//  Copyright © 2018 Athanasios. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true) {
            print("Profile dismissed.")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

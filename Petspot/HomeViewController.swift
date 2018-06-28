//
//  HomeViewController.swift
//  Petspot
//
//  Created by Athanasios on 09/05/2018.
//  Copyright © 2018 Athanasios. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBAction func profile_button(_ sender: Any) {
        self.performSegue(withIdentifier: "profile", sender: [])
    }
    
    @IBAction func search_button(_ sender: Any) {
        self.performSegue(withIdentifier: "search", sender: [])
    }
    
    @IBAction func friends(_ sender: Any) {
        self.performSegue(withIdentifier: "friends", sender: [])
    }
    
    @IBAction func log_out_button(_ sender: Any) {
        self.dismiss(animated: true) {
            print("Home dismissed.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

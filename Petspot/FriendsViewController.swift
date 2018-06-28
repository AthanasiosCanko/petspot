//
//  FriendsViewController.swift
//  Petspot
//
//  Created by Athanasios on 27/06/2018.
//  Copyright © 2018 Athanasios. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var friends = [String]()
    
    @IBOutlet weak var output_label: UILabel!
    @IBOutlet weak var table: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = friends[indexPath.row]
        return cell
    }
    
    @IBAction func view_requests(_ sender: Any) {
        self.performSegue(withIdentifier: "view_requests", sender: [])
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true) {
            print("Friends dismissed.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func refresh(_ sender: Any) {
        update_user(username: String(describing: global_user["username"]!))
        
        if let temp_friends = global_user["friends"] as? [String] {
            friends = temp_friends
            output_label.text = "\(friends.count) friends"
        }
        else {
            output_label.text = "Could not fetch friends."
        }
        
        table.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        update_user(username: String(describing: global_user["username"]!))
        
        if let temp_friends = global_user["friends"] as? [String] {
            friends = temp_friends
            output_label.text = "\(friends.count) friends"
        }
        else {
            output_label.text = "Could not fetch friends."
        }
        
        table.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

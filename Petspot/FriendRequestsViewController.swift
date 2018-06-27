//
//  FriendRequestsViewController.swift
//  Petspot
//
//  Created by Athanasios on 27/06/2018.
//  Copyright © 2018 Athanasios. All rights reserved.
//

import UIKit

class FriendRequestsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var friend_requests = [String]()
    @IBOutlet weak var table: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friend_requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = friend_requests[indexPath.row]
        return cell
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true) {
            print("Friend requests dismissed.")
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        update_user(username: String(describing: global_user["username"]!))
        
        if let temp_friend_requests = global_user["friend_requests"] as? [String] {
            friend_requests = temp_friend_requests
        }
        
        table.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        update_user(username: String(describing: global_user["username"]!))
        
        if let temp_friend_requests = global_user["friend_requests"] as? [String] {
            friend_requests = temp_friend_requests
        }
        
        table.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

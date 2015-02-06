//
//  AccountViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/06.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class AccountViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        user = User.MR_findFirst() as User
    }
}

//extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 2
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        }
//        
//        return friends.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCellWithIdentifier("SearchBarCell", forIndexPath: indexPath) as UITableViewCell
//            return cell
//        }
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as UITableViewCell
//        
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//    }
//}

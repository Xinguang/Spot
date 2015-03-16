//
//  GenderSelectViewController.swift
//  spot
//
//  Created by 張志華 on 2015/03/06.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class GenderSelectViewController: UITableViewController {

    var user: User!
    
    @IBOutlet weak var mCell: UITableViewCell!
    @IBOutlet weak var fCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        mCell.accessoryType = .None
        fCell.accessoryType = .None
        
        if let gender = user.gender {
            if gender == "M" {
                mCell.accessoryType = .Checkmark
            }
            
            if gender == "F" {
                fCell.accessoryType = .Checkmark
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let org = user.gender
        
        if indexPath.row == 0 {
            user.gender = "M"
        } else {
            user.gender = "F"
        }
        
        if user.gender != org {
            UserController.saveUser(user)
            ParseController.updateUser(user, done: { (err) -> Void in
            })
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}

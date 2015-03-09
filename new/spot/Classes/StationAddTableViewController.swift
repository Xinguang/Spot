//
//  StationAddTableViewController.swift
//  spot
//
//  Created by 張志華 on 2015/03/06.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class StationAddTableViewController: UITableViewController {

    @IBOutlet weak var nameLabel: UITextField!
    
    var newStationName: String?

    var user: User! {
        return XMPPManager.instance.account
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Action
    
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func save(sender: AnyObject) {
        if nameLabel.text.trimmed().length > 0 {
            newStationName = nameLabel.text.trimmed()
//            newStation = PFObject(className: "Station")
//
//            newStation!["name"] = nameLabel.text.trimmed()
//
//            // TODO: lat lon
//
//            ParseController.addStationToUser(newStation!, user: user)
//            UserController.addStationToUser(newStation!, user: user)
//            UserController.saveUser(user)

            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}

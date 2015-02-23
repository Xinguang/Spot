//
//  AccountEditViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/22.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class AccountEditViewController: UITableViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var stationLabel: UILabel!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userImage.image = user.avatarImage()
        nameLabel.text = user.displayName
        idLabel.text = user.username
//        sexLabel.text = 
//        stationLabel.text = 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

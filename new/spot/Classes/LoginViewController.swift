//
//  LoginViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/04.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }

    // MARK: - Action
    
    @IBAction func skipBtnTapped(sender: AnyObject) {
        SVProgressHUD.show()
        
        User.signInComplete { (error) -> Void in
            SVProgressHUD.dismiss()
            
            if let error = error {
                println(error.localizedDescription)
            } else {
                self.performSegueWithIdentifier("SegueTabBar", sender: nil)
            }
        }
    }
    
    @IBAction func debug(sender: AnyObject) {
        User.removeUser()
    }

}

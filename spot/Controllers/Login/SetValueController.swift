//
//  SetValueController.swift
//  spot
//
//  Created by Hikaru on 2014/12/17.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit

class SetValueController:UIViewController{
    
    @IBOutlet var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.becomeFirstResponder()
        
        self.textField.addTarget(self, action: Selector("endEdit:"), forControlEvents: UIControlEvents.EditingDidEndOnExit)
    }
    
    
    func endEdit(sender:AnyObject){
        sender.resignFirstResponder()
        self.performSegueWithIdentifier("unwindToSegue", sender: self)
    }
}
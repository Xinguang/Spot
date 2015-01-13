//
//  PostController.swift
//  spot
//
//  Created by Hikaru on 2014/12/05.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit

class PostController:UIViewController {
    
    @IBOutlet var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.becomeFirstResponder()
        
        var b = UIBarButtonItem(title: "送信", style: .Plain, target: self, action: Selector("openSend:"))
        self.navigationItem.rightBarButtonItem = b
    }
    
    func openSend(sender:AnyObject){
        self.textView.resignFirstResponder()
        self.navigationController?.popViewControllerAnimated(false);
    }
}
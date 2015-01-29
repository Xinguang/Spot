//
//  RightController.swift
//  spot
//
//  Created by Hikaru on 2014/11/25.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//
import UIKit

class RightController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CommonHelper.instance.debugTextView = UITextView(frame: CGRectMake(DEVICE_WIDTH - 220 , 30, 220, self.view.frame.height))
        CommonHelper.instance.debugTextView?.textAlignment = NSTextAlignment.Right
        self.view.addSubview(CommonHelper.instance.debugTextView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


//
//  SideController.swift
//  spot
//
//  Created by Hikaru on 2014/11/26.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit

class SideController: JASidePanelController {
    
    override func awakeFromNib(){
        super.awakeFromNib()
        self.leftPanel = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("view_left") as UIViewController
        self.centerPanel = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("view_main") as UIViewController
        self.rightPanel = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("view_right") as UIViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        if(SettingHelper.instance.isRegistered()){
        }else{
        self.centerPanel = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("loginView") as UITabBarController
        }
        */
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


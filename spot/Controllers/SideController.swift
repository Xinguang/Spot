//
//  SideController.swift
//  spot
//
//  Created by Hikaru on 2014/11/26.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit
class SideController: DrawerController {
    override func awakeFromNib(){
        super.awakeFromNib()
        self.needSwipeShowMenu = true
        self.leftViewShowWidth = UIScreen.mainScreen().bounds.width-50
        
        self.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("view_main") as? UIViewController
        /*
        let left = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("view_left") as? LeftController;
        left?.drawerController = self
        self.leftViewController = left
        */
        //self.rightViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("view_right") as? UIViewController
        
        
    }
}
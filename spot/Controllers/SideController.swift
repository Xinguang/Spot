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
        self.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("view_main") as? UIViewController
        self.leftViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("view_left") as? UIViewController
        self.rightViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("view_right") as? UIViewController
        self.needSwipeShowMenu = true
    }
}
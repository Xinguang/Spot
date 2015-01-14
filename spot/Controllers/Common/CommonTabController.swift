//
//  CommonTabController.swift
//  spot
//
//  Created by Hikaru on 2014/12/19.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit
class CommonTabController:UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        var tabbar = self.tabBar as CustomTabBar;
        /*
        tabBar.translucent = true;
        
        tabBar.alpha = 0.8;
        */
        self.delegate = tabbar
        
        tabBar.barTintColor = CommonHelper.instance.UIColorFromRGB(0xFFE6CC, alpha: 0.2)
        
        tabbar.cursorBackgroundColor = CommonHelper.instance.UIColorFromRGB(0xE0FFE0, alpha: 0.5)
        tabbar.tintColor = UIColor.orangeColor()
    }
}
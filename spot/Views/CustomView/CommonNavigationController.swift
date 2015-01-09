//
//  CommonNavigationController.swift
//  spot
//
//  Created by Hikaru on 2015/01/09.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//
import UIKit

class CommonNavigationController:UINavigationController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let view: UIViewController = segue.destinationViewController as UIViewController
        view.hidesBottomBarWhenPushed = true
        
    }
    
}
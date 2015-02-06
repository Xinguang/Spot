//
//  TabBarController.swift
//  spot
//
//  Created by 張志華 on 2015/02/04.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    let storyBoardNames = ["Talk","Map","Contact","Account"]
    let tabImageNames = ["tabbar_mainframe","tabbar_discover","tabbar_contacts","tabbar_me"]
    let tabImageNamesHL = ["tabbar_mainframeHL","tabbar_discoverHL","tabbar_contactsHL","tabbar_meHL"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
        
        self.navigationItem.hidesBackButton = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        println("[\(String.fromCString(object_getClassName(self))!)][\(__FUNCTION__)]")
    }
    
    private func setupViewControllers() {
        var viewControllers = [UIViewController]()
        
        storyBoardNames.each { (i, name) -> () in
            let vc = Util.createViewControllerWithIdentifier(nil, storyboardName: name)
            vc.tabBarItem = UITabBarItem(title: vc.title, image: UIImage(named: self.tabImageNames[i]), selectedImage: UIImage(named: self.tabImageNamesHL[i]))
            viewControllers.append(vc)
        }
        
        self.viewControllers = viewControllers
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

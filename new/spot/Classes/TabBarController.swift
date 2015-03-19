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
        
        self.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("enterMessageViewController:"), name:kXMPPEnterMessageViewController, object: nil)

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
    
    // MARK: - Navigation

    func enterMessageViewControllerWithPUser(pUser: PFObject) {        
        selectedIndex = 0
        
        let talkVC = (selectedViewController as UINavigationController).topViewController as TalkViewController
        Util.enterMessageViewControllerWithPUser(pUser, from: talkVC)
    }

}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if viewController is UINavigationController {
            if (viewController as UINavigationController).topViewController is ContactDetailViewController {
                (viewController as UINavigationController).popViewControllerAnimated(false)
            }
        }
        
        return true
    }
}

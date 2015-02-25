//
//  Util.swift
//  spot
//
//  Created by 張志華 on 2015/02/04.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class Util: NSObject {
    
    class func createViewControllerWithIdentifier(id: String?, storyboardName: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let id = id {
            return storyboard.instantiateViewControllerWithIdentifier(id) as UIViewController
        }
        
        return storyboard.instantiateInitialViewController() as UIViewController
    }
    
    class func createViewWithNibName(name: String) -> UIView {
        return UINib(nibName: name, bundle: nil).instantiateWithOwner(self, options: nil)[0] as UIView
    }
 
    class func enterMessageViewControllerWithFriend(roster: XMPPUserCoreDataStorageObject, from: UIViewController) {
        // TODO: setAllMessagesRead
        let messageViewController = Util.createViewControllerWithIdentifier(nil, storyboardName: "Message") as MessageViewController
        
        //        let messageViewController = MessageViewController()
        messageViewController.roster = roster
//        friend.setAllMessagesRead()
        
        from.navigationController?.pushViewController(messageViewController, animated: true)
    }
    
    class func checkPermissions() {
        if !canSendNotifications() {
            let settings = UIUserNotificationSettings(forTypes: .Badge | .Sound | .Alert,categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        }
    }
    
    class func canSendNotifications() -> Bool {
        let notificationSettings = UIApplication.sharedApplication().currentUserNotificationSettings()
        return notificationSettings.types == .Badge | .Sound | .Alert
    }
}

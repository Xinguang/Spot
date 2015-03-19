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
 
    class func enterMessageViewControllerWithJid(jid: XMPPJID, from: UIViewController) {
        if let user = XMPPManager.instance.userForJID(jid) {
            enterMessageViewControllerWithFriend(user, from: from)
        }
    }
    
    class func enterMessageViewControllerWithFriend(roster: XMPPUserCoreDataStorageObject, from: UIViewController) {
        // TODO: setAllMessagesRead
        let messageViewController = Util.createViewControllerWithIdentifier(nil, storyboardName: "Message") as MessageViewController
        
        //        let messageViewController = MessageViewController()
        messageViewController.jidStr = roster.jidStr
//        friend.setAllMessagesRead()
        
        from.navigationController?.pushViewController(messageViewController, animated: true)
    }
    
    class func enterGroupMessageViewController(jidStr: String, from: UIViewController) {
        let messageViewController = Util.createViewControllerWithIdentifier("GroupMessageViewController", storyboardName: "Message") as GroupMessageViewController
        
        messageViewController.jidStr = jidStr
        
        from.navigationController?.pushViewController(messageViewController, animated: true)
    }
    
    class func enterFriendDetailViewController(jid: XMPPJID, username: String?, from: UIViewController, isTalking: Bool) {
        let vc = Util.createViewControllerWithIdentifier("ContactDetailViewController", storyboardName: "Common") as ContactDetailViewController
        vc.jid = jid
        vc.username = username
        
        vc.isFromMessageViewController = isTalking
        
        from.navigationController?.pushViewController(vc, animated: true)
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

extension UIApplication {
    
    class func appVersion() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as String
    }
    
    class func appBuild() -> String {
        return NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as NSString) as String
    }
    
    class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
        
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
}

extension XMPPRoomMessageCoreDataStorageObject: JSQMessageData {
    public func senderId() -> String! {
        return ""
//        if isOutgoing {
//            return streamBareJidStr
//        }
//        return bareJidStr
    }
    
    public func senderDisplayName() -> String! {
        return "ユーザー名"
    }
    
    public func date() -> NSDate! {
        return NSDate()
    }
    
    public func isMediaMessage() -> Bool {
        return false
    }
    
    public func text() -> String! {
        return body
    }
}

extension XMPPMessageArchiving_Message_CoreDataObject: JSQMessageData {
    
    public func senderId() -> String! {
        if isOutgoing {
            return streamBareJidStr
        }
        return bareJidStr
    }
    
    public func senderDisplayName() -> String! {
        return "ユーザー名"
    }

    public func date() -> NSDate! {
        return timestamp
    }
    
    public func isMediaMessage() -> Bool {
        return false
    }
    
    public func text() -> String! {
        return body
    }
    
}
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
    
    class func enterMessageViewControllerWithPUser(pUser: PFObject, avatarImageData: NSData?, from: UIViewController) {
        let messageViewController = Util.createViewControllerWithIdentifier(nil, storyboardName: "Message") as MessageViewController
        
        messageViewController.pUser = pUser
        messageViewController.avatarImageData = avatarImageData
        
        from.navigationController?.pushViewController(messageViewController, animated: true)
    }
 
//    class func enterMessageViewControllerWithJid(jid: XMPPJID, from: UIViewController) {
//        if let user = XMPPManager.instance.userForJID(jid) {
//            enterMessageViewControllerWithFriend(user, from: from)
//        }
//    }
    
//    class func enterMessageViewControllerWithFriend(roster: XMPPUserCoreDataStorageObject, from: UIViewController) {
//        // TODO: setAllMessagesRead
//        let messageViewController = Util.createViewControllerWithIdentifier(nil, storyboardName: "Message") as MessageViewController
//        
//        //        let messageViewController = MessageViewController()
//        messageViewController.jidStr = roster.jidStr
////        friend.setAllMessagesRead()
//        
//        from.navigationController?.pushViewController(messageViewController, animated: true)
//    }
    
    class func enterGroupMessageViewController(jidStr: String, from: UIViewController) {
//        let messageViewController = Util.createViewControllerWithIdentifier("GroupMessageViewController", storyboardName: "Message") as GroupMessageViewController
//        
//        messageViewController.jidStr = jidStr
//        
//        from.navigationController?.pushViewController(messageViewController, animated: true)
    }
    
    //from search
    class func enterFriendDetailViewController(pUser: PFObject, from: UIViewController, isTalking: Bool) {
        let vc = Util.createViewControllerWithIdentifier("ContactDetailViewController", storyboardName: "Common") as ContactDetailViewController
        vc.pUser = pUser
        
        vc.isFromMessageViewController = isTalking
        
        from.navigationController?.pushViewController(vc, animated: true)
    }
    
//    //from contact list
//    class func enterFriendDetailViewController(roster: XMPPUserCoreDataStorageObject, from: UIViewController, isTalking: Bool) {
//        let vc = Util.createViewControllerWithIdentifier("ContactDetailViewController", storyboardName: "Common") as ContactDetailViewController
//        vc.roster = roster
//        
//        vc.isFromMessageViewController = isTalking
//        
//        from.navigationController?.pushViewController(vc, animated: true)
//    }
    
    
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
    
    class func avatarImageWithImage(orgImage: UIImage, diameter: UInt) -> UIImage? {
        var data = UIImagePNGRepresentation(orgImage)
        
        return avatarImageWithData(data, diameter: diameter)
    }
    
    class func avatarImageWithData(data: NSData?, diameter: UInt) -> UIImage? {
        var orgImage: UIImage?
        
        if let data = data {
            orgImage = UIImage(data: data)
        } else {
            orgImage = UIImage(named: "avatar")
        }
        
        let image = JSQMessagesAvatarImageFactory.avatarImageWithImage(orgImage, diameter: diameter)
        
        return image.avatarImage
    }
    
    class func showTodo() {
        SVProgressHUD.showInfoWithStatus("TODO", maskType: .Clear)
    }
    
    class func showError(error: NSError) {
        SVProgressHUD.showErrorWithStatus(error.localizedDescription, maskType: .Clear)
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
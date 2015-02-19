//
//  DatabaseRosterStorage.swift
//  spot
//
//  Created by 張志華 on 2015/02/13.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class DatabaseRosterStorage: NSObject {
    
//    func existsBuddyWithJID(jid: XMPPJID, stream: XMPPStream) {
//        User.userForStream(stream)
//    }
}

extension DatabaseRosterStorage: XMPPRosterStorage {
    
    func configureWithParent(aParent: XMPPRoster!, queue: dispatch_queue_t!) -> Bool {
        return true
    }
    
    func beginRosterPopulationForXMPPStream(stream: XMPPStream!) {
        
    }
    
    func endRosterPopulationForXMPPStream(stream: XMPPStream!) {
        
    }
    
    func handleRosterItem(item: DDXMLElement!, xmppStream stream: XMPPStream!) {
        let jidStr = item.attributeStringValueForName("jid")
//        let jid = XMPPJID.jidWithString(jidStr)
        
        // TODO:
//        let jid = XMPPJID.jidWithString(jidStr).bareJID()
//        
//        if jid.bare() == stream.myJID.bare() {
//            //自分
//            return
//        }
        
        var friend = Friend.MR_findFirstByAttribute("accountName", withValue: jidStr) as? Friend
        if friend == nil {
            friend = Friend.MR_createEntity() as? Friend
            friend?.accountName = jidStr
            
            MagicalRecord.saveUsingCurrentThreadContextWithBlock({ (oc) -> Void in
                var localUser = XMPPManager.instance.account.MR_inContext(oc) as User
//                f.displayName = item.attributeStringValueForName("name")
//                f.pendingApproval = self.isPendingApprovalElement(item)
//    
                friend?.user = localUser
            }, completion: nil)
        }
        
//        let subscription = item.attributeStringValueForName("subscription")
//        
//        if subscription == "remove" {
//            // TODO:
//        } else {
//            if let f = friend {
//                updateFriendWithItem(f, item: item)
//            }
//        }
        
        
    }
    
//    func updateFriendWithItem(f: Friend, item: DDXMLElement) {
//        MagicalRecord.saveUsingCurrentThreadContextWithBlock({ (oc) -> Void in
//            var localUser = XMPPManager.instance.account.MR_inContext(oc) as User
//            f.displayName = item.attributeStringValueForName("name")
//            f.pendingApproval = self.isPendingApprovalElement(item)
//            
//            f.user = localUser
//        }, completion: nil)
//    }
//    
//    func isPendingApprovalElement(item: DDXMLElement) -> Bool {
//        let subscription = item.attributeStringValueForName("subscription")
//        let ask = item.attributeStringValueForName("ask")
//        
//        if subscription == "none" || subscription == "from" {
//            // TODO: 
//            if ask == nil || ask == "subscribe" {
//                return true
//            }
//        }
//        
//        return false
//    }
    
    func handlePresence(presence: XMPPPresence!, xmppStream stream: XMPPStream!) {
        
    }
    
    func userExistsWithJID(jid: XMPPJID!, xmppStream stream: XMPPStream!) -> Bool {
        if let f = Friend.MR_findFirstByAttribute("accountName", withValue: jid.bareJID().bare()) as? Friend {
            return true
        }
        
        return false
    }
    
    func clearAllResourcesForXMPPStream(stream: XMPPStream!) {
        
    }
    
    func clearAllUsersAndResourcesForXMPPStream(stream: XMPPStream!) {
        
    }
    
    func jidsForXMPPStream(stream: XMPPStream!) -> [AnyObject]! {
        var jids = [String]()
        
        var friends = Friend.MR_findAll() as [Friend]
        for friend in friends {
            jids.append(friend.accountName!)
        }
        
        return jids
    }
}

//
//  GroupMessageViewController.swift
//  spot
//
//  Created by 張志華 on 2015/03/12.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class GroupMessageViewController: MessageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadMessage() {
        frc = XMPPRoomMessageCoreDataStorageObject.MR_fetchAllGroupedBy(nil, withPredicate: NSPredicate(format: "roomJIDStr=%@", argumentArray: [jidStr]), sortedBy: "localTimestamp", ascending: true, inContext: XMPPManager.roomContext)
        frc.delegate = self
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        if let room = XMPPManager.instance.joinedRooms[jidStr] {
            room.sendMessageWithBody(text)
            
            self.finishSendingMessageAnimated(true)
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messageAtIndexPath(indexPath) as XMPPRoomMessageCoreDataStorageObject
        
        if message.senderId() == senderId {
            return nil
        }
        
        if indexPath.item - 1 > 0 {
            let preMessage = messageAtIndexPath(NSIndexPath(forItem: indexPath.item - 1, inSection: 0))
            
            if preMessage.senderId() == message.senderId() {
                return nil
            }
        }
        
        let nickName = message.message.from().resource
        
        return NSAttributedString(string: nickName)
    }
}

extension GroupMessageViewController: JSQMessagesCollectionViewDelegateFlowLayout {
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, atIndexPath indexPath: NSIndexPath!) {
        // TODO: 
        SVProgressHUD.showInfoWithStatus("TODO", maskType: .Clear)
    }
}


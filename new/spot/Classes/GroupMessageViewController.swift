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
    
    override func reloadUI() {
        
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        if let room = XMPPManager.instance.joinedRooms[jidStr] {
            room.sendMessageWithBody(text)
            
            self.finishSendingMessageAnimated(true)
        }
    }
    
}

extension GroupMessageViewController: JSQMessagesCollectionViewDelegateFlowLayout {
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, atIndexPath indexPath: NSIndexPath!) {
        // TODO: 
        SVProgressHUD.showInfoWithStatus("TODO", maskType: .Clear)
    }
}


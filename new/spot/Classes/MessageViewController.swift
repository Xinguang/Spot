//
//  MessageViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/18.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class MessageViewController: JSQMessagesViewController {

    var friend: Friend!
    
    var meImage: JSQMessagesAvatarImage!
    var friendImage: JSQMessagesAvatarImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.frame = self.view.bounds
        
        self.title = "友人の名前"
        
//        let meImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials("我", backgroundColor: UIColor(white: 0.85, alpha: 1.0), textColor: UIColor(white: 0.6, alpha: 1.0), font: UIFont.systemFontOfSize(14), diameter: kJSQMessagesCollectionViewAvatarSizeDefault)

        self.meImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "user2.jpg"), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        self.friendImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "user1.jpg"), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - JSQMessagesViewController method overrides
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let message = SpotMessage.MR_createEntity() as SpotMessage
        
        message.text = text
        message.read = true as Bool
        
        message.friend = self.friend
        self.friend.lastMessageDate = message.createAt
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion { (b, error) -> Void in
            XMPPManager.instance.sendMessage(message)
            
            self.finishSendingMessageAnimated(true)
        }
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

// MARK: - CollectionView

extension MessageViewController: UICollectionViewDataSource {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.friend.messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as JSQMessagesCollectionViewCell
        
        let message = self.friend.messages[indexPath.item] as SpotMessage
        
        if message.isMediaMessage() == false {
            if message.senderId() == self.senderId {
                cell.textView.textColor = UIColor.blackColor()
            } else {
                cell.textView.textColor = UIColor.whiteColor()
            }
        }
        
        cell.textView.linkTextAttributes = [NSForegroundColorAttributeName : cell.textView.textColor,
            NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue | NSUnderlineStyle.PatternDash.rawValue]
        return cell
    }
    
}
// MARK: - JSQMessagesCollectionViewDataSource

extension MessageViewController: JSQMessagesCollectionViewDataSource {
    func senderDisplayName() -> String! {
        return "me";
    }
    
    func senderId() -> String! {
        return XMPPManager.instance.account.username;
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.friend.messages[indexPath.item] as SpotMessage
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = self.friend.messages[indexPath.item] as SpotMessage
        
        if message.senderId() == self.senderId {
            return self.meImage
        }
        
        return self.friendImage
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = self.friend.messages[indexPath.item] as SpotMessage
        if message.senderId() == self.senderId {
            return bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        }
        
        return bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    }
    
}

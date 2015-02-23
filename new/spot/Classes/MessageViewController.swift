//
//  MessageViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/18.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class MessageViewController: JSQMessagesViewController {

    var roster: XMPPUserCoreDataStorageObject!
    
    var meImage: JSQMessagesAvatarImage!
    var friendImage: JSQMessagesAvatarImage!
    
    var frc: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reloadUI"), name: kXMPPDidReceivevCardTemp, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reloadUI"), name: kXMPPDidReceiveAvata, object: nil)
        
        self.collectionView.frame = self.view.bounds
        
        reloadUI()
        
//        let meImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials("我", backgroundColor: UIColor(white: 0.85, alpha: 1.0), textColor: UIColor(white: 0.6, alpha: 1.0), font: UIFont.systemFontOfSize(14), diameter: kJSQMessagesCollectionViewAvatarSizeDefault)

        self.meImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "user2.jpg"), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        self.friendImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "user1.jpg"), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
        frc = XMPPMessageArchiving_Message_CoreDataObject.MR_fetchAllGroupedBy(nil, withPredicate: NSPredicate(format: "bareJidStr=%@", argumentArray: [roster.jidStr]), sortedBy: "timestamp", ascending: true, inContext: XMPPManager.instance.xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext)
        frc.delegate = self
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

//        self.friend.addObserver(self, forKeyPath: "messages", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.friend.removeObserver(self, forKeyPath: "messages")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Notification
    
    func reloadUI() {
        if let vCard = XMPPManager.instance.xmppvCardTempModule.vCardTempForJID(roster.jid, shouldFetch: true) {
            self.title = vCard.formattedName ?? roster.jidStr
            XMPPManager.instance.xmppvCardTempModule.fetchvCardTempForJID(roster.jid, ignoreStorage:true)
        } else {
            self.title = roster.jidStr
        }
        
        
    }
    
    // MARK: - JSQMessagesViewController method overrides
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        XMPPManager.instance.sendMessage(text, to: roster.jid)
        
        self.finishSendingMessageAnimated(true)
        
//        let message = SpotMessage.MR_createEntity() as SpotMessage
//        
//        message.text = text
//        message.read = true as Bool
//        
//        message.friend = self.friend
//        self.friend.lastMessageDate = message.createAt
//        
//        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion { (b, error) -> Void in
//            XMPPManager.instance.sendMessage(message)
//            
//            self.finishSendingMessageAnimated(true)
//        }
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        println()
    }
    
//    // MARK: - KVO
//    
//    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
//        if keyPath == "messages" {
//            self.collectionView.reloadData()
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

// MARK: - CollectionView

extension MessageViewController: UICollectionViewDataSource {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frc.sections![section].numberOfObjects
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as JSQMessagesCollectionViewCell
        
        let message = frc.objectAtIndexPath(indexPath) as XMPPMessageArchiving_Message_CoreDataObject
        
//        let message = self.friend.messages[indexPath.item] as SpotMessage
        
//        if message.isMediaMessage() == false {
            if message.senderId() == self.senderId {
                cell.textView.textColor = UIColor.blackColor()
            } else {
                cell.textView.textColor = UIColor.whiteColor()
            }
//        }
        
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
        return frc.objectAtIndexPath(indexPath) as XMPPMessageArchiving_Message_CoreDataObject
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = frc.objectAtIndexPath(indexPath) as XMPPMessageArchiving_Message_CoreDataObject
        
        if message.senderId() == self.senderId {
            return self.meImage
        }
        
        return self.friendImage
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = frc.objectAtIndexPath(indexPath) as XMPPMessageArchiving_Message_CoreDataObject
        if message.senderId() == self.senderId {
            return bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        }
        
        return bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate

extension MessageViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView.reloadData()
    }
}

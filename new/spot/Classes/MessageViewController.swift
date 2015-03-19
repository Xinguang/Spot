//
//  MessageViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/18.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class MessageViewController: JSQMessagesViewController {
    var pUser: PFObject!
    
    var jidStr: String! {
        return pUser["openfireId"] as String
    }
    
    var jid: XMPPJID! {
        return XMPPJID.jidWithString(jidStr)
    }

    var meImage: JSQMessagesAvatarImage!
    var friendImage: JSQMessagesAvatarImage!
    
    var frc: NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let friend = Friend(ofJid: jidStr)
        if friend != nil {
            friend.unreadMessagesValue = 0
            friend.managedObjectContext?.MR_saveToPersistentStoreWithCompletion(nil)
        }
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reloadUI"), name: kXMPPDidReceivevCardTemp, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reloadUI"), name: kXMPPDidReceiveAvata, object: nil)

//        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
//        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero

        showLoadEarlierMessagesHeader = true

        reloadUI()
        
//        let meImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials("我", backgroundColor: UIColor(white: 0.85, alpha: 1.0), textColor: UIColor(white: 0.6, alpha: 1.0), font: UIFont.systemFontOfSize(14), diameter: kJSQMessagesCollectionViewAvatarSizeDefault)
        
        self.meImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(XMPPManager.instance.account.avatarImage(), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
        let rosterImage = XMPPManager.instance.photoOfJid(jid)
        self.friendImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(rosterImage, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
        loadMessage()
    }

    func loadMessage() {
        frc = XMPPMessageArchiving_Message_CoreDataObject.MR_fetchAllGroupedBy(nil, withPredicate: NSPredicate(format: "bareJidStr=%@", argumentArray: [jidStr]), sortedBy: "timestamp", ascending: true, inContext: XMPPManager.instance.xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext)
        frc.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func messageAtIndexPath(indexPath: NSIndexPath) -> JSQMessageData {
        return frc.objectAtIndexPath(indexPath) as JSQMessageData
    }
    
    // MARK: - Notification
    
    func reloadUI() {

        
//        if let vCard = XMPPManager.instance.xmppvCardTempModule.vCardTempForJID(jid, shouldFetch: true) {
//            self.title = vCard.formattedName ?? jid.user
//            XMPPManager.instance.xmppvCardTempModule.fetchvCardTempForJID(roster.jid, ignoreStorage:true)
//        } else {
//            self.title = jid.user
//        }
    }
    
    // MARK: - JSQMessagesViewController method overrides
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        XMPPManager.instance.sendMessage(text, to: jid)

        self.finishSendingMessageAnimated(true)
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
        
        let message = messageAtIndexPath(indexPath)
        
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
        return XMPPManager.instance.account.openfireId;
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messageAtIndexPath(indexPath)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messageAtIndexPath(indexPath)
        
        if message.senderId() == self.senderId {
            return self.meImage
        }
        
        return self.friendImage
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messageAtIndexPath(indexPath)
        if message.senderId() == self.senderId {
            return bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        }
        
        return bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if indexPath.item % 3 == 0 {
            let message = messageAtIndexPath(indexPath)
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date())
        }
        
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messageAtIndexPath(indexPath)
        
        if message.senderId() == senderId {
            return nil
        }
        
        if indexPath.item - 1 > 0 {
            let preMessage = messageAtIndexPath(NSIndexPath(forItem: indexPath.item - 1, inSection: 0))
            
            if preMessage.senderId() == message.senderId() {
                return nil
            }
        }
        
        return NSAttributedString(string: XMPPManager.instance.displayNameOfJid(XMPPJID.jidWithString(message.senderId())))
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        return nil
    }
    
}

extension MessageViewController: JSQMessagesCollectionViewDelegateFlowLayout {
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messageAtIndexPath(indexPath)
        if message.senderId() == senderId {
            return 0
        }
        
        if indexPath.item - 1 > 0 {
            let preMessage = messageAtIndexPath(NSIndexPath(forItem: indexPath.item - 1, inSection: 0))
            
            if preMessage.senderId() == message.senderId() {
                return 0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 0
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, atIndexPath indexPath: NSIndexPath!) {
        SVProgressHUD.showInfoWithStatus("TODO", maskType: .Clear)
//        let message = messageAtIndexPath(indexPath)
//        let jid = XMPPJID.jidWithString(message.senderId())
//        Util.enterFriendDetailViewController(jid, username: nil, from: self, isTalking: true)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        SVProgressHUD.showInfoWithStatus("TODO", maskType: .Clear)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension MessageViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView.reloadData()
        finishReceivingMessageAnimated(true)
    }
}

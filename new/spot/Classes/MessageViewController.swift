//
//  MessageViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/18.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class MessageViewController: JSQMessagesViewController {
//    let net = Net()
    var pathDownloading = Dictionary<String, Net?>()
    
    var pUser: PFObject!
    var avatarImageData: NSData?
    
    var jidStr: String! {
        return pUser["openfireId"] as String
    }
    
    var jid: XMPPJID! {
        return XMPPJID.jidWithString(jidStr)
    }

    var meImage: JSQMessagesAvatarImage!
    var friendImage: JSQMessagesAvatarImage!
    
    var frc: NSFetchedResultsController!
    
    var icon_speaker_normal:UIImage!
    var icon_speaker_highlighted:UIImage!
    var icon_keyboard_normal:UIImage!
    var icon_keyboard_highlighted:UIImage!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "写真を送信", style: .Done, target: self, action: Selector("sendImage"))
        
        setAccessoryButtonImageView()

//        showLoadEarlierMessagesHeader = true
        
        setupAvatarImage()
        
        loadMessage()
        
        ParseController.getPUserByKeyIncludeAvatarIgnoreCache("openfireId", value: pUser["openfireId"] as String) { (pUser, data, error) -> Void in
            if let error = error {
                return
            }
            
            self.pUser = pUser
            
            if let data = data {
                let rosterImage = UIImage(data: data)
                self.friendImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(rosterImage, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
            }
            
            self.collectionView.reloadData()
        }
    }

    func setupAvatarImage() {
        self.meImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(XMPPManager.instance.account.avatarImage(), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
        var rosterImage = UIImage(named: "avatar")
        if let data = avatarImageData {
            rosterImage = UIImage(data: data)
        }
        
        self.friendImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(rosterImage, diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
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
    
    // MARK: - Action
    
    func sendImage() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "写真を撮る", style: .Default, handler: { (action) -> Void in
            let picker = UIImagePickerController()
            picker.sourceType = .Camera
            picker.allowsEditing = true
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
        })
        let albumAction = UIAlertAction(title: "写真から選択", style: .Default, handler: { (action) -> Void in
            let picker = UIImagePickerController()
            picker.sourceType = .PhotoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: { (action) -> Void in
            
        })
        
        alertController.addAction(cameraAction)
        alertController.addAction(albumAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
//        if let path = NSBundle.mainBundle().pathForResource("test", ofType: "png") {
//            XMPPManager.instance.sendLocalPhotoMessage(path, to: jid)
//        
//            self.finishSendingMessageAnimated(true)
//            
//            XMPPManager.instance.sendRemotePhotoMessage("http://sourcetreeapp.com/images/sourcetree-hero-mac-log.png", to: jid)
//        }
    }
    
    // MARK: - Notification
    
    // MARK: - JSQMessagesViewController method overrides
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        XMPPManager.instance.sendMessage(text, to: jid)

        self.finishSendingMessageAnimated(true)
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
        
        if message.isMediaMessage() == false {
            if message.senderId() == self.senderId {
                cell.textView.textColor = UIColor.blackColor()
            } else {
                cell.textView.textColor = UIColor.whiteColor()
            }
            
            cell.textView.linkTextAttributes = [NSForegroundColorAttributeName : cell.textView.textColor,
                NSUnderlineStyleAttributeName : NSUnderlineStyle.StyleSingle.rawValue | NSUnderlineStyle.PatternDash.rawValue]
        }

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
        let m = messageAtIndexPath(indexPath) as XMPPMessageArchiving_Message_CoreDataObject
        let type = m.messageType()
        
        if type != .Text {
            let path = m.pathOfMedia(m.isLocalMediaMessage())
            
            if type == .Photo {
                var image: UIImage?
                
                if let data = DatabaseManager.dataOfPath(path) {
                    image = UIImage(data: data)
                } else {
                    if m.isRemoteMediaMessage() {
                        downloadResources(path)
                    }
                }
                
                let photoItem = JSQPhotoMediaItem(image:image)
                photoItem.appliesMediaViewMaskAsOutgoing = m.isLocalMediaMessage()
                
                let photoMessage = JSQMessage(senderId: m.senderId(), senderDisplayName: m.senderDisplayName(), date: m.timestamp, media: photoItem)
                
                return photoMessage
            }
            
            if type == .Voice {
                var voice = DatabaseManager.dataOfPath(path)
                if voice == nil && m.isRemoteMediaMessage() {
                    downloadResources(path)
                }
                
                let imageName = m.isLocalMediaMessage() ? "SenderVoiceNodePlaying" : "ReceiverVoiceNodePlaying"
                
                let voiceItem = JSQVoiceMediaItem(voice: voice, image: UIImage(named: imageName))
                voiceItem.appliesMediaViewMaskAsOutgoing = m.isLocalMediaMessage()
                
                let voiceMessage = JSQMessage(senderId: m.senderId(), senderDisplayName: m.senderDisplayName(), date: m.timestamp, media: voiceItem)
                
                return voiceMessage
            }
        }
        
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
        
        var displayName = "匿名"
        if let name = pUser["displayName"] as? String {
            displayName = name
        }
        
        return NSAttributedString(string: displayName)
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
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapCellAtIndexPath indexPath: NSIndexPath!, touchLocation: CGPoint) {
        Util.showTodo()
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        let m = messageAtIndexPath(indexPath) as XMPPMessageArchiving_Message_CoreDataObject
        if m.messageType() == .Voice {
            if m.isRemoteMediaMessage() {
                VoiceController.instance.playOrStopTest()
                return
            }
            
            if let data = DatabaseManager.dataOfPath(m.pathOfMedia(m.isLocalMediaMessage())) {
                VoiceController.instance.playOrStop(data)
            }
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension MessageViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView.reloadData()
        finishReceivingMessageAnimated(true)
    }
}

// MARK: - Net

extension MessageViewController {
    
    func downloadResources(path: NSString) {

//        net.download(absoluteUrl: path, startImmediately: true, progress: { (_) -> () in
//            
//            }) { (url, error) -> () in
//                if let url = url {
//                    DatabaseManager.saveResourceAtPath(url, toPath: path, done: { () -> Void in
//                        self.collectionView.reloadData()
//                    })
//                }
//        }
        
        if pathDownloading[path] == nil {
            let net = Net()
            pathDownloading[path] = net
            
            net.GET(absoluteUrl: path, params: nil, successHandler: { (responseData) -> () in
                DatabaseManager.saveDataOfPath(path, data: responseData.data, done: { () -> Void in
                    self.collectionView.reloadData()
                    
                    self.pathDownloading[path] = nil
                })
            }) { (_) -> () in
                
            }
        }
    }
    
//    func downloadResources(path: NSString, done: (NSURL?, NSError?) -> Void) {
//        let net = Net()
//        net.download(absoluteUrl: path, startImmediately: true, progress: { (_) -> () in
//            
//        }) { (url, error) -> () in
//            done(url,error)
//        }
//    }
}

// MARK: - UIImagePickerControllerDelegate

extension MessageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {

        let smallImage = image.scaleToFitSize(CGSize(width: 500, height: 500))
        let orgImage = image.scaleToFitSize(CGSize(width: 750, height: 750))
        
        let path = NSUUID().UUIDString.lowercaseString
        DatabaseManager.saveDataOfPath(path, data: UIImagePNGRepresentation(smallImage)) { () -> Void in
            XMPPManager.instance.sendLocalPhotoMessage(path, to: self.jid)
            
            self.finishSendingMessageAnimated(true)

            // TODO: UploadToS3
            
            XMPPManager.instance.sendRemotePhotoMessage("http://lorempixel.com/500/500/?" + NSUUID().UUIDString.lowercaseString, to: self.jid)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

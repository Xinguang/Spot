//
//  RecentlyFriendCell.swift
//  spot
//
//  Created by 張志華 on 2015/02/20.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class RecentlyFriendCell: UITableViewCell {

    @IBOutlet weak var membersCountLabel: UILabel!
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var badgeBackView: UIView!
    
    var badgeView: JSBadgeView!
    
    var pUser: PFObject! {
        didSet {
            self.friendNameLabel.text = pUser["displayName"] as? String
        }
    }
    
    var avatarImageData: NSData? {
        didSet {
            self.friendImageView.image = Util.avatarImageWithData(avatarImageData, diameter: kAvatarImageSize)
        }
    }
    
    var friend: XMPPMessageArchiving_Contact_CoreDataObject! {
        didSet {
            
            if !friend.isGroupChat() {
                membersCountLabel.hidden = true
            } else {
                friendNameLabel.text = "グループ名"
//                membersCountLabel.hidden = false
                membersCountLabel.text = "\(XMPPManager.countOfRoom(friend.bareJidStr))"
            }
            
            if friend.mostRecentMessageBody.rangeOfString("[spot_local]") != nil || friend.mostRecentMessageBody.rangeOfString("[spot_remote]") != nil{
                self.messageLabel.text = "画像"
                // TODO: 音声
            } else {
                self.messageLabel.text = friend.mostRecentMessageBody
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .ShortStyle
            self.timeLabel.text = dateFormatter.stringFromDate(friend.mostRecentMessageTimestamp)
            
            if let friend = Friend.MR_findFirstByAttribute("jidStr", withValue: friend.bareJidStr) as? Friend {
                if friend.unreadMessagesValue > 0 {
                    badgeView.hidden = false
                    badgeView.badgeText = String(friend.unreadMessagesValue)
                } else {
                    badgeView.hidden = true
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        badgeView = JSBadgeView(parentView: badgeBackView, alignment: .CenterRight)
        badgeView.badgeBackgroundColor = UIColor(hexString: "#0EAA00")
    }
    
    override func prepareForReuse() {
        setupDefault()
    }

    func setupDefault() {
        membersCountLabel.hidden = true
        
        friendImageView.image = Util.avatarImageWithData(nil, diameter: kAvatarImageSize)
        friendNameLabel.text = ""
        messageLabel.text = ""
        timeLabel.text = ""
        badgeView.hidden = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension XMPPMessageArchiving_Contact_CoreDataObject {
    
    func isGroupChat() -> Bool {
        if let m = XMPPMessageArchiving_Message_CoreDataObject.MR_findFirstByAttribute("bareJidStr", withValue: self.bareJidStr, inContext: XMPPManager.instance.xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext) as? XMPPMessageArchiving_Message_CoreDataObject {
            return m.message.isGroupChatMessage()
        }
        
        return false
    }
}

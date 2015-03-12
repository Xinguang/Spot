//
//  RecentlyFriendCell.swift
//  spot
//
//  Created by 張志華 on 2015/02/20.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class RecentlyFriendCell: UITableViewCell {

    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var badgeBackView: UIView!
    
    var badgeView: JSBadgeView!
    
    var friend: XMPPMessageArchiving_Contact_CoreDataObject! {
        didSet {
            
            if !friend.isGroupChat() {
                if let vCard = XMPPManager.instance.xmppvCardTempModule.vCardTempForJID(friend.bareJid, shouldFetch: true) {
                    friendNameLabel.text = vCard.formattedName ?? friend.bareJid.user
                    
                } else {
                    friendNameLabel.text = friend.bareJid.user
                }
                
                friendImageView.image = XMPPManager.instance.photoOfJid(friend.bareJid)

            } else {
                friendNameLabel.text = "グループ名"
            }
            
            
            self.messageLabel.text = friend.mostRecentMessageBody
            
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
//            if roster?.unreadMessages as Int > 0 {
//                badgeView.hidden = false
//                badgeView.badgeText = String(roster?.unreadMessages as Int)
//            } else {
//                badgeView.hidden = true
//            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        badgeView = JSBadgeView(parentView: badgeBackView, alignment: .CenterRight)
        badgeView.badgeBackgroundColor = UIColor(hexString: "#0EAA00")
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

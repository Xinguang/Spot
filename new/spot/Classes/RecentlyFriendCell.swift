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
    
    var badgeView: JSBadgeView!
    
    var friend: XMPPMessageArchiving_Contact_CoreDataObject! {
        didSet {
//            self.friendNameLabel.text = friend.bareJidStr ?? "友人の名前"
            
            if let vCard = XMPPManager.instance.xmppvCardTempModule.vCardTempForJID(friend.bareJid, shouldFetch: true) {
                friendNameLabel.text = vCard.formattedName ?? friend.bareJidStr

            } else {
              friendNameLabel.text = friend.bareJidStr
            }
            
            
            friendImageView.image = XMPPManager.instance.photoOfJid(friend.bareJid)
            
            self.messageLabel.text = friend.mostRecentMessageBody
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .ShortStyle
            self.timeLabel.text = dateFormatter.stringFromDate(friend.mostRecentMessageTimestamp)
            
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
        
        badgeView = JSBadgeView(parentView: friendImageView, alignment: .TopRight)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

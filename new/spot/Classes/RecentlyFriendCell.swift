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
    
    var friend: Friend! {
        didSet {
            self.friendNameLabel.text = friend.displayName ?? "友人の名前"
            self.messageLabel.text = (friend.messages.lastObject as SpotMessage).text()
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .ShortStyle
            self.timeLabel.text = dateFormatter.stringFromDate(friend.lastMessageDate)
            
            if friend.numberOfUnreadMessages() > 0 {
                badgeView.hidden = false
                badgeView.badgeText = String(friend.numberOfUnreadMessages())
            } else {
                badgeView.hidden = true
            }
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

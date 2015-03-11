//
//  FriendCell.swift
//  spot
//
//  Created by 張志華 on 2015/03/10.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var friendImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var friend: XMPPUserCoreDataStorageObject! {
        didSet {
            if let vCard = XMPPManager.instance.xmppvCardTempModule.vCardTempForJID(friend.jid, shouldFetch: true) {
                nameLabel.text = vCard.formattedName ?? friend.jid.user
            } else {
                nameLabel.text = friend.jid.user
            }
            
            friendImageView.image = XMPPManager.instance.photoOfJid(friend.jid)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setChecked(checked: Bool) {
        let imageName = checked ? "friend_check_on" : "friend_check_off"
        
        checkImageView.image = UIImage(named: imageName)
    }

}

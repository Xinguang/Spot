//
//  UserCell.swift
//  spot
//
//  Created by 張志華 on 2015/02/21.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    var user: User! {
        didSet {
            userImage.image = user.avatarImage()
//            nameLabel.text = user.displayName
            
            if let vCard = XMPPManager.instance.xmppvCardTempModule.myvCardTemp {
                nameLabel.text = vCard.formattedName ?? ""
                
            } else {
                nameLabel.text = ""
            }
            // TODO: 
            let jid = XMPPJID.jidWithString(user.username)
            idLabel.text = jid.user
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

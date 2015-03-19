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
            nameLabel.text = user.displayName
            
            if user.avatarThumbnail == nil && user.snses.count > 0 {
                UserController.downloadUserAvatar(user, done: { (data) -> Void in
                    if let data = data {
                        self.user.avatarThumbnail = data
                        self.userImage.image = self.user.avatarImage()
                        UserController.saveUser(self.user)
                    } else {
                        self.userImage.image = self.user.defaultSNSImage()
                    }
                })
            }
            
            if let username = user.username {
                idLabel.text = "現場トモID:" + user.username
            }
        }
    }

}

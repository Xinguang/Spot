//
//  ContactDetailHeaderView.swift
//  spot
//
//  Created by 張志華 on 2015/02/25.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class ContactDetailHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var imageView: PFImageView!
    @IBOutlet weak var sexImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!

    var pUser: PFObject! {
        didSet {
            if let thumbnailFile = pUser["avatarThumbnail"] as? PFFile {
                
            }
            
            if let gender = pUser["gender"] as? String {
                let name = gender == "M" ? "Contact_Male" : "Contact_Female"
                sexImageView.image = UIImage(named: name)
            }
            
            nameLabel.text = pUser["displayName"] as? String
            
            var username = "未設定"
            if let idStr = pUser["username"] as? String {
                username = idStr
            }
            idLabel.text = "現場トモID:\(username)"
        }
    }
    
}

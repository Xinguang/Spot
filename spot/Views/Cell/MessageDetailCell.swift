//
//  MessageDetailCell.swift
//  spot
//
//  Created by Hikaru on 2014/12/02.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit

class MessageDetailCell:UITableViewCell{
    
    @IBOutlet var icon_friend: UIImageView!
    @IBOutlet var icon_me: UIImageView!
    
    @IBOutlet var backImage: UIImageView!
    @IBOutlet var message: UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
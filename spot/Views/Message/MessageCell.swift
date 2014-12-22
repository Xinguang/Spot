//
//  MessageCell.swift
//  spot
//
//  Created by Hikaru on 2014/11/27.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation
import UIKit

class MessageCell:UITableViewCell{
    
    @IBOutlet var icon: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var subTitleLable: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if(nil != icon){
            icon.layer.cornerRadius = 5
            icon.layer.masksToBounds = true;
        /*
            icon.layer.borderWidth = 1
            icon.layer.shadowOpacity = 0.5;
            icon.layer.shadowOffset = CGSizeMake(10, 10)
        */
        }

    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func endEdit(sender:AnyObject){
        sender.resignFirstResponder()
    }
    
}
//
//  MessageCell.swift
//  spot
//
//  Created by Hikaru on 2014/11/27.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//import UIKit

class MessageCell:UITableViewCell{
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var subTitleLable: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func endEdit(sender:AnyObject){
        sender.resignFirstResponder()
    }
    
    override func layoutSubviews() {
        self.imageView?.layer.cornerRadius = 5
        self.imageView?.layer.masksToBounds = true;
        
        /*
        self.imageView?.layer.borderWidth = 1
        self.imageView?.layer.shadowOpacity = 0.5;
        self.imageView?.layer.shadowOffset = CGSizeMake(10, 10)
        */
        let height = self.frame.size.height - 20
        let frame = CGRectMake(5, 5, height, height)
        
        self.imageView?.bounds = frame
        self.imageView?.frame = frame
        self.imageView?.contentMode = UIViewContentMode.ScaleAspectFit;
        
    }
}

//
//  BBSDetailHeaderView.swift
//  spot
//
//  Created by Hikaru on 2015/01/08.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import Foundation

class BBSDetailHeaderView: UIView {
    var userface: UIImageView!
    var username: UILabel!
    var imageView: UIImageView!
    var detailLabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        let width = UIScreen.mainScreen().bounds.size.width;
        
        userface = UIImageView(frame: CGRectMake(5, 5, 44, 44))
        userface.image = UIImage(named: "icon_wx")
        
        
        username = UILabel(frame: CGRectMake(54, 10,width - 59 , 34))
        
        imageView = UIImageView(frame: CGRectMake(5, 54, width - 10 , 100))
        imageView.image = UIImage(named: "noimage")
        
        detailLabel = UILabel(frame: CGRectMake(5, 159,width - 10 , 34))
        
        self.addSubview(userface)
        self.addSubview(username)
        self.addSubview(imageView)
        self.addSubview(detailLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
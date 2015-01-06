//
//  BBSContentModel.swift
//  spot
//
//  Created by Hikaru on 2015/01/06.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import Foundation
class BBSContentModel {
    
    let ID: Int
    let userid: Int
    let text: String
    let imagePath: String
    let sentDate: NSDate
    
    init(ID: Int,userid: Int, imagepath:String,text: String, sentDate: NSDate) {
        self.ID = ID
        self.userid = userid
        self.text = text
        self.imagePath = imagepath
        self.sentDate = sentDate
    }
}
//
//  MessageModel.swift
//  spot
//
//  Created by Hikaru on 2014/12/26.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation
class MessageModel {
    
    let ID: Int
    let userid: Int
    let text: String
    let sentDate: NSDate
    
    init(ID: Int,userid: Int, text: String, sentDate: NSDate) {
        self.ID = ID
        self.userid = userid
        self.text = text
        self.sentDate = sentDate
    }
}
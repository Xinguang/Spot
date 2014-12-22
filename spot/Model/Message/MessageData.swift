//
//  MessageData.swift
//  spot
//
//  Created by Hikaru on 2014/12/22.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

class MessageData:NSObject{
    
    var title: String = ""
    var msgRow: [MessageRow] = []
    
    init(title:String,msgRows:[MessageRow]){
        self.title = title;
        self.msgRow = msgRows;
    }
}
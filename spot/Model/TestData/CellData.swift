//
//  CellData.swift
//  spot
//
//  Created by Hikaru on 2014/12/22.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

class CellData:NSObject{
    
    var title: String = ""
    var msgRow: [CellRow] = []
    
    init(title:String,msgRows:[CellRow]){
        self.title = title;
        self.msgRow = msgRows;
    }
}
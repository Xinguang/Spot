//
//  TagModel.swift
//  spot
//
//  Created by Hikaru on 2015/01/23.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import Foundation

class TagModel{
    
    var tag_id: String?
    var tag_title: String?
    
    init() {
    }
    
    convenience init(tag_id: String, tag_title: String) {
        self.init()
        self.tag_id = tag_id
        self.tag_title = tag_title
    }
    convenience init(data:Dictionary<String, AnyObject>) {
        self.init()
        self.tag_id = data["tag_id"] as? String
        self.tag_title = data["tag_title"] as? String
    }
}
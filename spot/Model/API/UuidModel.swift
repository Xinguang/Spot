//
//  UuidModel.swift
//  spot
//
//  Created by Hikaru on 2015/01/23.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import Foundation

class UuidModel{
    
    var uuid: String?
    var device: String?
    
    init() {
    }
    
    convenience init(uuid: String, device: String) {
        self.init()
        self.uuid = uuid
        self.device = device
    }
    convenience init(data:Dictionary<String, AnyObject>) {
        self.init()
        self.uuid = data["uuid"] as? String
        self.device = data["device"] as? String
    }
}
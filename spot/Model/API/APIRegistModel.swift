//
//  APIRegistModel.swift
//  spot
//
//  Created by Hikaru on 2015/01/23.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import Foundation

class APIRegistModel:APICommonModel{
    var auth_token: String?
    
    override init(data: Dictionary<String, AnyObject>) {
        super.init(data: data)
        self.auth_token = self.result!["auth_token"] as? String
    }
}
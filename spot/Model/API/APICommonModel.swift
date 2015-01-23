//
//  APICommonModel.swift
//  spot
//
//  Created by Hikaru on 2015/01/23.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import Foundation
class APICommonModel{
    
    var errorCode: String?
    var errorMessage: String?
    var result: Dictionary<String, AnyObject>?
    
    init(data: Dictionary<String, AnyObject>) {
        self.errorCode = data["errorCode"] as? String
        self.errorMessage = data["errorMessage"] as? String
        self.result = data["result"] as? Dictionary<String, AnyObject>
    }
    
}
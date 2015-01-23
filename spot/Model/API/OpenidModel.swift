//
//  OpenidModel.swift
//  spot
//
//  Created by Hikaru on 2015/01/23.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import Foundation

class OpenidModel{
    
    var openid: String?
    var access_token: String?
    var refresh_token: String?
    var expirationDate: String?
    var type: String?
    
    init() {
    }
    
    convenience init(openid: String, access_token: String, refresh_token: String?,expirationDate:String?) {
        self.init()
        if openid =~ "^.*@(weichat|qq|mobile)$" {
            self.openid = openid
            self.access_token = access_token
            self.refresh_token = refresh_token
            self.expirationDate = expirationDate
        }
    }
    convenience init(data:Dictionary<String, AnyObject>) {
        self.init()
        self.openid = data["openid"] as? String
        self.access_token = data["access_token"] as? String
        self.refresh_token = data["refresh_token"] as? String
        self.expirationDate = data["expirationDate"] as? String
        
        if self.openid! =~ "^.*@(weichat|qq|mobile)$" {
            self.type = self.openid?.replace("^.*@(weichat|qq|mobile)$", template: "$1")
        }
    }
    func isWeixin() ->Bool{
        return self.openid! =~ "^.*@weichat$"
    }
    func isQQ() ->Bool{
        return self.openid! =~ "^.*@qq$"
    }
    func isMobile() ->Bool{
        return self.openid! =~ "^.*@mobile$"
    }
}
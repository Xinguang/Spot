//
//  APIAuthModel.swift
//  spot
//
//  Created by Hikaru on 2015/01/23.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import Foundation

class APIAuthModel:APICommonModel{
    
    var figure: String?
    var nickname: String?
    var sex: String?
    var birthday: String?
    var auth_token: String?
    var openidlist: [OpenidModel]?
    var taglist: [TagModel]?
    var uuidlist: [UuidModel]?
    
    override init(data: Dictionary<String, AnyObject>) {
        super.init(data: data)
        
        self.figure = self.result!["figure"] as? String
        self.nickname = self.result!["nickname"] as? String
        self.sex = self.result!["sex"] as? String
        self.birthday = self.result!["birthday"] as? String
        self.auth_token = self.result!["auth_token"] as? String
        
        self.setOpenidList()
        self.setTagList()
        self.setUuidList()
        SettingHelper.instance.setAuthData(self)
    }
    private func setOpenidList(){
        if let dictlist = self.result!["openidlist"] as? [Dictionary<String, AnyObject>] {
            self.openidlist = [];
            for dict in dictlist{
                self.openidlist?.append(OpenidModel(data: dict))
            }
        }
    }
    private func setTagList(){
        if let dictlist = self.result!["taglist"] as? [Dictionary<String, AnyObject>] {
            self.taglist = [];
            for dict in dictlist{
                self.taglist?.append(TagModel(data: dict))
            }
        }
    }
    private func setUuidList(){
        if let dictlist = self.result!["uuidlist"] as? [Dictionary<String, AnyObject>] {
            self.uuidlist = [];
            for dict in dictlist{
                self.uuidlist?.append(UuidModel(data: dict))
            }
        }
    }
}
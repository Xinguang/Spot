//
//  APIAuthModel.swift
//  spot
//
//  Created by Hikaru on 2015/01/23.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import Foundation

class APIAuthModel{
    
    var figure: String?
    var nickname: String?
    var sex: String?
    var birthday: String?
    var openidlist: [OpenidModel]?
    var taglist: [TagModel]?
    var uuidlist: [UuidModel]?
    
    init(data: AnyObject?) {
        if let dict = data as? Dictionary<String, AnyObject>{
            self.figure = dict["figure"] as? String
            self.nickname = dict["nickname"] as? String
            self.sex = dict["sex"] as? String
            self.birthday = dict["birthday"] as? String
            
            self.setOpenidList(dict)
            self.setTagList(dict)
            self.setUuidList(dict)
            SettingHelper.instance.setAuthData(self)
        }
    }
    
    private func setOpenidList(data: Dictionary<String, AnyObject>){
        if let dictlist = data["openidlist"] as? [Dictionary<String, AnyObject>] {
            self.openidlist = [];
            for dict in dictlist{
                self.openidlist?.append(OpenidModel(data: dict))
            }
        }
    }
    private func setTagList(data: Dictionary<String, AnyObject>){
        if let dictlist = data["taglist"] as? [Dictionary<String, AnyObject>] {
            self.taglist = [];
            for dict in dictlist{
                self.taglist?.append(TagModel(data: dict))
            }
        }
    }
    private func setUuidList(data: Dictionary<String, AnyObject>){
        if let dictlist = data["uuidlist"] as? [Dictionary<String, AnyObject>] {
            self.uuidlist = [];
            for dict in dictlist{
                self.uuidlist?.append(UuidModel(data: dict))
            }
        }
    }
}
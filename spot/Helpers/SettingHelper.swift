//
//  SettingHelper.swift
//  spot
//
//  Created by Hikaru on 2014/11/26.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation

class SettingHelper {
    //シングルトンパターン
    class var instance: SettingHelper {
        dispatch_once(&Inner.token) {
            Inner.instance = SettingHelper()
        }
        return Inner.instance!
    }
    private struct Inner {
        static var instance: SettingHelper?
        static var token: dispatch_once_t = 0
    }
    
    
    
    private var _ud:NSUserDefaults = NSUserDefaults.standardUserDefaults();
    
    private var config:[String: AnyObject] = [
        "sys_nickname":"",
        "sys_figure_data":NSData(),
        "sys_sex":"",
        "sys_birthday":"",
        "sys_auth_token":"",
        /////////////////////////////
        ///微信///////////////////////
        /////////////////////////////
        "wx_access_token": "",
        "wx_openid": "",
        "wx_refresh_token": "",
        "wx_expires_in": "",
        "wx_unionid":"",
        /////////////////////////////
        ///QQ////////////////////////
        /////////////////////////////
        "qq_accessToken": "",
        "qq_openId": "",
        "qq_expirationDate": "",
        /////////////////////////////
        ///Mobile////////////////////
        /////////////////////////////
        "mobile_no": ""
    ];
    //初期化
    private init() {
        //NSUserDefaults？DB？API？から取得
        /*
        for (key, value) in self.config {
            if  let val: AnyObject = self._ud.objectForKey(key) {
                self.config[key] = val
            }
        }
        */
        //ud.setObject("taro", forKey: "id")
    }
    
    func set(key:String,value:AnyObject){
        if(!contains(self.config.keys, key)){ return; }
        self._ud.setObject(value, forKey: key);
        //self.config[key] = value;
    }
    
    func setList(param:Dictionary<String, AnyObject>,prefix:String){
        for (key, value) in param {
            if(!contains(self.config.keys, prefix+key)){ continue; }
            self.set(prefix+key, value: value)
        }
    }

    
    func get(key:String)->AnyObject{
        if(!contains(self.config.keys, key)){ return ""; }
        if let val: AnyObject = self._ud.objectForKey(key) {
            return val
        }
        return "";
    }
    
    
    func setAuthData(data:APIAuthModel){
        self.set("sys_auth_token", value: data.auth_token!)
        self.set("sys_nickname", value: data.nickname!)
        self.set("sys_figure", value: data.figure!)
        self.set("sys_sex", value: data.sex!)
        self.set("sys_birthday", value: data.birthday!)
        
        if let openidlist = data.openidlist {
            if openidlist.count>0{
                for openidinfo in openidlist {
                    if openidinfo.isWeixin(){
                        self.set("wx_access_token", value:openidinfo.access_token!)
                        self.set("wx_openid", value:openidinfo.openid!)
                        self.set("wx_refresh_token", value:openidinfo.refresh_token!)
                        
                    }else if openidinfo.isQQ(){
                        self.set("qq_accessToken", value:openidinfo.access_token!)
                        self.set("qq_openId", value:openidinfo.openid!)
                        self.set("qq_expirationDate", value:openidinfo.expirationDate!)
                        
                    }else if openidinfo.isMobile(){
                        self.set("mobile_no", value:openidinfo.openid!)
                    }
                }
            }
        }
        //self.set("sys_auth_token", value: data.taglist!)
        
        //self.set("sys_auth_token", value: data.uuidlist!)
    }    
}
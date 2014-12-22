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
    //登録したか
    var isRegistered:Bool = false;
    
    var config:[String: AnyObject] = [
        "uuid":"",//UUID
        
        "sys_nickname":"",
        "sys_figure_data":NSData(),
        "sys_sex":"",
        "sys_birthday":"",
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
        "qq_expirationDate": ""
    ];
    //初期化
    private init() {
        //NSUserDefaults？DB？API？から取得
        for (key, value) in self.config {
            if  let val: AnyObject = self._ud.objectForKey(key) {
                self.config[key] = val
            }
        }
        if("" == self.config["uuid"] as String){
            self.config["uuid"] = NSUUID().UUIDString;
            //注册
        }else{
            self.isRegistered = true;
        }
        
        //ud.setObject("taro", forKey: "id")
    }
    
    func set(key:String,value:AnyObject){
        if(!contains(self.config.keys, key)){ return; }
        self._ud.setObject(value, forKey: key);
        self.config[key] = value;
    }
    
    func setList(param:Dictionary<String, AnyObject>,prefix:String){
        for (key, value) in param {
            if(!contains(self.config.keys, prefix+key)){ continue; }
            self.set(prefix+key, value: value)
        }
    }

    
    func get(key:String)->AnyObject{
        if(!contains(self.config.keys, key)){ return ""; }
        return self.config[key]!;
    }
    
}
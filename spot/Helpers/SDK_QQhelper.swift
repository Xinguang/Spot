//
//  SDK_QQhelper.swift
//  spot
//
//  Created by Hikaru on 2014/11/27.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation
class SDK_QQhelper{
    class func login_qq(){
        
        let scope:String = "get_user_info,add_share";
        let appid:String = "1103493465";
        
        let bundleId:String = "sssss";//NSBundle.mainBundle().infoDictionary[kCFBundleIdentifierKey]! as String;
        let appName:String = "sss";//NSBundle.mainBundle().infoDictionary[kCFBundleNameKey as NSString]! as String;
        let device:UIDevice = UIDevice.currentDevice();
        
        let dict:Dictionary<String, String> = [
            "app_id" : appid,
            "client_id": appid,
            "app_name" : appName,
            "bundleId" : bundleId,
            "status_machine" : device.model,
            "status_os" : device.systemVersion,
            "status_version" : device.systemVersion.substringToIndex(advance(device.systemVersion.startIndex, 1)),
            "scope":scope,
            
            //目前这些不需要变
            "response_type":"token",
            //"sdkp" : "i",
            "sdkv" : "2.0",
            "jsVersion":"20080",
        ];
        
        //关键点, 把相关数据添加到系统粘贴板上
        let pbType:String = "com.tencent." + appid;
        
        
        UIPasteboard.generalPasteboard().setValue(NSKeyedArchiver.archivedDataWithRootObject(dict), forPasteboardType: pbType);
        
        let callback_uri:String = "wx810124210cb133e8";
        //拼装调用QQ的URL
        let appAuthURL:String = "mqqOpensdkSSoLogin://SSoLogin/"+callback_uri+"/"+pbType+"?generalpastboard=1";
        
        
        let URL = NSURL(string: appAuthURL);
        //打开QQ
        UIApplication.sharedApplication().openURL(URL!)
    }
    
    class func getCallbakc(url: NSURL){
        let pbname:String = "com.tencent."+url.scheme!;
        let pb:UIPasteboard = UIPasteboard.generalPasteboard();
        
        let data = pb.valueForPasteboardType(pbname) as? NSData;
        var object = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? Dictionary<String, AnyObject>;
        //var object = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as? [String: AnyObject];
        
        let vals = object?.values;
        
        
        
        if(nil != object){
            
            //NSLog("access_token:%@", access_token)
            //NSLog("access_token:%@", object["access_token"]!)
            let key1 = object?.indexForKey("access_token");
            let key2 = object?.indexForKey("expires_in");
            let key3 = object?.indexForKey("openid");
            
            /*
            
            let access_token = object[object?.indexForKey("access_token")]!;
            let expires_in = object[object?.indexForKey("expires_in")]!;
            let openid = object[object?.indexForKey("openid")]!;
            
            NSLog("access_token:%@", access_token)
            NSLog("expires_in:%@", expires_in)
            NSLog("openid:%@", openid)
            */
            
        }

    }
}
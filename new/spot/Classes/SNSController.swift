//
//  SNSController.swift
//  spot
//
//  Created by Hikaru on 2015/02/12.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

enum OpenIDRequestType {
    case QQ,
    WeChat
    
    func toString()->String{
        switch self {
        case .QQ:
            return "qq"
        case .WeChat:
            return "wechat"
        }
    }
}


class SNSController: NSObject {
    
    typealias snsSuccessHandler = (sns: SNS) -> ()
    typealias snsFailureHandler = (errCode:Int32,errMessage:String) -> ()
    var whenSuccess:snsSuccessHandler?
    var whenfailure:snsFailureHandler?
    
    let net = Net()
    
    var sns: SNS!
    
    //インスタンス
    class var instance : SNSController {
        struct Static {
            static let instance : SNSController = SNSController()
        }
        return Static.instance
    }
    
    //初期化
    private override init() {
        super.init()
        self.registWX()
        self.registQQ()
        self.net.timeoutIntervalForRequest = 10.0
    }
    
    func getConfig(type:OpenIDRequestType)->SNS?{
        if let conffig = SNS.MR_findFirstByAttribute("type", withValue: type.toString()) as? SNS {
            switch type{
            case .QQ:
                if conffig.access_token != nil && conffig.openid != nil && conffig.expirationDate != nil {
                    return conffig
                }
                break;
            case .WeChat:
                if conffig.access_token != nil && conffig.openid != nil && conffig.refresh_token != nil {
                    return conffig
                }
                break;
            }
        }
        return nil
    }
}

//共通
extension SNSController{
    /////////////////////////////////////////////////////////
    ///////エラーを表示する/////////////////////////////////////
    /////////////////////////////////////////////////////////
    func showError(errCode:Int32,errMessage:String){
        SVProgressHUD.showErrorWithStatus(errMessage)
        self.whenfailure?(errCode:errCode,errMessage:errMessage)
    }
}

//parse
extension SNSController{
    func setCoreDataSNSInfo(result:AnyObject,type:OpenIDRequestType){
        if let sns = result as? SNS {//QQ
            
        }else if let res = result as? Dictionary<String, AnyObject>{
            if(type == .WeChat){//wechat
                assert(NSThread.currentThread().isMainThread, "not main thread")
                
                sns = SNS.MR_createEntity() as SNS
                sns.openid = result["openid"] as String?
                sns.access_token = result["access_token"] as String?
                sns.refresh_token = result["refresh_token"] as String?
                sns.type = type.toString()
            }
        }
    }
    func setCoreDataUserInfo(result:Dictionary<String, AnyObject>,type:OpenIDRequestType){
        switch type{
        case .QQ:
            break;
        case .WeChat:
            break;
        }
    }
}

//parse
extension SNSController{
    func setParseSNSInfo(result:SNS){
        /*
        let select = ParseUserInfoModel()
        select.objectId = "N7yMQYQYVm"
        select.nickname = "nicknameValue"
        let sns = ParseSNSModel(openid: "openid", access_token: "token1", refresh_token: "token2", expirationDate: "dateeeee")
        sns.objectId = "Nk2St1QVYU"
        //select.openids = [sns,sns]
        let pf = select.toPFObject()
        println(pf)
        pf.saveInBackgroundWithBlock({ (isok, error) -> Void in
        //select.initWithPFObject(pf)
        println(select)
        
        })
        */    
            
            
            
        /*
        //save WeChat OpenidInfo
        private func wxSaveOpenID(result:Dictionary<String, AnyObject>){
            let wx = SNS.MR_createEntity() as SNS
            wx.openid = result["openid"] as String?
            wx.access_token = result["access_token"] as String?
            wx.refresh_token = result["refresh_token"] as String?
            wx.type = OpenIDRequestType.WeiChat.toString()
            wx.managedObjectContext?.MR_saveToPersistentStoreWithCompletion(nil)
            //parse
            self.setParseSNSInfo(wx)
        }
        //save WeChat OpenidInfo
        private func saveWX(result:Dictionary<String, AnyObject>){
            let wx = SNS.MR_createEntity() as SNS
            wx.openid = result["openid"] as String?
            wx.access_token = result["access_token"] as String?
            wx.refresh_token = result["refresh_token"] as String?
            wx.type = OpenIDRequestType.WeiChat.toString()
            wx.managedObjectContext?.MR_saveToPersistentStoreWithCompletion(nil)
            //parse
            self.setParseSNSInfo(wx)
        }
        */
    }
    func setParseUserInfo(result:Dictionary<String, AnyObject>){

    }
}
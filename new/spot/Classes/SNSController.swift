//
//  SNSController.swift
//  spot
//
//  Created by Hikaru on 2015/02/12.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit


enum OpenIDRequestType {
    case
    QQ_Auth,
    QQ_share,
    
    WeiChat_Auth,
    WeiChat_Share
}
protocol OpenIDHelperDelegate{
    func onError(type:OpenIDRequestType,errCode:Int32,errMessage:String)//失败
    func onSuccess(type:OpenIDRequestType,res:Dictionary<String, AnyObject>)//成功
}

class SNSController: NSObject {
    //インスタンス
    class var instance : SNSController {
        struct Static {
            static let instance : SNSController = SNSController()
        }
        return Static.instance
    }
    
    //let manager = AFHTTPRequestOperationManager()
    var delegate:OpenIDHelperDelegate? //委托
    
    private override init() {
        super.init()
        
        self.register()
    }
}
//WeiChat
extension SNSController: WXApiDelegate {
    var csrf_state:String {
        get{
            return "73746172626f796368696e61"//于防止csrf攻击
        }
    }
    var Appid:String {
        get{
            return "wx810124210cb133e8"
        }
    }
    var AppSecret:String {
        get{
            return "e83f0c86269df3aab4265cf9934fa4dd"
        }
    }
    func register(){
        WXApi.registerApp(Appid)
    }
    /////////////////////////////////////////////////////////
    ///////WXApiDelegate/////////////////////////////////////
    /////////////////////////////////////////////////////////
    //微信的请求
    func onReq(req:BaseReq){
        
    }
    //微信的回调
    func onResp(resp:BaseResp){
        if (resp is SendAuthResp){
            let temp = resp as SendAuthResp
            if(0 == temp.errCode && csrf_state == temp.state){
                NSLog("code:%@,state:%@,errcode:%d", temp.code, temp.state, temp.errCode)
                //self.getAccessToken(temp.code)
            }else{
                //self.showError(temp.errCode, errMessage: temp.errStr)
            }
            
        }
    }
    
    /////////////////////////////////////////////////////////
    ///////请求授权///////////////////////////////////////////
    /////////////////////////////////////////////////////////
    func SendAuth(){
        //WXApi.isWXAppInstalled()
        var req = SendAuthReq()
        req.scope = "snsapi_userinfo" ;
        req.state = csrf_state ;
        WXApi.sendReq(req)
        //授权后 微信会回调  在回调中调用getAccessToken(code:String) 获取access_token及openid
    }
}
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
    //WeChat
    private let csrf_state = "73746172626f796368696e61"//于防止csrf攻击
    private let wxAppid = "wx810124210cb133e8"
    private let wxAppSecret = "e83f0c86269df3aab4265cf9934fa4dd"
    //QQ
    
    //
    let net = Net()
    var delegate:OpenIDHelperDelegate? //委托
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
        WXApi.registerApp(wxAppid)
        self.net.timeoutIntervalForRequest = 10.0
    }
}
//共通
extension SNSController{
    /////////////////////////////////////////////////////////
    ///////エラーを表示する/////////////////////////////////////
    /////////////////////////////////////////////////////////
    func showError(errCode:Int32,errMessage:String){
        SVProgressHUD.showErrorWithStatus(errMessage)
        self.delegate?.onError(.WeiChat_Auth,errCode: errCode, errMessage: errMessage)
    }
}
//WeiChatDelegate
extension SNSController: WXApiDelegate {
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
                //NSLog("code:%@,state:%@,errcode:%d", temp.code, temp.state, temp.errCode)
                self.getAccessToken(temp.code)
            }else{
                self.showError(temp.errCode, errMessage: temp.errStr)
            }
            
        }
    }

}
//WeiChatHelper
extension SNSController {
    private var wechat:String {
        get{
            return "wechat"
        }
    }
    /////////////////////////////////////////////////////////
    ///////检验授权凭证////////////////////////////////////////
    /////////////////////////////////////////////////////////
    //检验授权凭证（access_token）是否有效
    func wxCheckAuth(){
        let wx_url_auth = "https://api.weixin.qq.com/sns/auth"
        let reachability = Reachability.reachabilityForInternetConnection()
        if !reachability.isReachable() {
            self.showError(-4, errMessage: "ネットワークに接続してください")
            return;
        }
        if(!WXApi.isWXAppInstalled()){
            SVProgressHUD.showInfoWithStatus("WeiChatはインストールされていません")
            return;
        }
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black);
        if let wxconfig = self.getWxConfig(){
            let params = ["access_token": wxconfig.access_token!, "openid": wxconfig.openid!]
            // 认证授权
            self.net.GET(absoluteUrl: wx_url_auth,
                params: params,
                successHandler: { responseData in
                    let result = responseData.json(error: nil) as Dictionary<String, AnyObject>;
                    let errcode = result["errcode"] as Int;
                    let errmsg = result["errmsg"] as String;
                    if(0 == errcode){//授权OK 认证成功(access_token 2小时内有效 在有效期)
                        self.getUserInfo()
                    }else{
                        self.refreshToken()//刷新access_token 延长access_token 有效期
                    }
                },
                failureHandler: { error in
                    //NSLog("Error")
                    self.showError(Int32(error.code), errMessage: error.localizedDescription)
                }
            )
        }
    }
    
    /////////////////////////////////////////////////////////
    ///////请求授权///////////////////////////////////////////
    /////////////////////////////////////////////////////////
    private func wxSendAuth(){
        //WXApi.isWXAppInstalled()
        var req = SendAuthReq()
        req.scope = "snsapi_userinfo" ;
        req.state = csrf_state ;
        WXApi.sendReq(req)
        //授权后 微信会回调  在回调中调用getAccessToken(code:String) 获取access_token及openid
    }
    
    /////////////////////////////////////////////////////////
    ///////获取access_token///////////////////////////////////
    /////////////////////////////////////////////////////////
    
    //获取access_token
    //获取access_token
    private func getAccessToken(code:String){
        let wx_url_access_token = "https://api.weixin.qq.com/sns/oauth2/access_token"
        let params = ["appid": wxAppid, "secret": wxAppSecret, "code": code,"grant_type":"authorization_code"]
        
        self.net.GET(absoluteUrl: wx_url_access_token,
            params: params,
            successHandler: { responseData in
                let result = responseData.json(error: nil) as Dictionary<String, AnyObject>;
                if(!contains(result.keys, "errcode")){
                    self.saveWX(result)
                    
                    self.getUserInfo()
                }else{
                    let errcode = result["errcode"] as Int;
                    let errmsg = result["errmsg"] as String;
                    self.showError(Int32(errcode), errMessage: errmsg + __FUNCTION__)
                }
            },
            failureHandler: { error in
                NSLog("Error")
                self.showError(Int32(error.code), errMessage: error.localizedDescription)
            }
        )
    }
    
    /////////////////////////////////////////////////////////
    ///////刷新或续期access_token/////////////////////////////
    /////////////////////////////////////////////////////////
    //刷新或续期access_token
    private func refreshToken(){
        let wx_url_refresh_token = "https://api.weixin.qq.com/sns/oauth2/refresh_token"
        
        if let wxconfig = self.getWxConfig(){
            let params = ["appid": wxAppid, "grant_type": "refresh_token", "refresh_token": wxconfig.refresh_token! ]
            
            self.net.GET(absoluteUrl: wx_url_refresh_token,
                params: params,
                successHandler: { responseData in
                    let result = responseData.json(error: nil) as Dictionary<String, AnyObject>;
                    if(!contains(result.keys, "errcode")){
                        //SettingHelper.instance.setList(result, prefix: "wx_")
                        self.saveWX(result)
                        self.getUserInfo()
                    }else{
                        self.wxSendAuth()
                    }
                },
                failureHandler: { error in
                    NSLog("Error")
                    self.showError(Int32(error.code), errMessage: error.localizedDescription)
                }
            )
        }
    }
    
    /////////////////////////////////////////////////////////
    ///////获取用户个人信息（UnionID机制）///////////////////////
    /////////////////////////////////////////////////////////
    //获取用户个人信息（UnionID机制）
    private func getUserInfo(){
        let wx_url_userinfo = "https://api.weixin.qq.com/sns/userinfo"
        if let wxconfig = self.getWxConfig(){
            let params = ["access_token": wxconfig.access_token!, "openid": wxconfig.openid!]
            self.net.GET(absoluteUrl: wx_url_userinfo, params: params, successHandler: { (responseData) -> () in
                gcd.async(.Main) {
                    let result = responseData.json(error: nil) as Dictionary<String, AnyObject>;
                    if(!contains(result.keys, "errcode")){
                        SVProgressHUD.dismiss()
                        self.delegate?.onSuccess(.WeiChat_Auth,res: result)
                        self.setParseUserInfo(result)
                    }else{
                        let errcode = result["errcode"] as Int;
                        let errmsg = result["errmsg"] as String;
                        self.showError(Int32(errcode), errMessage: errmsg + __FUNCTION__)
                    }
                }
            }, failureHandler: { (error) -> () in
                NSLog("Error")
                self.showError(Int32(error.code), errMessage: error.localizedDescription)
            })
        }
    }
    //WeChat Openid Info
    private func getWxConfig()->SNS?{
        if let wxConffig = SNS.MR_findFirstByAttribute("type", withValue: self.wechat) as? SNS {
            if wxConffig.access_token == nil || wxConffig.openid == nil || wxConffig.refresh_token == nil {
                self.wxSendAuth()
            }else{
                return wxConffig
            }
        }else{
            self.wxSendAuth()
        }
        return nil
    }
    //save WeChat OpenidInfo
    private func saveWX(result:Dictionary<String, AnyObject>){
        let wx = SNS.MR_createEntity() as SNS
        wx.openid = result["openid"] as String?
        wx.access_token = result["access_token"] as String?
        wx.refresh_token = result["refresh_token"] as String?
        wx.type = self.wechat
        wx.managedObjectContext?.MR_saveToPersistentStoreWithCompletion(nil)
        //parse
        self.setParseSNSInfo(wx)
    }
}
//parse
extension SNSController{
    func setParseSNSInfo(sns:SNS){
        
    }
    func setParseUserInfo(result:Dictionary<String, AnyObject>){
        
    }
}
//
//  WeixinHelper.swift
//  spot
//
//  Created by Hikaru on 2014/12/09.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation
class WeixinHelper:NSObject,WXApiDelegate {    
    //シングルトンパターン
    class var instance: WeixinHelper {
        dispatch_once(&Inner.token) {
            Inner.instance = WeixinHelper()
        }
        return Inner.instance!
    }
    private struct Inner {
        static var instance: WeixinHelper?
        static var token: dispatch_once_t = 0
    }
    
    /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////
    let net = Net()
    var delegate:OpenIDHelperDelegate? //委托
    
    let csrf_state = "73746172626f796368696e61"//于防止csrf攻击
    
    let Appid = "wx810124210cb133e8";
    let AppSecret = "e83f0c86269df3aab4265cf9934fa4dd"
    
    
    
    /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////
    
    
    //初期化
    private override init() {
        WXApi.registerApp(Appid);
        
        self.net.timeoutIntervalForRequest = 10.0
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
                //NSLog("code:%@,state:%@,errcode:%d", temp.code, temp.state, temp.errCode)
                self.getAccessToken(temp.code)
            }else{
                self.showError(temp.errCode, errMessage: temp.errStr)
            }
            
        }
    }
    /////////////////////////////////////////////////////////
    ///////检验授权凭证////////////////////////////////////////
    /////////////////////////////////////////////////////////
    //检验授权凭证（access_token）是否有效
    let wx_url_auth = "https://api.weixin.qq.com/sns/auth"
    func checkAuth(){
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
        let access_token = SettingHelper.instance.get("wx_access_token") as String
        let openid = SettingHelper.instance.get("wx_openid") as String
        if("" == access_token || "" == openid){//没有OPENID 及 access_token
            self.SendAuth()
            return;
        }
        
        let params = ["access_token": access_token, "openid": openid]
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
                NSLog("Error")
                self.showError(Int32(error.code), errMessage: error.localizedDescription)
            }
        )
    }
    
    /////////////////////////////////////////////////////////
    ///////请求授权///////////////////////////////////////////
    /////////////////////////////////////////////////////////
    private func SendAuth(){
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
    let wx_url_access_token = "https://api.weixin.qq.com/sns/oauth2/access_token"
    //获取access_token
    private func getAccessToken(code:String){
        let params = ["appid": Appid, "secret": AppSecret, "code": code,"grant_type":"authorization_code"]
        
        self.net.GET(absoluteUrl: wx_url_access_token,
            params: params,
            successHandler: { responseData in
                let result = responseData.json(error: nil) as Dictionary<String, AnyObject>;
                if(!contains(result.keys, "errcode")){
                    SettingHelper.instance.setList(result, prefix: "wx_")
                    let openid = result["openid"] as String?
                    let access_token = result["access_token"] as String?
                    let refresh_token = result["refresh_token"] as String?
                    
                    APIHelper.instance.setOpenid(openid!, access_token: access_token!, refresh_token: refresh_token, expirationDate: nil)
                    self.getUserInfo()
                    /*
                    NSLog("access_token:%@",result["access_token"] as String)
                    let expires_in = result["expires_in"] as Int;
                    NSLog("expires_in:%d",expires_in)
                    NSLog("openid:%@",result["openid"] as String)
                    NSLog("refresh_token:%@",result["refresh_token"] as String)
                    */
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
    let wx_url_refresh_token = "https://api.weixin.qq.com/sns/oauth2/refresh_token"
    private func refreshToken(){
        let refresh_token = SettingHelper.instance.get("wx_refresh_token") as String
        if("" == refresh_token){
            self.SendAuth()//重新回去授权
        }else{
            let params = ["appid": Appid, "grant_type": "refresh_token", "refresh_token": refresh_token ]
            
            self.net.GET(absoluteUrl: wx_url_refresh_token,
                params: params,
                successHandler: { responseData in
                    let result = responseData.json(error: nil) as Dictionary<String, AnyObject>;
                    if(!contains(result.keys, "errcode")){
                        SettingHelper.instance.setList(result, prefix: "wx_")
                        self.getUserInfo()
                    }else{
                        self.SendAuth()
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
    let wx_url_userinfo = "https://api.weixin.qq.com/sns/userinfo"
    private func getUserInfo(){
        let access_token = SettingHelper.instance.get("wx_access_token") as String
        let openid = SettingHelper.instance.get("wx_openid") as String
        if("" == access_token || "" == openid){//没有OPENID 及 access_token
            self.SendAuth()
            return;
        }
        
        let params = ["access_token": access_token, "openid": openid ]
        
        self.net.GET(absoluteUrl: wx_url_userinfo,
            params: params,
            successHandler: { responseData in
                gcd.async(.Main) {
                    let result = responseData.json(error: nil) as Dictionary<String, AnyObject>;
                    if(!contains(result.keys, "errcode")){
                        SVProgressHUD.dismiss()
                        self.delegate?.onSuccess(.WeiChat_Auth,res: result)
                    }else{
                        let errcode = result["errcode"] as Int;
                        let errmsg = result["errmsg"] as String;
                        self.showError(Int32(errcode), errMessage: errmsg + __FUNCTION__)
                    }
                }
            },
            failureHandler: { error in
                NSLog("Error")
                self.showError(Int32(error.code), errMessage: error.localizedDescription)
            }
        )


        //self.delegate?.onSuccess(result)

    }
    /////////////////////////////////////////////////////////
    ///////エラーを表示する/////////////////////////////////////
    /////////////////////////////////////////////////////////
    func showError(errCode:Int32,errMessage:String){
        SVProgressHUD.showErrorWithStatus(errMessage)
        self.delegate?.onError(.WeiChat_Auth,errCode: errCode, errMessage: errMessage)
    }
}

















    
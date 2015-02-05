//
//  QQHelper.swift
//  spot
//
//  Created by Hikaru on 2014/12/10.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation
class QQHelper:NSObject,TencentSessionDelegate {
    //シングルトンパターン
    class var instance: QQHelper {
        dispatch_once(&Inner.token) {
            Inner.instance = QQHelper()
        }
        return Inner.instance!
    }
    private struct Inner {
        static var instance: QQHelper?
        static var token: dispatch_once_t = 0
    }
    /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////
    
    var delegate:OpenIDHelperDelegate? //委托
    private var _tencentOAuth :TencentOAuth?
    //初期化
    private override init() {
        super.init()
        let appid = "1103821830";
        //let appid = "222222";
        
        _tencentOAuth = TencentOAuth(appId: appid, andDelegate: self)
        
        let qq_openId = SettingHelper.instance.get("qq_openId") as String
        if("" != qq_openId ){
            _tencentOAuth?.accessToken =  SettingHelper.instance.get("qq_accessToken") as String
            _tencentOAuth?.openId = qq_openId
            _tencentOAuth?.expirationDate = SettingHelper.instance.get("qq_expirationDate") as? NSDate
        }
    }
    
    func checkAuth(){
        let reachability = Reachability.reachabilityForInternetConnection()
        if !reachability.isReachable() {
            self.showError(-4, errMessage: "ネットワークに接続してください")
            return;
        }
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black);
        let accessToken = _tencentOAuth?.accessToken
        if (accessToken != nil && "" != accessToken)
        {
            _tencentOAuth?.getUserInfo()
        }else
        {
            let _permissions = [
                kOPEN_PERMISSION_GET_USER_INFO,
                kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
            ];
            _tencentOAuth?.authorize(_permissions, inSafari: false)
        }
    }
    /////////////////////////////////////////////////////////
    ///////エラーを表示する/////////////////////////////////////
    /////////////////////////////////////////////////////////
    func showError(errCode:Int32,errMessage:String){
        SVProgressHUD.showErrorWithStatus(errMessage)
        self.delegate?.onError(.QQ_Auth,errCode: errCode, errMessage: errMessage)
    }
    
    /////////////////////////////////////////////////////////
    ///////QQ委托/////////////////////////////////////////////
    /////////////////////////////////////////////////////////
    
    internal func tencentDidLogin() {
        NSLog("登录完成");
        let accessToken = _tencentOAuth?.accessToken
        if (accessToken != nil && "" != accessToken)
        {
            
            let accessToken  = _tencentOAuth?.accessToken
            let openId = _tencentOAuth?.openId
            let expirationDate = _tencentOAuth?.expirationDate
            
            var param = Dictionary<String, AnyObject>();
            param["accessToken"] = accessToken
            param["openId"] = openId
            param["expirationDate"] = expirationDate
            println(param)
            
            SettingHelper.instance.setList(param, prefix: "qq_")
            APIHelper.instance.setOpenid(openId!, access_token:accessToken!, refresh_token: nil, expirationDate:expirationDate!)
            _tencentOAuth?.getUserInfo()
        }
        else
        {
            self.showError(-1, errMessage:"No Accesstoken")
            //NSLog("登录不成功 没有获取accesstoken");
        }
    }
    
    
    /**
    * Called when the user dismissed the dialog without logging in.
    */
    internal func tencentDidNotLogin(cancelled:Bool)
    {
        if (cancelled){
            self.showError(-2, errMessage:"キャンセルされました")
        }
        else {
            self.showError(-3, errMessage:"ログイン出来なかった")
        }
        
    }
    
    /**
    * Called when the notNewWork.
    */
    internal func tencentDidNotNetWork()
    {
        self.showError(-4, errMessage:"ネットワークに接続してください")
    }
    
    /**
    * Called when the logout.
    */
    internal func tencentDidLogout()
    {
        self.showError(-5, errMessage:"ログアウトしました")
    }

    internal func getUserInfoResponse(response: APIResponse!) {
        let res = response.jsonResponse as Dictionary<String, AnyObject>;
        let ret = res["ret"] as Int;
        if(0 != ret ){// -23 token is invalid
            _tencentOAuth?.accessToken = "";
            SettingHelper.instance.set("qq_accessToken", value: "")
            self.checkAuth();
        }else{
            SVProgressHUD.dismiss()
            self.delegate?.onSuccess(.QQ_Auth, res: res)
        }
    }
}
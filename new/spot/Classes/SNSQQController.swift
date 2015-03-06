//
//  SNSQQController.swift
//  spot
//
//  Created by Hikaru on 2015/02/17.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

//QQ
private let appid = "1103821830"
private var _tencentOAuth :TencentOAuth?
//WeiChatHelper
extension SNSController {
    
    func registQQ(){
        _tencentOAuth = TencentOAuth(appId: appid, andDelegate: self)
        
        if let qqconfig = self.getConfig(.QQ){
            _tencentOAuth?.accessToken =  qqconfig.access_token
            _tencentOAuth?.openId = qqconfig.openid
            _tencentOAuth?.expirationDate = qqconfig.expirationDate

        }
    }
    func qqCheckAuth(success:snsSuccessHandler,failure:snsFailureHandler?){
        self.whenSuccess = success;
        self.whenfailure = failure;
        
        let reachability = Reachability.reachabilityForInternetConnection()
        if !reachability.isReachable() {
            self.showError(-4, errMessage: "ネットワークに接続してください")
            return;
        }
//        SVProgressHUD.showWithMaskType(.Black);
        let accessToken = _tencentOAuth?.accessToken
        if (accessToken != nil && "" != accessToken)
        {
            _tencentOAuth?.getUserInfo()
        }else
        {
            self.qqSendAuth()
        }
    }
    private func qqSendAuth(){
        let _permissions = [
            kOPEN_PERMISSION_GET_USER_INFO,
            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
        ];
        _tencentOAuth?.authorize(_permissions, inSafari: false)
    }
    
    //save QQ OpenidInfo
    private func saveQQ(){
        
        let accessToken = _tencentOAuth?.accessToken
        if (accessToken != nil && "" != accessToken){
            assert(NSThread.currentThread().isMainThread, "not main thread")
            
            sns = SNS.MR_createEntity() as SNS
            sns.openid = _tencentOAuth?.openId
            sns.access_token = _tencentOAuth?.accessToken
            sns.expirationDate =  _tencentOAuth?.expirationDate
            
            sns.type = OpenIDRequestType.QQ.toString()
        }
    }
    
}



//Share
extension SNSController {
    
    /*
    分享到QQ
    0,        /**< 聊天界面    */
    1,        /**< 空间      */
    */
    func qqShare(scence:Int32,title:String,description:String,url:String){
        
        let image = UIImage(named: "icon_logo")!
        let data = UIImagePNGRepresentation(image)
        
        let uri = NSURL(string: url)
        
        let newsObj = QQApiNewsObject(URL: uri, title: title, description: description, previewImageData: data, targetContentType: QQApiURLTargetTypeNews)
    
        let req = SendMessageToQQReq(content: newsObj)
        
        if 1 == scence{//空间
            QQApiInterface.SendReqToQZone(req)
        }else{ // 好友
            QQApiInterface.sendReq(req)
        }
    }
}

//WeiChatDelegate
extension SNSController: TencentSessionDelegate {
    /////////////////////////////////////////////////////////
    ///////QQ委托/////////////////////////////////////////////
    /////////////////////////////////////////////////////////
    
    internal func tencentDidLogin() {
        NSLog("登录完成");
        let accessToken = _tencentOAuth?.accessToken
        if (accessToken != nil && "" != accessToken)
        {
            self.saveQQ()
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
            //SettingHelper.instance.set("qq_accessToken", value: "")
            self.qqSendAuth()
        }else{
            assert(NSThread.currentThread().isMainThread, "not main thread")
            
            sns?.nickName = res["nickname"] as String
            sns?.figureurl = res["figureurl_qq_2"] as String
            
            self.whenSuccess?(sns: sns)
//            self.setCoreDataUserInfo(res,type: .QQ)
//            SVProgressHUD.dismiss()
        }
    }
}
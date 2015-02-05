//
//  APIHelper.swift
//  spot
//
//  Created by Hikaru on 2015/01/20.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import Foundation

protocol APIHelperDelegate{
    func whenApiError(error:NSError!)//失败
    func whenApiSuccess(res:AnyObject?)//成功
}
class APIHelper:NSObject {
    //シングルトンパターン
    class var instance: APIHelper {
        dispatch_once(&Inner.token) {
            Inner.instance = APIHelper()
        }
        return Inner.instance!
    }
    private struct Inner {
        static var instance: APIHelper?
        static var token: dispatch_once_t = 0
    }
    
    let net = Net()
    var uuid = NSUUID().UUIDString
    var domain = "http://selink.syufu.jp/"
    
    var ERR_NETWORK_ACCESS_DENIED = NSError(domain: "syufu.jp",code: 138,userInfo: [ NSLocalizedDescriptionKey: "インターネットに接続できません" ])
    
    
    //初期化
    private override init() {
    }
    
    func http(url:String,params: NSDictionary?,delegate:APIHelperDelegate?){
        let reachability = Reachability.reachabilityForInternetConnection()
        if !reachability.isReachable() {
            SVProgressHUD.showErrorWithStatus(ERR_NETWORK_ACCESS_DENIED.localizedDescription)
            delegate?.whenApiError(ERR_NETWORK_ACCESS_DENIED)
            return;
        }
        SVProgressHUD.dismiss()
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black);
        self.net.GET(absoluteUrl: domain + url,
            params: params,
            successHandler: { responseData in
                let urlResponse = responseData.urlResponse as NSHTTPURLResponse
                gcd.async(.Main) {
                    if urlResponse.statusCode != 200 {
                        let error = NSError(domain: "HTTP_ERROR_CODE", code: urlResponse.statusCode, userInfo: nil)
                        delegate?.whenApiError(error)
                        return
                    }
                    SVProgressHUD.dismiss()
                    if let data = responseData.json(error: nil) as? Dictionary<String, AnyObject>{
                        delegate?.whenApiSuccess(data)
                    }else{
                        delegate?.whenApiSuccess(NSString(data: responseData.data, encoding: UInt())!)
                    }
                }
            },
            failureHandler: { error in
                gcd.async(.Main) {
                    SVProgressHUD.showErrorWithStatus(error.localizedDescription)
                    delegate?.whenApiError(error)
                }
            }
        )
    }
    
    //登録情報を取得
    func checkAuth(delegate:APIHelperDelegate){
        let url = "auth.json"
        let params = ["uuid": uuid, "openid": ""]
        self.http(url, params: params, delegate: delegate)
    }
    //openidを登録
    func setOpenid(openid:String,access_token:String,refresh_token:String?,expirationDate:NSDate?){
        let url = "ok.json"
        var expirationDateString = ""
        if let date = expirationDate{
            expirationDateString = date.toString(.Custom("yyyy-MM-dd HH:mm:ss"));
        }
        var refreshtoken = ""
        if let token = refresh_token{
            refreshtoken = token;
        }
        let params = [
            "uuid": uuid,
            "device": UIDevice.currentDevice().name,
            "openid": openid,
            "access_token": access_token,
            "refresh_token": refreshtoken,
            "expirationDate": expirationDateString
        ]
        
        self.http(url, params: params, delegate: nil)
    }
    //openidを登録
    func regist(nickname:String,figure:String,station:String,birthday:String?,sex:String?){
        let url = "regist.json"
        var _birthday = ""
        var _sex = ""
        if let _b = birthday {
            _birthday = _b
        }
        if let _s = sex {
            _sex = _s
        }
        let params = [
            "nickname": nickname,
            "uuid": uuid,
            "figure": figure,
            "station": station,
            "birthday": _birthday,
            "sex": _sex,
        ]
        
        self.http(url, params: params, delegate: nil)
    }
}
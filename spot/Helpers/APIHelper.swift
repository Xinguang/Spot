//
//  APIHelper.swift
//  spot
//
//  Created by Hikaru on 2015/01/20.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import Foundation

protocol APIHelperDelegate{
    func onError(errCode:Int32,errMessage:String)//失败
    func onSuccess(res:AnyObject)//成功
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
    var auth_token:String?
    var uuid = NSUUID().UUIDString
    var domain = "http://selink.syufu.jp/"
    
    
    //初期化
    private override init() {
    }

    func checkNet(delegate:APIHelperDelegate?) ->Bool{
        if !Reachability.isConnectedToNetwork() {
            self.showError(delegate,errCode: -4, errMessage: "ネットワークに接続してください")
            return false;
        }
        return true;
    }
    //登録情報を取得
    func checkAuth(delegate:APIHelperDelegate){
        if(self.checkNet(delegate)){return;}
        
        let url = domain + "auth.json"
        
        let params = ["uuid": uuid, "openid": ""]
        
        SVProgressHUD.showWithMaskType(SVProgressHUDMaskType.Black);
        
        self.net.GET(absoluteUrl: url,
            params: params,
            successHandler: { responseData in
                gcd.async(.Main) {
                    if let data = responseData.json(error: nil) as? Dictionary<String, AnyObject>{
                        let auth = APIAuthModel(data: data)
                        self.auth_token = auth.auth_token
                        self.success(delegate, res: auth)
                    }else{
                        self.showError(delegate,errCode: -4, errMessage: "ネットワークを確認してください")//服务器返回信息错误
                    }
                }
            },
            failureHandler: { error in
                self.showError(delegate,errCode: Int32(error.code), errMessage: error.localizedDescription)
            }
        )
    }
    //openidを登録
    func setOpenid(openid:String,access_token:String,refresh_token:String?,expirationDate:NSDate?){
        if(self.checkNet(nil)){return;}
        
        let url = domain + "ok.json"
        
        let params = [
            "auth_token": self.auth_token!,
            "uuid": uuid,
            "device": UIDevice.currentDevice().name,
            "openid": openid,
            "access_token": access_token,
            "refresh_token": refresh_token!,
            "expirationDate": expirationDate!
        ]
        
        self.net.GET(absoluteUrl: url,
            params: params,
            successHandler: { responseData in
                if let data = responseData.json(error: nil) as? Dictionary<String, AnyObject>{
                    let auth = APICommonModel(data: data)
                    self.success(nil, res: auth)
                }else{
                    self.showError(nil,errCode: -4, errMessage: "ネットワークを確認してください")//服务器返回信息错误
                }

            },
            failureHandler: { error in
                self.showError(nil,errCode: Int32(error.code), errMessage: error.localizedDescription)
            }
        )
    }
    //openidを登録
    func regist(nickname:String,figure:String,station:String,birthday:String?,sex:NSDate?){
        if(self.checkNet(nil)){return;}
        
        let url = domain + "regist.json"
        
        let params = [
            "nickname": nickname,
            "uuid": uuid,
            "figure": figure,
            "station": station,
            "birthday": birthday!,
            "sex": sex!,
        ]
        
        self.net.GET(absoluteUrl: url,
            params: params,
            successHandler: { responseData in
                if let data = responseData.json(error: nil) as? Dictionary<String, AnyObject>{
                    let reg = APIRegistModel(data: data)
                    self.auth_token = reg.auth_token
                    self.success(nil, res: reg)
                }else{
                    self.showError(nil,errCode: -4, errMessage: "ネットワークを確認してください")//服务器返回信息错误
                }
                
            },
            failureHandler: { error in
                self.showError(nil,errCode: Int32(error.code), errMessage: error.localizedDescription)
            }
        )
    }
    /////////////////////////////////////////////////////////
    ///////エラーを表示する/////////////////////////////////////
    /////////////////////////////////////////////////////////
    func showError(delegate:APIHelperDelegate?,errCode:Int32,errMessage:String){
        SVProgressHUD.showErrorWithStatus(errMessage)
        delegate?.onError(errCode, errMessage: errMessage)
    }
    /////////////////////////////////////////////////////////
    ///////データを返す////////////////////////////////////////
    /////////////////////////////////////////////////////////
    func success(delegate:APIHelperDelegate?,res:AnyObject){
        SVProgressHUD.dismiss()
        delegate?.onSuccess(res)
    }
}
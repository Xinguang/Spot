//
//  OpenIDHelper.swift
//  spot
//
//  Created by Hikaru on 2014/12/11.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

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

class OpenIDAuthModel {
    var nickname:String = ""
    var figure:String = ""
    var sex:String = ""
    var birthday:String = ""
}
//
//  ParseSNSModel.swift
//  spot
//
//  Created by Hikaru on 2015/02/17.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

class ParseSNSModel :ParseModel{
    
    // MARK: - Properties
    var openid: String = ""
    var access_token: String = ""
    var refresh_token: String = ""
    var expirationDate: String = ""
    override init(){
        
    }
    convenience init(
        openid: String
        , access_token:String
        , refresh_token:String
        , expirationDate:String){
            self.init()
            self.openid = openid
            self.access_token = access_token
            self.refresh_token = refresh_token
            self.expirationDate = expirationDate
    }
    
//    override func toPFObject()->PFObject{
//        var pfObject = super.toPFObject()
//    
//        self.setPFObject(pfObject,key: "openid",object: self.openid)
//        self.setPFObject(pfObject,key: "access_token",object: self.access_token)
//        self.setPFObject(pfObject,key: "refresh_token",object: self.refresh_token)
//        self.setPFObject(pfObject,key: "expirationDate",object: self.expirationDate)
//        return pfObject
//    }
}
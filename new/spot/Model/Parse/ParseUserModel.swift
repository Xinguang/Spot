//
//  ParseUserModel.swift
//  spot
//
//  Created by Hikaru on 2015/02/17.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

class ParseUserModel :ParseModel{
    
    // MARK: - Properties
    var username: String = ""
    var password: String = ""
    var openfireId: String = ""
    var displayName = ""
    
//    var authData: String = ""
//    var emailVerified: String = ""
//    var email: String = ""
//    var userInfo: ParseUserInfoModel = ParseUserInfoModel()
//    var firends:[ParseUserModel] = []
    override init(){
        
    }
    convenience init(
        username: String
        , password: String
        , openfireId: String
        , displayName: String) {
//        , authData: String
//        , emailVerified: String
//        , email: String
//        , userInfo: ParseUserInfoModel
//        , firends:[ParseUserModel]){
            self.init()
            self.username = username
            self.password = password
            self.openfireId = openfireId
            self.displayName = displayName
            
//            self.authData = authData
//            self.emailVerified = emailVerified
//            self.email = email
//            self.userInfo = userInfo
//            self.firends = firends
    }
    
    init(user: User) {
        self.username = user.username ?? ""
        self.password = CocoaSecurity.aesEncrypt(user.password, key: kAESKey).base64
        self.openfireId = user.openfireId
        self.displayName = user.displayName ?? ""
    }
    
    func aesDecryptPassword() -> String {
        return CocoaSecurity.aesDecryptWithBase64(password, key: kAESKey).utf8String
    }
    
    func xmppJID() -> XMPPJID {
        return XMPPJID.jidWithString(openfireId)
    }
//    
//    override func toPFObject()->PFObject{
//        var pfObject = super.toPFObject()
//        
//        self.setPFObject(pfObject,key: "username",object: self.username)
//        self.setPFObject(pfObject,key: "password",object: self.password)
//        self.setPFObject(pfObject,key: "authData",object: self.authData)
//        self.setPFObject(pfObject,key: "emailVerified",object: self.emailVerified)
//        self.setPFObject(pfObject,key: "email",object: self.email)
//        self.setPFObject(pfObject,key: "userInfo",object: self.userInfo)
//        self.setPFObject(pfObject,key: "firends",object: self.firends)
//        
//        return pfObject
//    }
}

//
//  UserController.swift
//  spot
//
//  Created by 張志華 on 2015/03/03.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class UserController: NSObject {
    
    class func autoLoginUser() -> User? {
        return User.MR_findFirst() as? User
    }
    
    class func snsUser(type: OpenIDRequestType, res: Dictionary<String, AnyObject>) -> User {
        let account = anonymousUser()
        
        if type == .QQ {
            account.displayName = res["nickname"] as? String
            account.figureurl = res["figureurl_qq_2"] as? String
        }

        if type == .WeChat {
            account.displayName = res["nickname"] as? String
            account.figureurl = res["headimgurl"] as? String
        }
        
        account.managedObjectContext?.MR_saveToPersistentStoreAndWait()
        
        return account
    }
    
    class func anonymousUser() -> User {
        let openfireId = NSUUID().UUIDString.lowercaseString
        let password = NSUUID().UUIDString.lowercaseString
        
        let account = User.MR_createEntity() as User
        
        account.username = ""
        account.openfireId = openfireId + "@" + kOpenFireDomainName;
        account.password = password
        account.displayName = "匿名"
        
        account.managedObjectContext?.MR_saveToPersistentStoreAndWait()
        
        return account
    }
    
    class func userWith(#username: String, password: String, displayName: String) -> User {
        let user = User.MR_createEntity() as User
        user.username = username
        user.openfireId = NSUUID().UUIDString.lowercaseString + "@" + kOpenFireDomainName
        user.displayName = displayName
        user.password = password
        
        return user
    }
    
    class func saveWithParseUser(parseUser: ParseUserModel) -> User {
        let user = User.MR_createEntity() as User
        user.username = parseUser.username
        user.openfireId = parseUser.openfireId
        user.displayName = parseUser.displayName
        user.password = parseUser.aesDecryptPassword()
        
        user.managedObjectContext?.MR_saveToPersistentStoreAndWait()
        
        return user
    }
}

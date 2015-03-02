//
//  UserController.swift
//  spot
//
//  Created by 張志華 on 2015/03/03.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class UserController: NSObject {
    
    class func anonymousLogin() {
        let openfireId = NSUUID().UUIDString.lowercaseString
        let password = NSUUID().UUIDString.lowercaseString
        
        let account = User.MR_createEntity() as User

        account.username = openfireId + "@" + kOpenFireDomainName;
        account.uniqueIdentifier = NSUUID().UUIDString.lowercaseString
        account.password = password
        account.displayName = ""

        account.managedObjectContext?.MR_saveToPersistentStoreWithCompletion({ (b, error) -> Void in
            XMPPManager.instance.account = account
            XMPPManager.instance.registerNewAccountWithPassword(password)
        })
    }
    
    class func shouldAutoLogin() -> Bool {
        return User.MR_countOfEntities() > 0
    }
    
    class func autoLogin() {
        let autoLoginUser = User.MR_findFirst() as User
        
        XMPPManager.instance.account = autoLoginUser
        
        if autoLoginUser.password != nil {
            XMPPManager.instance.connectWithPassword(autoLoginUser.password)
        }
    }
    
}

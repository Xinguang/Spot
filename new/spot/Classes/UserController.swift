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
        let account = createAnonymousUser()
        XMPPManager.instance.account = account
        XMPPManager.instance.registerNewAccountWithPassword(account.password)
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
    
    class func loginWithQQ(res: Dictionary<String, AnyObject>) {
        let account = createAnonymousUser()
        account.displayName = res["nickname"] as? String
        account.figureurl = res["figureurl_qq_2"] as? String
        account.managedObjectContext?.MR_saveToPersistentStoreAndWait()
        
        XMPPManager.instance.account = account
        XMPPManager.instance.needUpdateVcard = true
        XMPPManager.instance.registerNewAccountWithPassword(account.password)
    }
    
    class func createAnonymousUser() -> User {
        let openfireId = NSUUID().UUIDString.lowercaseString
        let password = NSUUID().UUIDString.lowercaseString
        
        let account = User.MR_createEntity() as User
        
        account.username = openfireId + "@" + kOpenFireDomainName;
        account.uniqueIdentifier = NSUUID().UUIDString.lowercaseString
        account.password = password
        account.displayName = ""
        
        account.managedObjectContext?.MR_saveToPersistentStoreAndWait()
        
        return account
    }
}

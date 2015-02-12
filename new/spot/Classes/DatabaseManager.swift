//
//  DatabaseManager.swift
//  spot
//
//  Created by 張志華 on 2015/02/10.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class DatabaseManager: NSObject {
    class var instance : DatabaseManager {
        struct Static {
            static let instance : DatabaseManager = DatabaseManager()
        }
        return Static.instance
    }
    
    func autoLoginAccount() -> User? {
        return User.MR_findFirst() as? User
    }
}

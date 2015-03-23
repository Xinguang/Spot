//
//  DatabaseManager.swift
//  spot
//
//  Created by 張志華 on 2015/02/10.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class DatabaseManager: NSObject {
    
    class func autoLoginAccount() -> User? {
        return User.MR_findFirst() as? User
    }
    
    class func dataOfPath(path: String) -> NSData? {
        return (Resource.MR_findFirstByAttribute("path", withValue: path) as? Resource)?.data
    }
    
    class func saveResourceAtPath(path: NSURL, toPath: String, done: () -> Void) {
        let data = NSData(contentsOfURL: path)
        
        let r = Resource.MR_createEntity() as Resource
        r.path = toPath
        r.data = data
        
        r.managedObjectContext?.MR_saveToPersistentStoreWithCompletion({ (_, error) -> Void in
            if error == nil {
                done()
            }
        })
    }
    
    class func saveDataOfPath(path: String, data: NSData, done: () -> Void) {        
        let r = Resource.MR_createEntity() as Resource
        r.path = path
        r.data = data
        
        r.managedObjectContext?.MR_saveToPersistentStoreWithCompletion({ (_, error) -> Void in
            if error == nil {
                done()
            }
        })
    }
}

//
//  ParseController.swift
//  spot
//
//  Created by 張志華 on 2015/03/04.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class ParseController: NSObject {
   
    class func uploadUser(user: User, done: (NSError?) -> Void) {
        let parseUserModel = ParseUserModel(user: user)
        
        parseUserModel.toPFObject().saveInBackgroundWithBlock { (b, error) -> Void in
            done(error)
        }
    }
    
    class func getUserByOpenfireID(id: String, result: (ParseUserModel?, NSError?) -> Void) {
//        let q = PFQuery(className: "User")
//        q.whereKey("openfireId", equalTo: id)
//        
//        q.getFirstObjectInBackgroundWithBlock { (obj, error) -> Void in
//            if let error = error {
//                result(nil, error)
//                return
//            }
//            
//            
//        }
        
        let user =  ParseUserModel()
        user.getQuery().whereKey("openfireId", equalTo: id)
        user.getFirst(ParseUserModel.self, complete: { (res, error) -> () in
            result(res, error)
        })
        
    }
    
}

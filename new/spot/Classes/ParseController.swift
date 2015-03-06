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
        //no sns
        if user.snses.count == 0 {
            let parseUserModel = ParseUserModel(user: user)
        
            parseUserModel.toPFObject().saveInBackgroundWithBlock { (b, error) -> Void in
                done(error)
            }
            
            return
        }
        
        // TODO: >1
        
        if let sns = user.snses.lastObject as? SNS {
            let pSNSModel = ParseSNSModel(sns: sns)
            let pSNS = pSNSModel.toPFObject()
            
            let pUserModel = ParseUserModel(user: user)
            let pUser = pUserModel.toPFObject()
            
            pSNS["user"] = pUser
            
            pSNS.saveInBackgroundWithBlock({ (b, error) -> Void in
                done(error)
            })

        }
    }
    
    class func getUserByUsername(username: String, result: (ParseUserModel?, NSError?) -> Void) {
        let user =  ParseUserModel()
        user.getQuery().whereKey("username", equalTo: username)
        user.getFirst(ParseUserModel.self, complete: { (res, error) -> () in
            result(res, error)
        })
    }

    class func parseUserByOpenid(openid: String) -> ParseUserModel? {
        let parseSNS =  ParseSNSModel()
        parseSNS.getQuery().whereKey("openid", equalTo: openid)
        if let pfObject = parseSNS.getQuery().getFirstObject() {
            if let pUser = pfObject["user"] as? PFObject {
                pUser.fetchIfNeeded()
                
                return ParseUserModel(pfObject: pUser)
            }
        } else {
            return nil
        }
        
        return nil
    }
    
    class func getUserByOpenfireID(id: String, result: (ParseUserModel?, NSError?) -> Void) {
        let user =  ParseUserModel()
        user.getQuery().whereKey("openfireId", equalTo: id)
        user.getFirst(ParseUserModel.self, complete: { (res, error) -> () in
            result(res, error)
        })
    }
    
}

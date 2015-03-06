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
    
    class func getUserByOpenid(openid: String, result: (ParseUserModel?, NSError?) -> Void) {
        let user =  ParseUserModel()
        user.getQuery().whereKey("openid", equalTo: openid)
        user.getFirst(ParseUserModel.self, complete: { (res, error) -> () in
            result(res, error)
        })
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
    
//    class func toPFObject(obj: NSManagedObject) -> PFObject {
//        var pfObject = PFObject(className:getClassName(obj))
//        
//        var aClass : AnyClass? = obj.dynamicType
//        
//        var propertiesCount : CUnsignedInt = 0
//        let propertiesInAClass : UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(aClass, &propertiesCount)
//        
//        for var i = 0; i < Int(propertiesCount); i++ {
//            
//            if let key = NSString(CString: property_getName(propertiesInAClass[i]), encoding: NSUTF8StringEncoding) {
//                var val: AnyObject? = self.valueForKey(key)
//                
//                if let str = val as? String{
//                    pfObject[key] = str
//                }
////                else if let pm = val as? ParseModel{
////                    var relation = pfObject.relationForKey(key)
////                    self.saveRelationObject(pm,relation:relation)
////                }else if let arr = val as? [ParseModel]{
////                    if arr.count > 0 {
////                        var relation = pfObject.relationForKey(key)
////                        relation.removeAll()
////                        for o in arr {
////                            self.saveRelationObject(o,relation:relation)
////                        }
////                    }
////                }
//            }
//        }
//        return pfObject
//    }
//    
//    class func getClassName(obj: NSManagedObject) -> String {
//        if let classname = NSString(UTF8String: class_getName(obj.dynamicType)) {
//            return classname.substringToIndex(classname.rangeOfString("_").location)
//        }
//        
//        return ""
//    }
//    class func isRegisteredUser(user: User) -> Bool {
//        let query = PFQuery(className: "SNS")
//        query.whereKey("openid", equalTo:(user.snses.lastObject as? SNS)?.openid)
//        if let pfObject = query.getFirstObject() {
//            
//        }
//        
//        return false
//    }
}

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
        let pUser = PFObject(className: "User")
        
        if let username = user.username {
            pUser["username"] = username
        }
        
        pUser["password"] = CocoaSecurity.aesEncrypt(user.password, key: kAESKey).base64
        
        if let displayName = user.displayName {
            pUser["displayName"] = displayName
        }
        
        pUser["openfireId"] = user.openfireId
        
        if let snses = user.snses.array as? [SNS] {
            for sns in snses {
                let pSns = PFObject(className: "SNS")
                
                if let openid = sns.openid {
                    pSns["openid"] = openid
                }
                
                if let nickName = sns.nickName {
                    pSns["nickName"] = nickName
                }
                
                if let refresh_token = sns.refresh_token {
                    pSns["refresh_token"] = refresh_token
                }
                
                if let figureurl = sns.figureurl {
                    pSns["figureurl"] = figureurl
                }
                
                if let expirationDate = sns.expirationDate {
                    pSns["expirationDate"] = expirationDate
                }
                
                if let access_token = sns.access_token {
                    pSns["access_token"] = access_token
                }
                
                if let type = sns.type {
                    pSns["type"] = type
                }
                
                pSns["user"] = pUser
                
                pSns.saveInBackgroundWithBlock(nil)
            }
        }
        
        pUser.saveInBackgroundWithBlock({ (b, error) -> Void in
            done(error)
        })
    }
    
    class func updateUser(user: User, done: ((NSError?) -> Void)?) {
        let query = PFQuery(className: "User")
        query.whereKey("openfireId", equalTo: user.openfireId)
        
        query.getFirstObjectInBackgroundWithBlock { (obj, err) -> Void in
            if let gender = user.gender {
                obj["gender"] = user.gender
            }
            
            if let displayName = user.displayName {
                obj["displayName"] = displayName
            }
            
            obj.saveInBackgroundWithBlock({ (b, err) -> Void in
                if let done = done {
                    done(nil)
                }
            })
        }
    }
    
    class func updateUserImage(user: User, thumbnail: UIImage, org: UIImage) {
        let query = PFQuery(className: "User")
        query.whereKey("openfireId", equalTo: user.openfireId)
        
        query.getFirstObjectInBackgroundWithBlock { (obj, err) -> Void in
            let thumbnailFile = PFFile(name: "thumbnail.png", data: UIImagePNGRepresentation(thumbnail))
            let orgFile = PFFile(name: "org.png", data: UIImagePNGRepresentation(org))
            
            thumbnailFile.saveInBackgroundWithBlock(nil)
            orgFile.saveInBackgroundWithBlock(nil)
            
            obj["avatarThumbnail"] = thumbnailFile
            obj["avatarOrg"] = orgFile
            
            obj.saveInBackgroundWithBlock({ (b, err) -> Void in
                
            })
        }
    }
    
    class func getUserFromParse(user: User, done: (pUser: PFObject?, error: NSError?) -> Void) {
        let query = PFQuery(className: "User")
        query.whereKey("openfireId", equalTo: user.openfireId)
        
        query.getFirstObjectInBackgroundWithBlock { (obj, err) -> Void in
            done(pUser: obj, error: err)
        }
    }
    
    class func getUserByKey(key: String,value: String, result: (PFObject?, NSError?) -> Void) {
        let query = PFQuery(className: "User")
        query.whereKey(key, equalTo: value)
        
        query.getFirstObjectInBackgroundWithBlock { (obj, err) -> Void in
            result(obj, err)
        }
    }

    class func parseUserByOpenid(openId: String, result: (PFObject?, NSError?) -> Void) {
        let query = PFQuery(className: "SNS")
        query.whereKey("openid", equalTo: openId)
        
        query.includeKey("user")
        
        query.getFirstObjectInBackgroundWithBlock { (obj, err) -> Void in
            result(obj, err)
        }
    }
    
//    class func getUserByOpenfireID(id: String, result: (ParseUserModel?, NSError?) -> Void) {
//        let user =  ParseUserModel()
//        user.getQuery().whereKey("openfireId", equalTo: id)
//        user.getFirst(ParseUserModel.self, complete: { (res, error) -> () in
//            result(res, error)
//        })
//    }
    
    // MARK: - Station
    
    class func addStationToUser(station: PFObject, user: User) {
        getUserFromParse(user, done: { (pUser, error) -> Void in
            if let user = pUser {
                station.saveInBackgroundWithBlock({ (b, err) -> Void in
                    var relation = user.relationForKey("stations")
                    relation.addObject(station)
                    
                    user.saveInBackgroundWithBlock({ (b, err) -> Void in
                        
                    })
                })
                
                
            }
        })
    }
    
    class func getStations(done: (res: [PFObject]?, error: NSError?) -> Void) {
        let query = PFQuery(className: "Station")
        query.findObjectsInBackgroundWithBlock { (res, err) -> Void in
            done(res: res as? [PFObject], error: err)
            
//            var results = [PFObject]()
//            
//            // TODO: improve performance
//            if let res = res as? [PFObject] {
//                for station in res {
//                    station["count"] = self.userCountOfStation(station)
//                    results.append(station)
//                }
//            }
//            
//            done(res: results, error: err)
        }
    }
    
//    class func userCountOfStation(station: PFObject) -> Int {
//        let q = PFQuery(className: "User")
//        q.whereKey("stations", equalTo: station)
//        
//        return q.countObjects()
//    }
    
    class func getUsersOfStation(station: PFObject, done: (res: [PFObject]?, error: NSError?) -> Void) {
        let q = PFQuery(className: "User")
        q.whereKey("stations", equalTo: station)
        
        q.findObjectsInBackgroundWithBlock { (res, err) -> Void in
            done(res: res as? [PFObject], error: err)
        }
    }
    
    class func saveStations(stations: [PFObject], user: User) {
        getUserFromParse(user, done: { (pUser, error) -> Void in
            if let user = pUser {
                let relation = user.relationForKey("stations")
                let query = relation.query()
                
                if let array = query.findObjects() as? [PFObject] {
                    for oldStation in array {
                        relation.removeObject(oldStation)
                    }
                }
                
                for station in stations {
                    station.saveInBackgroundWithBlock({ (b, err) -> Void in
                    relation.addObject(station)
                    })
                }
                
                user.saveInBackgroundWithBlock({ (b, err) -> Void in
                    println(__FUNCTION__)
                })
                
                
            }
        })
    }
}

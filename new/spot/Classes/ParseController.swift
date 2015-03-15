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
    
    class func updateGenderOfUser(user: User, done: (NSError?) -> Void) {
        let query = PFQuery(className: "User")
        query.whereKey("openfireId", equalTo: user.openfireId)
        
        query.getFirstObjectInBackgroundWithBlock { (obj, err) -> Void in
            obj["gender"] = user.gender
            
            obj.saveInBackgroundWithBlock({ (b, err) -> Void in
                done(nil)
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

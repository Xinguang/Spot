//
//  UserController.swift
//  spot
//
//  Created by 張志華 on 2015/03/03.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class UserController: NSObject {
    
    class func isAnonymousUser() -> Bool {
        let user = User.MR_findFirst() as User
        return user.username == nil && user.snses.count == 0
    }
    
    class func autoLoginUser() -> User? {
        assert(NSThread.currentThread().isMainThread, "not main thread")
        
        return User.MR_findFirst() as? User
    }
    
    class func snsUser(sns: SNS, parseUser: ParseUserModel?) -> User {
        assert(NSThread.currentThread().isMainThread, "not main thread")
        
        var user: User

        if let parseUser = parseUser {
            user = self.userFromParseUser(parseUser)
        } else {
            user = anonymousUser()
        }
        
        sns.user = user
 
        return user
    }
    
//    class func snsUser(type: OpenIDRequestType, res: Dictionary<String, AnyObject>) -> User {
//        assert(NSThread.currentThread().isMainThread, "not main thread")
//        
//        let account = anonymousUser()
//        
//        if type == .QQ {
//            account.displayName = res["nickname"] as? String
//            account.figureurl = res["figureurl_qq_2"] as? String
//        }
//
//        if type == .WeChat {
//            account.displayName = res["nickname"] as? String
//            account.figureurl = res["headimgurl"] as? String
//        }
//        
//        return account
//    }
    
    class func anonymousUser() -> User {
        assert(NSThread.currentThread().isMainThread, "not main thread")
        
        let openfireId = NSUUID().UUIDString.lowercaseString
        let password = NSUUID().UUIDString.lowercaseString
        
        let account = User.MR_createEntity() as User
        
        account.openfireId = openfireId + "@" + kOpenFireDomainName;
        account.password = password
                
        return account
    }
    
    class func userWith(#username: String, password: String, displayName: String) -> User {
        assert(NSThread.currentThread().isMainThread, "not main thread")
        
        let user = User.MR_createEntity() as User
        user.username = username
        user.openfireId = NSUUID().UUIDString.lowercaseString + "@" + kOpenFireDomainName
        user.displayName = displayName
        user.password = password
        
        return user
    }
    
    class func userFromParseUser(parseUser: ParseUserModel) -> User {
        assert(NSThread.currentThread().isMainThread, "not main thread")
        
        let user = User.MR_createEntity() as User
        user.username = parseUser.username
        user.openfireId = parseUser.openfireId
        user.displayName = parseUser.displayName
        user.password = parseUser.aesDecryptPassword()
                
        return user
    }

    class func updateUserWithParseUser(user: User, parseUser: PFObject) {
        //displayName
        user.displayName = parseUser["displayName"] as? String
        //性別
        user.gender = parseUser["gender"] as? String
        //駅
        let relation = parseUser.relationForKey("stations")
        let query = relation.query()

        if let array = query.findObjects() as? [PFObject] {
            addStationsToUser(array, user: user)
        }
    }

    class func saveUser(user: User) {
        assert(NSThread.currentThread().isMainThread, "not main thread")
        
        user.managedObjectContext?.MR_saveToPersistentStoreWithCompletion(nil)
    }
    
    class func saveUserAndWait(user: User) {
        assert(NSThread.currentThread().isMainThread, "not main thread")
        
        user.managedObjectContext?.MR_saveToPersistentStoreAndWait()
    }

    // MARK: - Station
    
    class func saveStations(stations: [PFObject], user: User) {
        user.stationsSet().removeAllObjects()
        
        for station in stations {
            let s = Station.MR_createEntity() as Station
            s.name = station["name"] as String
            
            user.stationsSet().addObject(s)
        }
        
        user.managedObjectContext?.MR_saveToPersistentStoreWithCompletion(nil)
    }
    
    class func isStationOfUser(station: PFObject, user: User) -> Bool {
//        if Station.MR_findFirstByAttribute("name", withValue: station["name"]) != nil {
//            return true
//        }
        
        if User.MR_findFirstWithPredicate(NSPredicate(format: "ANY stations.name = %@", argumentArray: [station["name"]])) != nil {
            return true
        }
        
        return false
    }
    
    class func addStationToUser(station: PFObject, user: User) {
        addStationsToUser([station], user: user)
    }

    class func addStationsToUser(stations: [PFObject], user: User) {
        for station in stations {
            let s = Station.MR_createEntity() as Station
            s.name = station["name"] as String

            user.stationsSet().addObject(s)
        }
    }
}

//
//  UserController.swift
//  spot
//
//  Created by 張志華 on 2015/03/03.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class UserController: NSObject {
    
    class func isAnonymousUser(user: User) -> Bool {
        return user.username == nil && user.snses.count == 0
    }
    
    class func autoLoginUser() -> User? {
        assert(NSThread.currentThread().isMainThread, "not main thread")
        
        return User.MR_findFirst() as? User
    }
    
    class func snsUser(sns: SNS) -> User {
        assert(NSThread.currentThread().isMainThread, "not main thread")
        
        var user: User
        user = anonymousUser()
        sns.user = user
 
        if let gender = sns.gender {
            user.gender = gender
        }
        
        if let name = sns.nickName {
            user.displayName = name
        }
        
        return user
    }
    
    class func anonymousUser() -> User {
        assert(NSThread.currentThread().isMainThread, "not main thread")
        
        let openfireId = NSUUID().UUIDString.lowercaseString
        let password = NSUUID().UUIDString.lowercaseString
        
        let account = User.MR_createEntity() as User
        
        account.openfireId = openfireId + "@" + kOpenFireDomainName;
        account.password = password
                
        return account
    }
    
    //新規登録
    class func userWith(#username: String, password: String, displayName: String) -> User {
        assert(NSThread.currentThread().isMainThread, "not main thread")
        
        let user = User.MR_createEntity() as User
        user.username = username
        user.openfireId = NSUUID().UUIDString.lowercaseString + "@" + kOpenFireDomainName
        user.displayName = displayName
        user.password = password
        
        return user
    }
    
    //既存ユーザーログイン
    class func userFromParseUser(parseUser: PFObject) -> User {
        assert(NSThread.currentThread().isMainThread, "not main thread")
        
        let user = User.MR_createEntity() as User
        user.username = parseUser["username"] as? String
        user.openfireId = parseUser["openfireId"] as? String
        user.displayName = parseUser["displayName"] as? String
        user.gender = parseUser["gender"] as? String
        user.password = CocoaSecurity.aesDecryptWithBase64(parseUser["password"] as String, key: kAESKey).utf8String
        
        //thumbnail
        if let file = parseUser["avatarThumbnail"] as? PFFile {
            if let imageData = file.getData() {
                user.avatarThumbnail = imageData
            }
        }
        
        //station
        let relation = parseUser.relationForKey("stations")
        let query = relation.query()
        
        if let stations = query.findObjects(nil) {
            for station in stations {
                let s = Station.MR_createEntity() as Station
                s.name = station["name"] as String
                s.user = user
            }
        }

        return user
    }

    class func updateUserWithParseUser(user: User, parseUser: PFObject) {
        //displayName
        if let displayName = parseUser["displayName"] as? String {
            user.displayName = displayName
        }
        
        //性別
        if let gender = parseUser["gender"] as? String {
            user.gender = gender
        }
        
        //駅
        if let stations = parseUser["stations"] as? [PFObject] {
            addStationsToUser(stations, user: user)
        }
        
//        let relation = parseUser.relationForKey("stations")
//        let query = relation.
//
//        if let array = query.findObjects() as? [PFObject] {
//            addStationsToUser(array, user: user)
//        }
    }
    
    //download sns avatar
    
    class func downloadUserAvatar(user: User, done: (NSData?) -> Void) {
        let sns = user.snses.firstObject as SNS
        
        if let figureurl = sns.figureurl {

            NSURLSession.sharedSession().downloadTaskWithURL(NSURL(string: figureurl)!, completionHandler: { (path, res, error) -> Void in
                if let path = path {
                    let data = NSData(contentsOfURL: path)
                    
                    gcd.async(.Main, closure: { () -> () in
                        done(data)
                    })
                    return
                }
                
                gcd.async(.Main, closure: { () -> () in
                    //use default
                    done(UIImagePNGRepresentation(user.defaultSNSImage()))
                })
            }).resume()
            
            return
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

    func updateDisplayName(user: User, newName: String) {
        user.displayName = newName
    }
    
    // MARK: - Station
    
    class func saveStations(stations: [PFObject], user: User) {
        user.stationsSet().removeAllObjects()
        
        for station in stations {
            let s = Station.MR_createEntity() as Station
            s.name = station["name"] as String
            
            user.stationsSet().addObject(s)
        }
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

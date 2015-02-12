@objc(User)
class User: _User {
    
//    var domain: String!
//    var resources: String!
//    var port: Int!
    
    override func awakeFromInsert() {
        
    }
    var password: String {
        get {
            return SSKeychain.passwordForService(kSpotServiceName, account: uniqueIdentifier)
        }
        
        set {
//            if password == nil {
//                SSKeychain.deletePasswordForService(kSpotServiceName, account: uniqueIdentifier)
//                return
//            }
            
            SSKeychain.setPassword(newValue, forService: kSpotServiceName, account: uniqueIdentifier)
        }
    }
    
    /*
    class func signInComplete(complete: (error: NSError?) -> Void) {

        
        let userName = UICKeyChainStore.stringForKey(kKeyForUserName)
        let userPassword = UICKeyChainStore.stringForKey(kKeyForPassword)
        
        if userName != nil && userPassword != nil {
            PFUser.logInWithUsernameInBackground(userName, password: userPassword, block: { (pfUser, error) -> Void in
                if let error = error {
                    complete(error: error)
                } else {
                    complete(error: nil)
                }
            })
        } else {
            let pfUser = PFUser()
            pfUser.username = NSUUID().UUIDString.lowercaseString
            pfUser.password = NSUUID().UUIDString.lowercaseString
            
            let userInfo = PFObject(className: "UserInfo")
            let device = PFObject(className: "Device")
            device["name"] = UIDevice.currentDevice().name
            device["model"] = UIDevice.currentDevice().model
//            device.save()
            
//            let relation = userInfo.relationForKey("devices")
//            relation.addObject(device)
//            
//            userInfo.save()
            
            userInfo["devices"] = [device]
            
            pfUser["userInfo"] = userInfo
            
            pfUser.signUpInBackgroundWithBlock({ (b, error) -> Void in
                if let error = error {
                    complete(error: error)
                } else {
                    //TODO: b == false
                    if b {
                        UICKeyChainStore.setString(pfUser.username, forKey: kKeyForUserName)
                        UICKeyChainStore.setString(pfUser.password, forKey: kKeyForPassword)
                        complete(error: nil)
                    } else {
                        println(b)
                    }
                }
            })
        }
    }

    class func addFriend(name: String) {
        let friend1 = PFUser.query().getObjectWithId("6V5rV6mTyZ")
        let friend2 = PFUser.query().getObjectWithId("yXNFp0RnG1")

        let relation = PFUser.currentUser().relationForKey("friends")
        relation.addObject(friend1)
        relation.addObject(friend2)
                
        PFUser.currentUser().saveInBackgroundWithBlock(nil)
    }
    
    class func removeUser() {
        UICKeyChainStore.removeItemForKey(kKeyForUserName)
        UICKeyChainStore.removeItemForKey(kKeyForPassword)
    }
    
    class func sendMessageTo(id: String) {
        let chat = Chat.MR_createEntity() as Chat
        chat.message = "テスト"
        chat.destinationID = id
        chat.createAt = NSDate()
        chat.type = 0
        
        chat.managedObjectContext?.MR_saveToPersistentStoreWithCompletion(nil)
    }
*/
}

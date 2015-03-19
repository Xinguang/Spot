//
//  XMPPManager.swift
//  spot
//
//  Created by 張志華 on 2015/02/10.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class XMPPManager: NSObject {
//    @property (nonatomic, strong) OTRXMPPAccount *account;
//    @property (nonatomic) OTRProtocolConnectionStatus connectionStatus;
    var account: User!
    var deviceToken: String! {
        didSet {
            if didUploadedToken == false && xmppStream.isAuthenticated() {
                uploadDeviceToken()
            }
        }
    }
    var didUploadedToken = false
    
    var xmppStream: XMPPStream!
    var xmppReconnect: XMPPReconnect!
    var xmppRoster: XMPPRoster!
//    var xmppvCardTempModule: XMPPvCardTempModule!
//    var xmppvCardAvatarModule: XMPPvCardAvatarModule!
    var xmppCapabilities: XMPPCapabilities!
    var password: String!
    var JID: XMPPJID!
    var xmppCapabilitiesStorage: XMPPCapabilitiesCoreDataStorage!
    var xmppRosterStorage: XMPPRosterCoreDataStorage!
    
    var xmppMessageArchivingCoreDataStorage: XMPPMessageArchivingCoreDataStorage!
    var xmppMessageArchiving: XMPPMessageArchiving!
    
    var isXmppConnected: Bool!
    var isRegisteringNewAccount = false
    
    let workQueue = dispatch_queue_create("jp.co.e-business.spot.Workqueue", DISPATCH_QUEUE_SERIAL)
    
    var needUpdateVcard = false
    
    var getVCardDone: (() -> Void)?
    
    var xmppMuc: XMPPMUC!
    var joinedRooms = Dictionary<String, XMPPRoom>()
    
    class var roomContext: NSManagedObjectContext {
        return XMPPRoomCoreDataStorage.sharedInstance().mainThreadManagedObjectContext
    }
    
    class var instance : XMPPManager {
        struct Static {
            static let instance : XMPPManager = XMPPManager()
        }
        
        return Static.instance
    }
    
    override init() {
        super.init()
        
        setupStream()
    }
    
    private func setupStream() {
        xmppStream = XMPPStream()
        
        //Used to fetch correct account from XMPPStream in delegate methods especailly
//        self.xmppStream.tag = self.account.objectID
        
//        self.xmppStream.startTLSPolicy = XMPPStreamStartTLSPolicyRequired;
        
//        [self.certificatePinningModule activate:self.xmppStream];
        let deliveryReceiptsModule = XMPPMessageDeliveryReceipts()
        deliveryReceiptsModule.autoSendMessageDeliveryReceipts = true
        deliveryReceiptsModule.autoSendMessageDeliveryRequests = true
        deliveryReceiptsModule.activate(xmppStream)
        
        xmppStream.enableBackgroundingOnSocket = true
        
        xmppReconnect = XMPPReconnect()
        
        
        //Roster
//        let rosterStorage = DatabaseRosterStorage()
        xmppRosterStorage = XMPPRosterCoreDataStorage.sharedInstance()
        
        xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage)
        xmppRoster.autoFetchRoster = true
        xmppRoster.autoClearAllUsersAndResources = false
        xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = true
        
        xmppMessageArchivingCoreDataStorage = XMPPMessageArchivingCoreDataStorage.sharedInstance()
        xmppMessageArchiving = XMPPMessageArchiving(messageArchivingStorage: xmppMessageArchivingCoreDataStorage)
        xmppMessageArchiving.clientSideMessageArchivingOnly = true
        
        
//        let vCardCoreDataStorage = XMPPvCardCoreDataStorage.sharedInstance() as XMPPvCardCoreDataStorage
//        xmppvCardTempModule = XMPPvCardTempModule(withvCardStorage: vCardCoreDataStorage, dispatchQueue: nil)
//        xmppvCardAvatarModule = XMPPvCardAvatarModule(withvCardTempModule: xmppvCardTempModule, dispatchQueue:nil)
        
        xmppCapabilitiesStorage = XMPPCapabilitiesCoreDataStorage(inMemoryStore:())
        xmppCapabilities = XMPPCapabilities(capabilitiesStorage: xmppCapabilitiesStorage)
        
        xmppMuc = XMPPMUC()
        
        xmppReconnect.activate(xmppStream)
        xmppCapabilities.activate(xmppStream)
        xmppRoster.activate(xmppStream)
//        xmppvCardTempModule.activate(xmppStream)
//        xmppvCardAvatarModule.activate(xmppStream)
        xmppMessageArchiving.activate(xmppStream)
        xmppMuc.activate(xmppStream)
        
        xmppStream.addDelegate(self, delegateQueue: workQueue)
        xmppRoster.addDelegate(self, delegateQueue: workQueue)
//        xmppvCardTempModule.addDelegate(self, delegateQueue: workQueue)
//        xmppvCardAvatarModule.addDelegate(self, delegateQueue: workQueue)
//        xmppMuc.addDelegate(self, delegateQueue: workQueue)
        
        xmppCapabilities.addDelegate(self, delegateQueue: workQueue)
        xmppMessageArchiving.addDelegate(self, delegateQueue: workQueue)
    }
    
    class func registerWithUser(user: User) {
        instance.account = user
        instance.needUpdateVcard = true

        instance.registerNewAccountWithPassword(user.password)
    }
    
    class func loginWithUser(user: User) {
        instance.account = user
        
        instance.connectWithJID(user.openfireId!, myPassword: user.password)
    }
    
    func registerNewAccountWithPassword(password: String) {
        isRegisteringNewAccount = true
        self.password = password
        
        if xmppStream.isConnected() {
            xmppStream.disconnect()
        }
    
        connectWithJID(account.openfireId!, myPassword: password)
    }
    
    func connectWithPassword(myPassword: String) {
        connectWithJID(account.openfireId!, myPassword: myPassword)
    }
    
    func connectWithJID(myJID: String, myPassword: String) {
        password = myPassword
        xmppStream.myJID = XMPPJID.jidWithString(myJID)
        
        if xmppStream.isDisconnected() == false {
            xmppStream.authenticateWithPassword(myPassword, error: nil)
            return
        }
        
        xmppStream.hostName = kOpenFireDomainName
        var error: NSError?
        
        if !xmppStream.connectWithTimeout(15, error: &error) {
            failedToConnect(error?)
        }
    }
    
    
    func failedToConnect(error: NSError?) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            // TODO: 
            NSNotificationCenter.defaultCenter().postNotificationName(kXMPPLoginFail, object: nil)
        })
    }
    
    func failedToRegisterNewAccount(error: NSError) {
        
    }
    
    func goOnline() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName(kXMPPLoginSuccess, object: self)
        })
        
        if didUploadedToken == false && deviceToken != nil {
            uploadDeviceToken()
        }
        
        xmppStream.sendElement(XMPPPresence())
        
        createJoinedRooms()
    }
    
    func goOffline() {
        xmppStream.sendElement(XMPPPresence(type: "unavailable"))
        
    }
    
    class func updateUser(user: User) {
        let query = XMPPElement(name: "query", xmlns: "jabber:iq:register")
        let username = XMPPElement(name: "username", stringValue: XMPPJID.jidWithString(user.openfireId).user)
        let name = XMPPElement(name: "name", stringValue: user.displayName)
        
        query.addChild(username)
        query.addChild(name)
        
        let iq = XMPPIQ(type: "set", to: XMPPJID.jidWithString(kOpenFireDomainName))
        iq.addChild(query)
        
        instance.xmppStream.sendElement(iq)
    }
    
//    func updateMyImage(image: UIImage) {
//        var myvCardTemp = xmppvCardTempModule.myvCardTemp
//        if myvCardTemp == nil {
//            println("myvCardTemp==nil")
//        }
//        
//        myvCardTemp.photo = UIImagePNGRepresentation(image)
//        
//        xmppvCardTempModule.updateMyvCardTemp(myvCardTemp)
//    }
//    
//    func updateVcard() {
//        if let myvCardTemp = xmppvCardTempModule.myvCardTemp {
//            
//            if let figureurl = (account.snses.lastObject as SNS?)?.figureurl {
//                
//                NSURLSession.sharedSession().downloadTaskWithURL(NSURL(string: figureurl)!, completionHandler: { (path, res, error) -> Void in
//                    let localCard = self.xmppvCardTempModule.myvCardTemp
//                    
//                    if let nickName = (self.account.snses.lastObject as SNS?)?.nickName {
//                        localCard.formattedName = nickName
//                    }
//                    
//                    localCard.photo = NSData(contentsOfURL: path)
//                    
//                    self.xmppvCardTempModule.updateMyvCardTemp(localCard)
//                    self.needUpdateVcard = false
//
//                    
//                }).resume()
//                
//                return
//             }
//            
//            if let displayName = self.account.displayName {
//                myvCardTemp.formattedName = displayName
//                self.xmppvCardTempModule.updateMyvCardTemp(myvCardTemp)
//                self.needUpdateVcard = false
//            }
//        }
//    }
    
    // MARK: - Message
    
    func sendMessage(message: NSString, to: XMPPJID) {
        if message.length > 0 {
                let xmppMessage = XMPPMessage(type: "chat", to: to)
                xmppMessage.addBody(message)
//                xmppMessage.addActiveChatState()
            
                xmppStream.sendElement(xmppMessage)
        }
    }
}

// MARK: - XMPPStreamDelegate

extension XMPPManager: XMPPStreamDelegate {
    
    func xmppStreamDidConnect(sender: XMPPStream!) {
        if isRegisteringNewAccount {
            var error: NSError?
//            xmppStream.registerWithPassword(password, error: &error)
            var elements = [XMPPElement]()
            elements.append(XMPPElement(name: "username", stringValue: sender.myJID.user))
            elements.append(XMPPElement(name: "password", stringValue: password))
            
            if let displayName = account.displayName {
                let e = XMPPElement(name: "name", stringValue: displayName)
                elements.append(e)
            }
            
            xmppStream.registerWithElements(elements, error: &error)
            
            if let error = error {
                failedToRegisterNewAccount(error)
            }
        } else {
            xmppStream.authenticateWithPassword(password, error: nil)
        }
    }
    
    func xmppStreamConnectDidTimeout(sender: XMPPStream!) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName(kXMPPConnectTimeout, object: nil)
        })
    }
    
    func xmppStreamDidRegister(sender: XMPPStream!) {
        isRegisteringNewAccount = false
        
        connectWithPassword(password)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName(kXMPPRegisterSuccess, object: nil)
        })
    }
    
    func xmppStream(sender: XMPPStream!, didNotRegister error: DDXMLElement!) {
        println(error)
    }
    
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        goOnline()
    }
    
    func xmppStream(sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        // TODO: error
        failedToConnect(nil)
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveIQ iq: XMPPIQ!) -> Bool {
//        println("RECV:\(iq)")
//
//        if let id = iq.elementID() {
//            if id == "searchByUserName" {
//                let report = XMPPSearchReported.reportWithElement(iq) as XMPPSearchReported
//                if report.items?.count > 0 {
//                    var accounts = [XMPPAccount]()
//                    for item in report.items {
//                        // TODO: custom init
//                        var account = XMPPAccount()
//                        account.email = item["Email"] as? String
//                        account.name = item["Name"] as? String
//                        account.username = item["Username"] as? String
//                        account.jid = item["jid"] as? String
//                        
//                        accounts.append(account)
//                    }
//                    
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        NSNotificationCenter.defaultCenter().postNotificationName(kXMPPSearchAccountComplete, object: accounts)
//                    })
//                } else {
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        NSNotificationCenter.defaultCenter().postNotificationName(kXMPPSearchAccountComplete, object: nil)
//                    })
//                }
//            }
//        }
////        dispatch_async(dispatch_get_main_queue(), { () -> Void in
////            SVProgressHUD.dismiss()
////        })
////        
////        if let query = iq.elementForName("query", xmlns: "jabber:iq:search") {
////            if let x = query.elementForName("x", xmlns: "jabber:x:data") {
////                if let item = x.elementForName("item") {
////                    let items = item.elementsForName("Field") as [XMPPElement]
////                    for element in items {
//////                        element.el
////                    }
////                }
////            }
////        }
//        
//
//        
        return true
    }
    
    func xmppStream(sender: XMPPStream!, didSendIQ iq: XMPPIQ!) {
//        println("SEND:\(iq)")
    }
    
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
//        println("RECV:\(presence)")
    }
    
    
    func xmppStream(sender: XMPPStream!, didSendPresence presence: XMPPPresence!) {
//        println("SEND:\(presence)")
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
//        println("RECV:\(message)")
        
        if self.dynamicType.isInviteMessage(message) {
            return
        }
        
//        if xmppMuc.isMUCRoomMessage(message) {
//            return
//        }
        
        if UIApplication.sharedApplication().applicationState != .Active {
            Friend.saveUnreadMessage(message, done: { () -> Void in
                self.showLocalNotification(message)
            })
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                NSNotificationCenter.defaultCenter().postNotificationName(kXMPPReceivedMessage, object: message)
            })
        }
    }
    
    func showLocalNotification(message: XMPPMessage) {
        let notification = UILocalNotification()
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.applicationIconBadgeNumber = Friend.numberOfUnreadMessages()
        notification.alertBody = "\(fromStrOfMessage(message)): \(message.body())"
        
        notification.userInfo = ["kNotificationFriendAccountName" : message.fromStr()]
        
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
}

// MARK: - XMPPRosterDelegate

extension XMPPManager: XMPPRosterDelegate {
    
    func xmppRoster(sender: XMPPRoster!, didReceivePresenceSubscriptionRequest presence: XMPPPresence!) {
        xmppRoster.acceptPresenceSubscriptionRequestFrom(presence.from(), andAddToRoster: true)
//        let jidStrBare = presence.fromStr()
//        var request = FriendRequest.MR_findFirstByAttribute("jid", withValue: jidStrBare) as? FriendRequest
//        if request == nil {
//            request = FriendRequest.MR_createEntity() as? FriendRequest
//        }
//        
//        request!.jid = jidStrBare
//        
//        request!.managedObjectContext?.MR_saveToPersistentStoreWithCompletion(nil)
    }
    
    func xmppRosterDidEndPopulating(sender: XMPPRoster!) {
        println(__FUNCTION__)
    }
}

// MARK: - XMPPvCardTempModuleDelegate

extension XMPPManager: XMPPvCardTempModuleDelegate {
    
    func xmppvCardTempModule(vCardTempModule: XMPPvCardTempModule!, didReceivevCardTemp vCardTemp: XMPPvCardTemp!, forJID jid: XMPPJID!) {
        if isMe(jid) && needUpdateVcard {
            
//            updateVcard()
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.getVCardDone?()

            NSNotificationCenter.defaultCenter().postNotificationName(kXMPPDidReceivevCardTemp, object: nil)
        })
    }
}

// MARK: - XMPPvCardAvatarDelegate

//extension XMPPManager: XMPPvCardAvatarDelegate {
//    
//    func xmppvCardAvatarModule(vCardTempModule: XMPPvCardAvatarModule!, didReceivePhoto photo: UIImage!, forJID jid: XMPPJID!) {
//            account.updateWithVcard(vCardTempModule)
//        
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            NSNotificationCenter.defaultCenter().postNotificationName(kXMPPDidReceiveAvata, object: nil)
//        })
//    }
//}

// MARK: - Search

extension XMPPManager {
    
    func search(word: String) {

//        var iq = XMPPIQ()
//        iq.addAttributeWithName("type", stringValue: "get")
//        iq.addAttributeWithName("from", stringValue: account.openfireId)
//        iq.addAttributeWithName("to", stringValue: "search." + kOpenFireDomainName)
//        iq.addAttributeWithName("id", stringValue: "search1")
//        
//        var query = XMPPElement(name: "query", xmlns: "jabber:iq:search")
//        iq.addChild(query)
//        
//        xmppStream.sendElement(iq)
        
        var iq = XMPPIQ()
        iq.addAttributeWithName("type", stringValue: "set")
        iq.addAttributeWithName("from", stringValue: account.openfireId)
        iq.addAttributeWithName("to", stringValue: "search." + kOpenFireDomainName)
//        iq.addAttributeWithName("id", stringValue: "search2")
        iq.addAttributeWithName("id", stringValue: "searchByUserName")
        
        
        var formType = XMPPElement(name: "field")
        formType.addAttributeWithName("type", stringValue: "hidden")
        formType.addAttributeWithName("var", stringValue: "FORM_TYPE")
        formType.addChild(XMPPElement(name: "value", stringValue: "jabber:iq:search"))
        
        var username = XMPPElement(name: "field")
        username.addAttributeWithName("var", stringValue: "Username")
        username.addChild(XMPPElement(name: "value", stringValue: "1"))
        
        var search = XMPPElement(name: "field")
        search.addAttributeWithName("var", stringValue: "search")
        search.addChild(XMPPElement(name: "value", stringValue: word))
        
        var x = XMPPElement(name: "x", xmlns: "jabber:x:data")
        x.addAttributeWithName("type", stringValue: "submit")
        x.addChild(formType)
        x.addChild(username)
        x.addChild(search)
        
        var query = XMPPElement(name: "query", xmlns: "jabber:iq:search")
        query.addChild(x)
        
        
        iq.addChild(query)
        
        xmppStream.sendElement(iq)

    }

}

// MARK: - XMPPMUCDelegate

extension XMPPManager: XMPPMUCDelegate {
    
//    func xmppMUC(sender: XMPPMUC!, didDiscoverServices services: [AnyObject]!) {
//        for service in services {
//            if let s = service as? DDXMLElement {
//                let jid = s.attributeStringValueForName("jid")
//                sender.discoverRoomsForServiceNamed(jid)
//            }
//        }
//    }
    
    func xmppMUC(sender: XMPPMUC!, didDiscoverRooms rooms: [AnyObject]!, forServiceNamed serviceName: String!) {
        for room in rooms {
            if let e = room as? DDXMLElement {
                let roomJID = XMPPJID.jidWithString(e.attributeStringValueForName("jid"))
                self.dynamicType.createRoomWithRoomJId(roomJID)
            }
        }
    }
    
    func xmppMUC(sender: XMPPMUC!, roomJID: XMPPJID!, didReceiveInvitation message: XMPPMessage!) {
//        println("RECV:\(message)")
        
        gcd.async(.Main, closure: { () -> () in
            self.dynamicType.createRoomWithRoomJId(roomJID)
        })
    }
}

// MARK: - XMPPRoomDelegate

extension XMPPManager: XMPPRoomDelegate {
    
//    func xmppRoom(sender: XMPPRoom!, didFetchConfigurationForm configForm: DDXMLElement!) {
//        sender.configureRoomUsingOptions(nil)
//        
//        sender.joinRoomUsingNickname(account.username, history: nil)
//    }
    
    
    func xmppRoom(sender: XMPPRoom!, didFetchMembersList items: [AnyObject]!) {
        println(items)
    }
    
    func xmppRoomDidCreate(sender: XMPPRoom!) {
        println(__FUNCTION__)
        
        sender.configureRoomUsingOptions(nil)
        
        gcd.async(.Main, closure: { () -> () in
            NSNotificationCenter.defaultCenter().postNotificationName(kXMPPRoomCreated, object: sender)
        })
//        sender.sendMessageWithBody("test")
    }
    
    func xmppRoomDidJoin(sender: XMPPRoom!) {
        println(__FUNCTION__)
        
        joinedRooms[sender.roomJID.bare()] = sender
        
//        sender.fetchMembersList()
        
        gcd.async(.Main, closure: { () -> () in
            NSNotificationCenter.defaultCenter().postNotificationName(kXMPPRoomJoined, object: sender)
        })
    }
    
    func xmppRoom(sender: XMPPRoom!, didReceiveMessage message: XMPPMessage!, fromOccupant occupantJID: XMPPJID!) {
        
    }
    
}

// MARK: - Support

extension XMPPManager {
    
    class func addFriend(pUser: PFObject) {
        let jid = XMPPJID.jidWithString(pUser["openfireId"] as String)
        let nickName = pUser["displayName"] as? String
            
        instance.xmppRoster.addUser(jid, withNickname: nickName)
    }
    
    func uploadDeviceToken() {
        didUploadedToken = true
        
        let query = XMPPElement(name: "query", xmlns: "urn:xmpp:apns")
        let token = XMPPElement(name: "token", stringValue: deviceToken)
        query.addChild(token)
        
        let iq = XMPPIQ(type: "set", to: XMPPJID.jidWithString(kOpenFireDomainName), elementID: "123", child: query)
        xmppStream.sendElement(iq)
    }
    
    func photoOfJid(jid: XMPPJID) -> UIImage {
        var orgImage = UIImage(named: "avatar")
        
//        if let data = XMPPManager.instance.xmppvCardAvatarModule.photoDataForJID(jid) {
//            orgImage = UIImage(data: data)
//        }
        
        let image = JSQMessagesAvatarImageFactory.avatarImageWithImage(orgImage, diameter: 75)

        return image.avatarImage
    }
    
    func userForJID(jid: XMPPJID) -> XMPPUserCoreDataStorageObject? {
        return xmppRosterStorage.userForJID(jid, xmppStream: xmppStream, managedObjectContext: xmppRosterStorage.mainThreadManagedObjectContext)
    }
    
    func fromStrOfMessage(message: XMPPMessage) -> String {
        var from = message.from().user
    
//        if let user = self.xmppvCardTempModule.vCardTempForJID(message.from(), shouldFetch: false) {
//            from = user.formattedName ?? "匿名"
//        }
        
        return from

    }
    
    func displayNameOfJid(jid: XMPPJID) -> String {
        let user = userForJID(jid)
        
//        if let card = xmppvCardTempModule.vCardTempForJID(jid, shouldFetch: true) {
//            return card.formattedName ?? "匿名"
//        }
        
        return "匿名"
    }
    
    func isFriend(jid: XMPPJID) -> Bool {
        return xmppRosterStorage.userExistsWithJID(jid, xmppStream: xmppStream)
    }
    
    func isMe(jid: XMPPJID) -> Bool {
        return jid.bare() == account.openfireId
    }
    
    class func getVCard(jid: XMPPJID, done: (() -> Void)?) {
        instance.getVCardDone = done
        
//        instance.xmppvCardTempModule.fetchvCardTempForJID(jid, ignoreStorage: true)
    }
    
//    class func vCardOfJid(jid: XMPPJID) -> XMPPvCardTemp? {
//        return instance.xmppvCardTempModule.vCardTempForJID(jid, shouldFetch: true)
//    }

    func createJoinedRooms() {
//        let res = XMPPRoomMessageCoreDataStorageObject.MR_findAllInContext(roomContext) as? [XMPPRoomMessageCoreDataStorageObject]
//        
//        if let res = res {
//            if res.count > 0 {
//                for obj in res {
//                    createRoomWithRoomJId(obj.roomJID)
//                }
//            }
//        }
        
//        xmppMuc.discoverServices()
//        xmppMuc.discoverRoomsForServiceNamed(kRoomPath)
    }
    
    class func createNewRoom() {
        let uuid = NSUUID().UUIDString.lowercaseString
        
        let roomJID = XMPPJID.jidWithString("\(uuid)@\(kRoomPath)")
        
        createRoomWithRoomJId(roomJID)
    }
    
//    class func createRoomWithFriends(friends: [XMPPUserCoreDataStorageObject]) {
//        let uuid = NSUUID().UUIDString.lowercaseString
//
//        let roomJID = XMPPJID.jidWithString("\(uuid)@\(kRoomPath)")
//
//        createRoomWithRoomJId(roomJID)
//    }

    class func createRoomWithRoomJId(roomJID: XMPPJID) {
        let room = XMPPRoom(roomStorage: XMPPRoomCoreDataStorage.sharedInstance(), jid: roomJID, dispatchQueue: dispatch_get_main_queue())
        room.activate(instance.xmppStream)
        room.addDelegate(instance, delegateQueue: instance.workQueue)
//        room.fetchConfigurationForm()
        
//        let history = XMPPElement(name: "history", numberValue: 0)
        room.joinRoomUsingNickname(instance.account.username, history: nil)
        
//        instance.joinedRooms.append(room)
    }
    
    class func inviteUserToRoom(room: XMPPRoom, jid: XMPPJID) {
        room.inviteUser(jid, withMessage: "invite")
    }
    
    class func jidOfNickname(nickname: String, room: XMPPRoom) {
        
    }
    
    class func isInviteMessage(message: XMPPMessage) -> Bool {
        if let x = message.elementForName("x", xmlns: "http://jabber.org/protocol/muc#user") {
            if let invite = x.elementForName("invite") {
                return true
            }
            
            if let decline = x.elementForName("decline") {
                return true
            }
        }
        
        return false
    }
    
    class func countOfRoom(jidStr: String) -> UInt {
        return XMPPRoomOccupantCoreDataStorageObject.MR_countOfEntitiesWithPredicate(NSPredicate(format: "roomJIDStr = %@", argumentArray: [jidStr]), inContext: roomContext)
    }
    
    class func updateUserIn(user: User) {
        
    }
}
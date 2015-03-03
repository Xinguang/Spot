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
    var xmppvCardTempModule: XMPPvCardTempModule!
    var xmppvCardAvatarModule: XMPPvCardAvatarModule!
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
//    @property (nonatomic, strong) XMPPStream *xmppStream;
//    @property (nonatomic, strong) XMPPReconnect *xmppReconnect;
//    @property (nonatomic, strong) XMPPRoster *xmppRoster;
//    @property (nonatomic, strong) XMPPvCardTempModule *xmppvCardTempModule;
//    @property (nonatomic, strong) XMPPvCardAvatarModule *xmppvCardAvatarModule;
//    @property (nonatomic, strong) XMPPCapabilities *xmppCapabilities;
//    @property (nonatomic, strong) NSString *password;
//    @property (nonatomic, strong) XMPPJID *JID;
//    @property (nonatomic, strong) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
//    @property (nonatomic, strong) OTRYapDatabaseRosterStorage * xmppRosterStorage;
//    @property (nonatomic, strong) OTRCertificatePinning * certificatePinningModule;
//    @property (nonatomic, readwrite) BOOL isXmppConnected;
//    @property (nonatomic, strong) NSMutableDictionary * buddyTimers;
//    @property (nonatomic) dispatch_queue_t workQueue;
//    @property (nonatomic) BOOL isRegisteringNewAccount;
//    
//    @property (nonatomic, strong) YapDatabaseConnection *databaseConnection;
    
    class var instance : XMPPManager {
        struct Static {
            static let instance : XMPPManager = XMPPManager()
        }
        
        return Static.instance
    }
    
    override init() {
        super.init()
        
//        workQueue = dispatch_queue_create("jp.co.e-business.spot.Workqueue", 0)
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
        
        
        let vCardCoreDataStorage = XMPPvCardCoreDataStorage.sharedInstance() as XMPPvCardCoreDataStorage
        xmppvCardTempModule = XMPPvCardTempModule(withvCardStorage: vCardCoreDataStorage, dispatchQueue: nil)
        xmppvCardAvatarModule = XMPPvCardAvatarModule(withvCardTempModule: xmppvCardTempModule, dispatchQueue:nil)
        
        xmppCapabilitiesStorage = XMPPCapabilitiesCoreDataStorage(inMemoryStore:())
        xmppCapabilities = XMPPCapabilities(capabilitiesStorage: xmppCapabilitiesStorage)
        
        xmppReconnect.activate(xmppStream)
        xmppCapabilities.activate(xmppStream)
        xmppRoster.activate(xmppStream)
        xmppvCardTempModule.activate(xmppStream)
        xmppvCardAvatarModule.activate(xmppStream)
        xmppMessageArchiving.activate(xmppStream)
        
        xmppStream.addDelegate(self, delegateQueue: workQueue)
        xmppRoster.addDelegate(self, delegateQueue: workQueue)
        xmppvCardTempModule.addDelegate(self, delegateQueue: workQueue)
        xmppvCardAvatarModule.addDelegate(self, delegateQueue: workQueue)
        
        xmppCapabilities.addDelegate(self, delegateQueue: workQueue)
        xmppMessageArchiving.addDelegate(self, delegateQueue: workQueue)
    }
    
    func registerNewAccountWithPassword(password: String) {
        isRegisteringNewAccount = true
        self.password = password
        
        if xmppStream.isConnected() {
            xmppStream.disconnect()
        }
    
        connectWithJID(account.username!, myPassword: password)
    }
    
    func connectWithPassword(myPassword: String) {
        connectWithJID(account.username!, myPassword: myPassword)
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
        
        if !xmppStream.connectWithTimeout(XMPPStreamTimeoutNone, error: &error) {
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
    }
    
    func goOffline() {
        xmppStream.sendElement(XMPPPresence(type: "unavailable"))
    }
    
//    func addFriend(friend: Friend) {
//        let jid = XMPPJID.jidWithString(friend.accountName)
//        // TODO: nickName
//        xmppRoster.addUser(jid, withNickname: friend.displayName)
//    }
    
    func updateMyName(name: String) {
        var myvCardTemp = xmppvCardTempModule.myvCardTemp
        if myvCardTemp == nil {
            println("myvCardTemp==nil")
        }
        
        myvCardTemp.formattedName = name
        
        xmppvCardTempModule.updateMyvCardTemp(myvCardTemp)
    }
    
    func updateMyImage(image: UIImage) {
        var myvCardTemp = xmppvCardTempModule.myvCardTemp
        if myvCardTemp == nil {
            println("myvCardTemp==nil")
        }
        
        myvCardTemp.photo = UIImagePNGRepresentation(image)
        
        xmppvCardTempModule.updateMyvCardTemp(myvCardTemp)
    }
    
    func updateVcard() {
        if let myvCardTemp = xmppvCardTempModule.myvCardTemp {
            
            if let figureurl = account.figureurl {
                
                NSURLSession.sharedSession().downloadTaskWithURL(NSURL(string: figureurl)!, completionHandler: { (path, res, error) -> Void in
                    let localCard = self.xmppvCardTempModule.myvCardTemp
                    
                    if let displayName = self.account.displayName {
                        localCard.formattedName = displayName
                    }
                    
                    localCard.photo = NSData(contentsOfURL: path)
                    
                    self.xmppvCardTempModule.updateMyvCardTemp(localCard)
                    self.needUpdateVcard = false

                    
                }).resume()
                
//                Net().GET(figureurl, params: nil, successHandler: {(resData) -> () in
//                    myvCardTemp.photo = UIImagePNGRepresentation(resData)
//                    }, failureHandler: {(err) -> () in }).resume()
            }
//            myvCardTemp.photo = UIImagePNGRepresentation(image)
        
//            xmppvCardTempModule.updateMyvCardTemp(myvCardTemp)
        }
    }
    
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
    
    func xmppStreamDidRegister(sender: XMPPStream!) {
        isRegisteringNewAccount = false
        
        connectWithPassword(password)
        
        NSNotificationCenter.defaultCenter().postNotificationName(kXMPPRegisterSuccess, object: nil)
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
        println(iq)
        
        if let id = iq.elementID() {
            if id == "searchByUserName" {
                let report = XMPPSearchReported.reportWithElement(iq) as XMPPSearchReported
                if report.items?.count > 0 {
                    var accounts = [XMPPAccount]()
                    for item in report.items {
                        // TODO: custom init
                        var account = XMPPAccount()
                        account.email = item["Email"] as? String
                        account.name = item["Name"] as? String
                        account.username = item["Username"] as? String
                        account.jid = item["jid"] as? String
                        
                        accounts.append(account)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        NSNotificationCenter.defaultCenter().postNotificationName(kXMPPSearchAccountComplete, object: accounts)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        NSNotificationCenter.defaultCenter().postNotificationName(kXMPPSearchAccountComplete, object: nil)
                    })
                }
            }
        }
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            SVProgressHUD.dismiss()
//        })
//        
//        if let query = iq.elementForName("query", xmlns: "jabber:iq:search") {
//            if let x = query.elementForName("x", xmlns: "jabber:x:data") {
//                if let item = x.elementForName("item") {
//                    let items = item.elementsForName("Field") as [XMPPElement]
//                    for element in items {
////                        element.el
//                    }
//                }
//            }
//        }
        

        
        return false
    }
    
    func xmppStream(sender: XMPPStream!, didSendIQ iq: XMPPIQ!) {
        println(iq)
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
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
            
            updateVcard()
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName(kXMPPDidReceivevCardTemp, object: nil)
        })
    }
}

// MARK: - XMPPvCardAvatarDelegate

extension XMPPManager: XMPPvCardAvatarDelegate {
    
    func xmppvCardAvatarModule(vCardTempModule: XMPPvCardAvatarModule!, didReceivePhoto photo: UIImage!, forJID jid: XMPPJID!) {
            account.updateWithVcard(vCardTempModule)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName(kXMPPDidReceiveAvata, object: nil)
        })
    }
}

// MARK: - Search

extension XMPPManager {
    
    func search(word: String) {

//        var iq = XMPPIQ()
//        iq.addAttributeWithName("type", stringValue: "get")
//        iq.addAttributeWithName("from", stringValue: account.username)
//        iq.addAttributeWithName("to", stringValue: "search." + kOpenFireDomainName)
//        iq.addAttributeWithName("id", stringValue: "search1")
//        
//        var query = XMPPElement(name: "query", xmlns: "jabber:iq:search")
//        iq.addChild(query)
//        
//        xmppStream.sendElement(iq)
        
        var iq = XMPPIQ()
        iq.addAttributeWithName("type", stringValue: "set")
        iq.addAttributeWithName("from", stringValue: account.username)
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

// MARK: - Support

extension XMPPManager {
    
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
        
        if let data = XMPPManager.instance.xmppvCardAvatarModule.photoDataForJID(jid) {
            orgImage = UIImage(data: data)
        }
        
        let image = JSQMessagesAvatarImageFactory.avatarImageWithImage(orgImage, diameter: 75)

        return image.avatarImage
    }
    
    func userForJID(jid: XMPPJID) -> XMPPUserCoreDataStorageObject? {
        return xmppRosterStorage.userForJID(jid, xmppStream: xmppStream, managedObjectContext: xmppRosterStorage.mainThreadManagedObjectContext)
    }
    
    func fromStrOfMessage(message: XMPPMessage) -> String {
        var from = message.from().user
    
        if let user = self.xmppvCardTempModule.vCardTempForJID(message.from(), shouldFetch: false) {
            from = user.formattedName ?? message.from().user
        }
        
        return from

    }
    
    func isFriend(jid: XMPPJID) -> Bool {
        return xmppRosterStorage.userExistsWithJID(jid, xmppStream: xmppStream)
    }
    
    func isMe(jid: XMPPJID) -> Bool {
        return jid.bare() == account.username
    }
}
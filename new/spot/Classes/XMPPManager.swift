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
        
        xmppStream.sendElement(XMPPPresence())
    }
    
    func goOffline() {
        xmppStream.sendElement(XMPPPresence(type: "unavailable"))
    }
    
    func addFriend(friend: Friend) {
        let jid = XMPPJID.jidWithString(friend.accountName)
        // TODO: nickName
        xmppRoster.addUser(jid, withNickname: friend.displayName)
    }
    
    func updateMyName(name: String) {
        var myvCardTemp = xmppvCardTempModule.myvCardTemp
        if myvCardTemp == nil {
            println("myvCardTemp==nil")
        }
        
        myvCardTemp.formattedName = name
        
        xmppvCardTempModule.updateMyvCardTemp(myvCardTemp)
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
        
        return false
    }
    
    func xmppStream(sender: XMPPStream!, didSendIQ iq: XMPPIQ!) {
        println(iq)
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
//        if let friend = Friend.MR_findFirstByAttribute("accountName", withValue: message.from().bare()) as? Friend {
//            
//            if message.isErrorMessage() {
//                println(message.errorMessage())
//            } else if message.hasChatState() {
//                // TODO: save chat state
//            }
//            
//            if message.hasReceiptResponse() && !message.isErrorMessage() {
//                // TODO: save response
//            }
//            
//            if message.isMessageWithBody() && !message.isErrorMessage() {
//                let body = message.elementForName("body").stringValue()
//                let date = message.delayedDeliveryDate()
//                
//                let messageDB = SpotMessage.MR_createEntity() as SpotMessage
//                messageDB.incoming = true as Bool
//                messageDB.text = body
//                
//                if date != nil {
//                    messageDB.createAt = date
//                }
//                
//                messageDB.messageId = message.elementID()
//                
//                friend.lastMessageDate = messageDB.createAt
//                
//                messageDB.friend = friend
//                
//                NSManagedObjectContext.MR_contextForCurrentThread().MR_saveToPersistentStoreWithCompletion({ (b, error) -> Void in
//                    let m = messageDB.MR_inThreadContext() as SpotMessage
//                    SpotMessage.showLocalNotificationForMessage(m)
//                })
//            }
//        }
        
        
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
    
}

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
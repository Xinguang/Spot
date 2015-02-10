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
//    var xmppRosterStorage: OTRYapDatabaseRosterStorage
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
        
        xmppCapabilitiesStorage = XMPPCapabilitiesCoreDataStorage(inMemoryStore:())
        xmppCapabilities = XMPPCapabilities(capabilitiesStorage: xmppCapabilitiesStorage)
        
        xmppReconnect.activate(xmppStream)
        xmppCapabilities.activate(xmppStream)
        
        xmppStream.addDelegate(self, delegateQueue: workQueue)
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
        connectWithJID(account.username!, myPassword: password)
    }
    
    func connectWithJID(myJID: String, myPassword: String) {
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
        NSNotificationCenter.defaultCenter().postNotificationName(kXMPPLoginSuccess, object: nil)
        
        xmppStream.sendElement(XMPPPresence())
    }
    
    func goOffline() {
        xmppStream.sendElement(XMPPPresence(type: "unavailable"))
    }
}

extension XMPPManager: XMPPStreamDelegate {
    func xmppStreamDidConnect(sender: XMPPStream!) {
        if isRegisteringNewAccount {
            var error: NSError?
            xmppStream.registerWithPassword(password, error: &error)
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
    
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        goOnline()
    }
}
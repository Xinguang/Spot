//
//  AppDelegate.swift
//  spot
//
//  Created by 張志華 on 2015/02/04.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        DDLog.addLogger(DDTTYLogger.sharedInstance(), withLogLevel: XMPP_LOG_FLAG_SEND)
        DDLog.addLogger(DDTTYLogger.sharedInstance(), withLogLevel: XMPP_LOG_FLAG_RECV_POST)
        
        MagicalRecord.setupAutoMigratingCoreDataStack()
        
        Parse.setApplicationId(kParseId, clientKey: kClientKey)
        
        
//        GMSServices.provideAPIKey(kGoogleApiKey);
        
        var types: UIUserNotificationType = UIUserNotificationType.Badge |
            UIUserNotificationType.Alert |
            UIUserNotificationType.Sound
        
        var settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
        
        application.registerUserNotificationSettings( settings )
        application.registerForRemoteNotifications()
        
        application.applicationIconBadgeNumber = 0
        
        if let user = UserController.autoLoginUser() {
            let vc = Util.createViewControllerWithIdentifier("LoadingViewController", storyboardName: "Main")
            self.window?.rootViewController = vc
            
            XMPPManager.loginWithUser(user)
        }
        
        return true
    }

//    func autoLogin() {
//        if let user = DatabaseManager.instance.autoLoginAccount() {
//            XMPPManager.instance.account = user
//            
//            if user.password != nil {
//                XMPPManager.instance.connectWithPassword(user.password)
//            
//                let vc = Util.createViewControllerWithIdentifier("TabBarController", storyboardName: "Main")
//                self.window?.rootViewController = vc
//            }
//        }
//    }
    
    func reLogin() {
        if XMPPManager.instance.account != nil && XMPPManager.instance.xmppStream.isDisconnected() {
            XMPPManager.instance.connectWithPassword(XMPPManager.instance.account.password)
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        application.applicationIconBadgeNumber = Friend.numberOfUnreadMessages()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        reLogin()
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    //////////////////////////////////////////////////////
    //////////////////////////////////////////////////////
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        //SDK_QQhelper.getCallbakc(url)
        return WXApi.handleOpenURL(url, delegate: SNSController.instance)||TencentOAuth.HandleOpenURL(url);
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        //SDK_QQhelper.getCallbakc(url)
        return WXApi.handleOpenURL(url, delegate: SNSController.instance)||TencentOAuth.HandleOpenURL(url);
    }

    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData ) {
        
        // <>と" "(空白)を取る
        var characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        var deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        XMPPManager.instance.deviceToken = deviceTokenString
        
    }
    
    func application(application: UIApplication!, didFailToRegisterForRemoteNotificationsWithError error: NSError!) {
        // プッシュ通知が利用不可であればerrorが返ってくる
        println("error: " + "\(error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println(__FUNCTION__)
    }
}


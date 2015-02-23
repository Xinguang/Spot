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
        MagicalRecord.setupAutoMigratingCoreDataStack()
        
        Parse.setApplicationId(kParseId, clientKey: kClientKey)
        
        
        GMSServices.provideAPIKey(kGoogleApiKey);
        
        application.applicationIconBadgeNumber = 0
        autoLogin()
        
        return true
    }

    func autoLogin() {
        if let user = DatabaseManager.instance.autoLoginAccount() {
            XMPPManager.instance.account = user
            
            if user.password != nil {
                XMPPManager.instance.connectWithPassword(user.password)
            
                let vc = Util.createViewControllerWithIdentifier("TabBarController", storyboardName: "Main")
                self.window?.rootViewController = vc
            }
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        application.applicationIconBadgeNumber = SpotMessage.numberOfUnreadMessages()
    }

    func applicationWillEnterForeground(application: UIApplication) {
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
        return WXApi.handleOpenURL(url, delegate: SNSController.instance)//||TencentOAuth.HandleOpenURL(url);
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        //SDK_QQhelper.getCallbakc(url)
        return WXApi.handleOpenURL(url, delegate: SNSController.instance)//||TencentOAuth.HandleOpenURL(url);
    }

}


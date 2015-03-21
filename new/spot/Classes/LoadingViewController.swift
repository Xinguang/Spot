//
//  LoadingViewController.swift
//  spot
//
//  Created by 張志華 on 2015/03/03.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class LoadingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.showWithStatus("ログイン", maskType: .Clear)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("xmppConnectTimeout:"), name: kXMPPConnectTimeout, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("xmppLoginFailed:"), name: kXMPPLoginFail, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("xmppLoginSuccess:"), name: kXMPPLoginSuccess, object: nil)
    }

    //logoutも呼ばれる
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //logoutも呼ばれる
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //logout呼ばれない
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Notification
    
    func xmppConnectTimeout(notification: NSNotification) {
        SVProgressHUD.showErrorWithStatus("タイムアウト", maskType: .Clear)
    }
    
    func xmppLoginFailed(notification: NSNotification) {
        SVProgressHUD.showErrorWithStatus("ログイン失敗", maskType: .Clear)
    }
    
    func xmppLoginSuccess(notification: NSNotification) {
        SVProgressHUD.dismiss()
        
        performSegueWithIdentifier("SegueTabModal", sender: nil)
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

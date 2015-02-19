//
//  LoginViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/04.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("xmppLoginFailed:"), name: kXMPPLoginFail, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("xmppLoginSuccess:"), name: kXMPPLoginSuccess, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Notification
    
    func xmppLoginFailed(notification: NSNotification) {
        SVProgressHUD.dismiss()
        
        // TODO:
    }
    
    func xmppLoginSuccess(notification: NSNotification) {
        let account = User.MR_createEntity() as User
        account.uniqueIdentifier = NSUUID().UUIDString.lowercaseString
        account.username = usernameTF.text.trimmed() + "@" + kOpenFireDomainName
        account.password = passwordTF.text
        account.managedObjectContext?.MR_saveToPersistentStoreWithCompletion({ (b, error) -> Void in
            XMPPManager.instance.account = account
            SVProgressHUD.dismiss()
            
            self.performSegueWithIdentifier("SegueTabBar", sender: nil)
        })
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }

    // MARK: - Action
    
    @IBAction func signUpBtnClicked(sender: AnyObject) {
        let createAccountVCNavi = Util.createViewControllerWithIdentifier(nil, storyboardName: "Common") as UINavigationController
        let createAccountVC = createAccountVCNavi.topViewController as XMPPCreateAccountViewController
        createAccountVC.delegate = self
        self.presentViewController(createAccountVCNavi, animated: true, completion: nil)
    }
    
    @IBAction func signinBtnClicked(sender: AnyObject) {
        SVProgressHUD.showWithMaskType(.Clear)
        
        XMPPManager.instance.connectWithJID(usernameTF.text.trimmed() + "@" + kOpenFireDomainName, myPassword: passwordTF.text)
    }
    
    @IBAction func skipBtnTapped(sender: AnyObject) {
//        SNSController.instance.SendAuth()
//        SVProgressHUD.show()
//        
//        User.signInComplete { (error) -> Void in
//            SVProgressHUD.dismiss()
//            
//            if let error = error {
//                println(error.localizedDescription)
//            } else {
//                self.performSegueWithIdentifier("SegueTabBar", sender: nil)
//            }
//        }
    }
    
    @IBAction func debug(sender: AnyObject) {
//        User.removeUser()
    }

}

// MARK: - XMPPCreateAccountViewControllerDelegate

extension LoginViewController: XMPPCreateAccountViewControllerDelegate {
    func createAccountViewControllerDidLogin() {
        self.performSegueWithIdentifier("SegueTabBar", sender: nil)
    }
}

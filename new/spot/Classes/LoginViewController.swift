//
//  LoginViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/04.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

enum LoginType {
    case SNS,SignIn,Skip
}

class LoginViewController: BaseViewController {

    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var user: User!

    var loginType: LoginType!

    var needUploadToParse = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("xmppLoginFailed:"), name: kXMPPLoginFail, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("xmppLoginSuccess:"), name: kXMPPLoginSuccess, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("xmppRegisterFailed:"), name: kXMPPRegisterFailed, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("xmppRegisterSuccess:"), name: kXMPPRegisterSuccess, object: nil)
        
        //self.usernameTF?.addTarget(self, action: Selector("endEdit:"), forControlEvents: UIControlEvents.EditingDidEndOnExit)
        self.passwordTF?.addTarget(self, action: Selector("endEdit:"), forControlEvents: UIControlEvents.EditingDidEndOnExit)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Notification
    
    func xmppLoginFailed(notification: NSNotification) {
        SVProgressHUD.showErrorWithStatus("ログイン失敗", maskType: .Clear)
        
        // TODO:
    }
    
    func xmppLoginSuccess(notification: NSNotification) {
        if loginType == .SNS {
            UserController.saveUser(self.user)
            
            if needUploadToParse {
                ParseController.uploadUser(user, done: { (error) -> Void in
                    if let error = error {
                        SVProgressHUD.showErrorWithStatus(error.localizedDescription, maskType: .Clear)
                        return
                    }
                })
            }
        } else if loginType == .SignIn {
            UserController.saveUserAndWait(self.user)
        }

        self.goToTabView()
    }
    
    func goToTabView() {
        SVProgressHUD.dismiss()
        self.performSegueWithIdentifier("SegueTabBar", sender: nil)
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
        let username = usernameTF.text.trimmed()
        let password = passwordTF.text
        
        if username.length == 0 || password.length == 0 {
            SVProgressHUD.showErrorWithStatus("入力エラー", maskType: .Gradient)
            return
        }
        
        SVProgressHUD.showWithMaskType(.Clear)
        
//        ParseController.getFullUserInfoFromParse(username, done: { (pUser, error) -> Void in
        ParseController.getUserByKey("username", value: username, result: { (pUser, error) -> Void in
            if let error = error {
                // TODO: error info
                //Error Domain=Parse Code=101 "The operation couldn’t be completed. (Parse error 101.)" UserInfo=0x7fb801285210 {error=no results matched the query, code=101}
                SVProgressHUD.showErrorWithStatus(error.localizedDescription, maskType: .Gradient)
                return
            }
            
            if let pUser = pUser {
                let passwordOnParse = CocoaSecurity.aesDecryptWithBase64(pUser["password"] as String, key: kAESKey).utf8String
                
                if password != passwordOnParse {
                    SVProgressHUD.showErrorWithStatus("パスワードが間違っています。", maskType: .Gradient)
                    return
                }
                
                self.user = UserController.userFromParseUser(pUser)
                
                self.loginType = .SignIn
                XMPPManager.loginWithUser(self.user)
            }  else {
                SVProgressHUD.showErrorWithStatus("ユーザーが存在しません", maskType: .Gradient)
            }
        })
    }
    
    @IBAction func skipBtnTapped(sender: AnyObject) {
        SVProgressHUD.showInfoWithStatus("暂时停止匿名登陆", maskType: .Clear)
//        SVProgressHUD.showWithMaskType(.Clear)
//
//        user = UserController.anonymousUser()
//        loginType = .Skip
//
//        XMPPManager.registerWithUser(user)
    }
    
    @IBAction func wxBtnTapped(sender: AnyObject) {
        SVProgressHUD.showWithMaskType(.Clear)
        // TODO: change Flg name
        
        gcd.async(.Main, closure: { () -> () in
            SNSController.instance.wxCheckAuth({ (sns) -> () in
                assert(NSThread.currentThread().isMainThread, "not main thread")
                
                self.loginOrRegisterWithSNS(sns)
                
            }, failure: { (errCode, errMessage) -> () in
                    println(errMessage)
            })
        })
    }
    
    @IBAction func qqBtnTapped(sender: AnyObject) {
        SVProgressHUD.showWithMaskType(.Clear)
        
        gcd.async(.Main, closure: { () -> () in
            SNSController.instance.qqCheckAuth({ (sns) -> () in
                assert(NSThread.currentThread().isMainThread, "not main thread")
                
                self.loginOrRegisterWithSNS(sns)
            }, failure: { (errCode, errMessage) -> () in
                    println(errMessage)
            })
        })
    }
    
    func loginOrRegisterWithSNS(sns: SNS) {
        loginType = .SNS

        ParseController.parseUserByOpenid(sns.openid, result: { (pSNS, error) -> Void in
            if let pSNS = pSNS {
                if let pUser = pSNS["user"] as? PFObject {
                    self.user = UserController.userFromParseUser(pUser)
                    sns.user = self.user
                    UserController.saveUser(self.user)
                    XMPPManager.loginWithUser(self.user)
                    return
                }
            }
            
            self.user = UserController.snsUser(sns)
            self.needUploadToParse = true
            XMPPManager.registerWithUser(self.user)
        })
        
//        //already have openfireid
//        if let parseUser = ParseController.parseUserByOpenid(sns.openid) {
//            self.user = UserController.snsUser(sns, parseUser: parseUser)
//            XMPPManager.loginWithUser(self.user)
//        } else {
//            self.user = UserController.snsUser(sns, parseUser: nil)
//            self.needUploadToParse = true
//            XMPPManager.registerWithUser(self.user)
//        }
    }
    
    func endEdit(sender:AnyObject){
        sender.resignFirstResponder()
    }
}

// MARK: - XMPPCreateAccountViewControllerDelegate

extension LoginViewController: XMPPCreateAccountViewControllerDelegate {
    func createAccountViewControllerDidLogin() {
        self.performSegueWithIdentifier("SegueTabBar", sender: nil)
    }
}

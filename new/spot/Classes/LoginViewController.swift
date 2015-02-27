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
    
    var isAnonymousLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("xmppLoginFailed:"), name: kXMPPLoginFail, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("xmppLoginSuccess:"), name: kXMPPLoginSuccess, object: nil)
        
        //self.usernameTF?.addTarget(self, action: Selector("endEdit:"), forControlEvents: UIControlEvents.EditingDidEndOnExit)
        self.passwordTF?.addTarget(self, action: Selector("endEdit:"), forControlEvents: UIControlEvents.EditingDidEndOnExit)

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
        //already saved
        if isAnonymousLogin {
            SVProgressHUD.dismiss()
            
            self.performSegueWithIdentifier("SegueTabBar", sender: nil)
            
            return
        }
        
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
        SVProgressHUD.show()
        
        isAnonymousLogin = true
        UserController.anonymousLogin()
    }
    
    @IBAction func wxBtnTapped(sender: AnyObject) {
        SNSController.instance.wxCheckAuth({ (res) -> () in
            
            SVProgressHUD.showWithMaskType(.Clear)
            
            XMPPManager.instance.connectWithJID("hikaru" + "@" + kOpenFireDomainName, myPassword: "123456")
            /*
            ///////////////////////////////////////////////
            let account = User.MR_createEntity() as User
            
            account.username = res["nickname"] as? String;
            
            account.uniqueIdentifier = NSUUID().UUIDString.lowercaseString
            
            account.password = NSUUID().UUIDString.lowercaseString
            
            
            println(res)
            ///////////////////////////////////////////////
            self.performSegueWithIdentifier("SegueTabBar", sender: nil)
            */
            }, failure: { (errCode, errMessage) -> () in
                println(errMessage)
        })
    }
    
    @IBAction func qqBtnTapped(sender: AnyObject) {
        //self.test()
        //QQ auth
        SNSController.instance.qqCheckAuth({ (res) -> () in
            SVProgressHUD.showWithMaskType(.Clear)
            
            XMPPManager.instance.connectWithJID("hikaru" + "@" + kOpenFireDomainName, myPassword: "123456")
            
            }, failure: { (errCode, errMessage) -> () in
                println(errMessage)
        })

    }
    func endEdit(sender:AnyObject){
        sender.resignFirstResponder()
    }
    func test(){
        //
        //SNSController.instance.qqShare(0, title: "分享测试", description: "分享内容", url: "http://e-business.co.jp")
        //SNSController.instance.wxShare(0,  title: "wx分享测试", description: "wx分享内容")
        
        
        
        
        let select = ParseUserInfoModel()
        select.find(ParseUserInfoModel.self, complete: { (result) -> () in
            if let res = result {
                for o in res {
                    println(o)
                    println("openids")
                    println(o.openids)
                    for sns in o.openids{
                        println(sns.access_token)
                    }
                }
            }
            
        })
        /*
        let select = ParseUserInfoModel()
        select.objectId = "N7yMQYQYVm"
        select.nickname = "nicknameValue"
        let sns = ParseSNSModel(openid: "openid", access_token: "token1", refresh_token: "token2", expirationDate: "dateeeee")
        sns.objectId = "Nk2St1QVYU"
        //select.openids = [sns,sns]
        let pf = select.toPFObject()
        println(pf)
        pf.saveInBackgroundWithBlock({ (isok, error) -> Void in
        //select.initWithPFObject(pf)
        println(select)
        
        })
        */
        
        
    }

}

// MARK: - XMPPCreateAccountViewControllerDelegate

extension LoginViewController: XMPPCreateAccountViewControllerDelegate {
    func createAccountViewControllerDidLogin() {
        self.performSegueWithIdentifier("SegueTabBar", sender: nil)
    }
}

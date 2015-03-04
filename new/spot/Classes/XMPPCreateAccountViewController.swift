//
//  XMPPCreateAccountViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/10.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

@objc protocol XMPPCreateAccountViewControllerDelegate {
    func createAccountViewControllerDidLogin()
}

class XMPPCreateAccountViewController: BaseViewController {

    var newAccountTableViewController: NewAccountTableViewController!
    var account: User!
    weak var delegate: XMPPCreateAccountViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("xmppLoginFailed:"), name: kXMPPLoginFail, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("xmppLoginSuccess:"), name: kXMPPLoginSuccess, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("xmppRegisterFailed:"), name: kXMPPRegisterFailed, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("xmppRegisterSuccess:"), name: kXMPPRegisterSuccess, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Notification
    
    func xmppLoginFailed(notification: NSNotification) {
        SVProgressHUD.dismiss()
        
        // TODO:
    }
    
    func xmppLoginSuccess(notification: NSNotification) {
        SVProgressHUD.dismiss()

        account.managedObjectContext?.MR_saveToPersistentStoreWithCompletion(nil)
        
        //upload to Parse
        ParseController.uploadUser(account, done: { (error) -> Void in
            if let error = error {
                SVProgressHUD.showErrorWithStatus(error.localizedDescription)
                return
            }
            
            self.dismissViewControllerAnimated(true, completion: {
                if let delegate = self.delegate {
                    delegate.createAccountViewControllerDidLogin()
                }
            })
        })
        

    }
    
    func xmppRegisterSuccess(notification: NSNotification) {
        // TODO: change loading text
        account.managedObjectContext?.MR_saveToPersistentStoreWithCompletion(nil)
        
//        XMPPManager.instance.connectWithPassword(newAccountTableViewController.passwordTF.text)
    }
    
    func xmppRegisterFailed(notification: NSNotification) {
        SVProgressHUD.dismiss()
        
        // TODO: 
    }
    
    // MARK: - Action
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: AnyObject) {
        let fixedUsername = newAccountTableViewController.usernameTF.text.trimmed()
        let password = newAccountTableViewController.passwordTF.text
        
        if fixedUsername.length == 0 || password.length == 0 {
            SVProgressHUD.showErrorWithStatus("入力エラー")
            return
        }
        
        newAccountTableViewController.usernameTF.text = fixedUsername
        
        account = User.MR_createEntity() as User
        
        account.username = fixedUsername;
        
        account.openfireId = NSUUID().UUIDString.lowercaseString + "@" + kOpenFireDomainName

        account.password = password
        account.displayName = newAccountTableViewController.displayNameTF.text
        
        SVProgressHUD.show()
        
        XMPPManager.instance.account = account
        XMPPManager.instance.registerNewAccountWithPassword(newAccountTableViewController.passwordTF.text)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueNewAccount" {
            newAccountTableViewController = segue.destinationViewController as NewAccountTableViewController
        }
    }

}

extension XMPPCreateAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false
    }
}

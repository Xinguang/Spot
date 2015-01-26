//
//  MessageDetailController.swift
//  spot
//
//  Created by Hikaru on 2014/12/02.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit

class MessageDetailController: CommonController,WebSocketHelperDelegate{
    
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var btnSmile: UIButton!
    @IBOutlet var btnPlus: UIButton!
    @IBOutlet var container: UIView!
    var msgRow: [CellRow] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        WebSocketHelper.instance.delegate = self
        
        self.textField.addTarget(self, action: Selector("endEdit:"), forControlEvents: UIControlEvents.EditingDidEndOnExit)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "設定", style: .Plain, target: self, action: Selector("showMessageSetting"))
 
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showMessageSetting(){
        self.performSegueWithIdentifier("message_setting",sender: "設定")
    }
    ////////////////////////////////////////////
    ////////////////////////////////////////////
    //web socket
    ////////////////////////////////////////////
    ////////////////////////////////////////////
    func whenError(errMessage:String){
        println("errormessage: \(errMessage)")
    }
    func whenSuccess(ReceiveMessage:String){
        println("ReceiveMessage: \(ReceiveMessage)")
        
    }
    //send messge
    func endEdit(sender:AnyObject){
        sender.resignFirstResponder()
        var str = self.textField.text;
        self.textField.text = "";
        if("" != str){
            WebSocketHelper.instance.sendMessage(str)
        }
    }
    
    ////////////////////////////////////////////
    ////////////////////////////////////////////
    //keyboard 
    ////////////////////////////////////////////
    ////////////////////////////////////////////
    
    func keyboardWillShow(notification:NSNotification){
        var info = notification.userInfo!
        if let info = notification.userInfo {
            var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
            var duration:NSTimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
            
            var frame:CGRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-keyboardFrame.size.height)
            
            self.container.frame = frame
            
            
            frame = self.textField.frame
            
            frame.origin.y = self.view.frame.size.height - 37 - keyboardFrame.size.height
            
            self.textField.frame = frame
            
            frame = self.btnSmile.frame
            
            frame.origin.y = self.view.frame.size.height - 37 - keyboardFrame.size.height
            
            self.btnSmile.frame = frame
            
            frame = self.btnPlus.frame
            
            frame.origin.y = self.view.frame.size.height - 37 - keyboardFrame.size.height
            
            self.btnPlus.frame = frame
            
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        } else {
            // no userInfo dictionary present
        }
    }
    func keyboardWillHide(notification:NSNotification){
        var frame:CGRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)
        
        self.container.frame = frame
        
        frame = self.textField.frame
        
        frame.origin.y = self.view.frame.size.height-37
        
        self.textField.frame = frame
        frame = self.btnSmile.frame
        
        frame.origin.y = self.view.frame.size.height-37
        
        self.btnSmile.frame = frame
        frame = self.btnPlus.frame
        
        frame.origin.y = self.view.frame.size.height-37
        
        self.btnPlus.frame = frame
    }
    
}

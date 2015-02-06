//
//  MessageDetailController.swift
//  spot
//
//  Created by Hikaru on 2014/12/02.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit

class MessageDetailController: CommonController,KeyboardDelegate{
    ////////////////////////////////////////////
    ////////////////////////////////////////////
    //ui
    ////////////////////////////////////////////
    ////////////////////////////////////////////

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let inputArea = Keyboard()
        inputArea.delegate = self
        //inputArea.backgroundColor = UIColor.redColor()
        self.view.addSubview(inputArea)
        
       /*
        let tableView = UITableView(frame:CGRectMake(0, 0, 320, 480))
        tableView.backgroundColor = UIColor.redColor()
        self.view.addSubview(tableView)
        */
    }
    
    @IBOutlet var container: UIView!
    var msgRow: [CellRow] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
    //keyboard 
    ////////////////////////////////////////////
    ////////////////////////////////////////////
    func onSend(message:String){
        if "" != message {
            WebSocketHelper.instance.sendMessage(message)
        }
    }
    func keyboardWillShow(notification:NSNotification){
        var info = notification.userInfo!
        if let info = notification.userInfo {
            var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
            //var duration:NSTimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
            
            CommonHelper.instance.changeBottom(self.container, bottom: 44 + keyboardFrame.size.height)
        } else {
            // no userInfo dictionary present
        }
    }
    func keyboardWillHide(notification:NSNotification){
        var frame:CGRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44)
        
        self.container.frame = frame
        /*
        frame = self.textField.frame
        
        frame.origin.y = self.view.frame.size.height-37
        
        self.textField.frame = frame
        frame = self.btnSmile.frame
        
        frame.origin.y = self.view.frame.size.height-37
        
        self.btnSmile.frame = frame
        frame = self.btnPlus.frame
        
        frame.origin.y = self.view.frame.size.height-37
        
        self.btnPlus.frame = frame
        */ 
    }
    
}

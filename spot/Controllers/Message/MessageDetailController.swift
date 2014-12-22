//
//  MessageDetailController.swift
//  spot
//
//  Created by Hikaru on 2014/12/02.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit

class MessageDetailController: UIViewController{
    
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var btnSmile: UIButton!
    @IBOutlet var btnPlus: UIButton!
    @IBOutlet var container: UIView!
    var msgRow: [MessageRow] = []
    var _menu:REMenu = REMenu()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.addTarget(self, action: Selector("endEdit:"), forControlEvents: UIControlEvents.EditingDidEndOnExit)
        
        self._menu = REMenu(items: [
            CustomRemenuItem(title: "設定",subtitle: "subTitle",image: nil,highlightedImage: nil,{ (item) -> Void in
                let ms = MessageSetting()
                self.navigationController?.pushViewController(ms, animated: true)
            }),
            ])
        self._menu.items.append(CustomRemenuItem(title: "イベント詳細",subtitle: "subTitle",image: nil,highlightedImage: nil,{ (item) -> Void in
            self.performSegueWithIdentifier("event_detail",sender: "map")
        }))
        self._menu.items.append(CustomRemenuItem(title: "掲示板詳細",subtitle: "subTitle",image: nil,highlightedImage: nil,{ (item) -> Void in
            self.performSegueWithIdentifier("bbs_detail",sender: "map")
        }))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "...", style: .Plain, target: self, action: Selector("toggleMenu"))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func toggleMenu()
    {
        if (self._menu.isOpen){
            return self._menu.close()
        }
        //self._menu.showFromNavigationController(self.navigationController)
        //self._menu.showInView(self.view)
        self._menu.showFromRect(CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height), inView: self.view)
    }
    
    
    func endEdit(sender:AnyObject){
        sender.resignFirstResponder()
        var str = self.textField.text;
        self.textField.text = "";
    }
    
    
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

//
//  ContactsDetailController.swift
//  spot
//
//  Created by Hikaru on 2014/12/02.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//


import UIKit

class ContactsDetailController: UIViewController {
    
    var scrollView: UIScrollView!
    var input: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.automaticallyAdjustsScrollViewInsets = false;
        
        let navHeight = self.navigationController?.navigationBar.frame.size.height
        let margintop = navHeight!+UIApplication.sharedApplication().statusBarFrame.size.height
        
        //NSLog("%@/%@/%@", statusHeight,navHeight!,self.view.frame.size.height)
        
        
        
        scrollView = UIScrollView(frame: CGRectMake(0, margintop, self.view.frame.size.width, self.view.frame.size.height-margintop-44))
        
        var colors:[UIColor] = [UIColor.redColor(), UIColor.blueColor(), UIColor.greenColor(), UIColor.yellowColor()]
        var frame: CGRect = CGRectMake(0, 0, 0, 0)
        
        for index in 0..<colors.count {
            
            frame.origin.y = scrollView.frame.size.height * CGFloat(index)
            frame.size = scrollView.frame.size
            //scrollView.pagingEnabled = true
            
            var subView = UIView(frame: frame)
            subView.backgroundColor = colors[index]
            scrollView .addSubview(subView)
        }
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height * CGFloat(colors.count))
        
        self.view.addSubview(scrollView)
        
        
        input = UITextField(frame: CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44))
        var img:UIImage = UIImage(named: "input")!
        input.backgroundColor  = UIColor(patternImage: img);
        input.addTarget(self, action: Selector("endEdit:"), forControlEvents: UIControlEvents.EditingDidEndOnExit)
        self.view.addSubview(input)
        
        
        /*        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
        
        */
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification:NSNotification){
        var info = notification.userInfo!
        if let info = notification.userInfo {
            var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
            var duration:NSTimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
            
            
            let navHeight = self.navigationController?.navigationBar.frame.size.height
            let margintop = navHeight!+UIApplication.sharedApplication().statusBarFrame.size.height
            
            let frame:CGRect = CGRectMake(0, margintop, self.view.frame.size.width, self.view.frame.size.height-margintop-44-keyboardFrame.size.height)
            
            scrollView.frame = frame
            
            input.frame = CGRectMake(0, self.view.frame.size.height-44-keyboardFrame.size.height, self.view.frame.size.width, 44)
            
            
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        } else {
            // no userInfo dictionary present
        }
    }
    func keyboardWillHide(notification:NSNotification){
        
        let navHeight = self.navigationController?.navigationBar.frame.size.height
        let margintop = navHeight!+UIApplication.sharedApplication().statusBarFrame.size.height
        
        let frame:CGRect = CGRectMake(0, margintop, self.view.frame.size.width, self.view.frame.size.height-margintop-44)
        
        scrollView.frame = frame
        input.frame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)
    }
    func endEdit(sender:AnyObject){
        sender.resignFirstResponder()
        var str = input.text;
        input.text = "";
    }
}


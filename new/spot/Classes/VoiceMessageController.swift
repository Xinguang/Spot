//
//  VoiceMessageController.swift
//  spot
//
//  Created by Hikaru on 2015/03/11.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

// MARK: - Voice

//voice
private var icon_speaker:UIImage = UIImage(named: "icon_speaker")!
private var icon_keyboard:UIImage = UIImage(named: "icon_keyboard")!
private var icon_smile:UIImage = UIImage(named: "icon_smile")!
private var icon_plus:UIImage = UIImage(named: "icon_plus")!



private var icon_speaker_normal:UIImage = icon_speaker.jsq_imageMaskedWithColor(UIColor.lightGrayColor())
private var icon_speaker_highlighted:UIImage = icon_speaker.jsq_imageMaskedWithColor(UIColor.darkGrayColor())
private var icon_keyboard_normal:UIImage = icon_keyboard.jsq_imageMaskedWithColor(UIColor.lightGrayColor())
private var icon_keyboard_highlighted:UIImage = icon_keyboard.jsq_imageMaskedWithColor(UIColor.darkGrayColor())
private var icon_smile_normal:UIImage = icon_smile.jsq_imageMaskedWithColor(UIColor.lightGrayColor())
private var icon_smile_highlighted:UIImage = icon_smile.jsq_imageMaskedWithColor(UIColor.darkGrayColor())
private var icon_plus_normal:UIImage = icon_plus.jsq_imageMaskedWithColor(UIColor.lightGrayColor())
private var icon_plus_highlighted:UIImage = icon_plus.jsq_imageMaskedWithColor(UIColor.darkGrayColor())

private var textView_text :String = ""
private var btn_voice :UIButton?
private var btn_smile:UIButton?
private var btn_plus:UIButton?
private var cView: UIView?//UICollectionView?

//left button
extension MessageViewController {
    //
    // 初期化
    //
    func Initialization(){
        self.inputToolbar.contentView.rightBarButtonItemWidth = 60;
        self.inputToolbar.contentView.rightBarButtonItem.removeFromSuperview()
        //self.inputToolbar.contentView.leftBarButtonItem.frame = CGRectMake(0, 2, 26, 26)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textViewChanged:"), name: UITextViewTextDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textViewBeginEdit:"), name: UITextViewTextDidBeginEditingNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("textViewEndEdit:"), name: UITextViewTextDidEndEditingNotification, object: nil)
        
        
        self.inputToolbar!.contentView.textView.returnKeyType = .Send
        
        setButtonSmile()
        setButtonPlus()
        resetImage()
    }
    
    func setButtonSmile(){
        var frame = CGRectMake(0,0, 30, 30)
        btn_smile = UIButton(frame: frame)
        btn_smile?.addTarget(self, action: "didPressButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.inputToolbar.contentView.rightBarButtonContainerView.addSubview(btn_smile!)
    }
    func setButtonPlus(){
        var frame = CGRectMake(30, 0, 30, 30)
        btn_plus = UIButton(frame: frame)
        btn_plus?.addTarget(self, action: "didPressButton:", forControlEvents: UIControlEvents.TouchUpInside)
        self.inputToolbar.contentView.rightBarButtonContainerView.addSubview(btn_plus!)
    }
    //
    // hold on button
    //
    func setVoiceButton(){
        var frame = self.inputToolbar!.contentView.textView.frame
        frame.size.height = 30;
        
        btn_voice = UIButton(frame:frame)
        let l = self.inputToolbar!.contentView.textView.layer
        
        btn_voice?.layer.borderWidth = l.borderWidth//0.5;
        btn_voice?.layer.borderColor = l.borderColor//UIColor.lightGrayColor().CGColor;
        btn_voice?.layer.cornerRadius = l.cornerRadius//6.0;
        
        //btn_voice?.titleLabel?.text = "押したまま話す"
        
        let rect = btn_voice?.bounds
        let label = UILabel(frame: rect!)
        label.textAlignment = NSTextAlignment.Center
        label.text = "押したまま話す"
        btn_voice?.addSubview(label)
        
        btn_voice?.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        
        
        btn_voice?.addGestureRecognizer(UILongPressGestureRecognizer(target: self,action:"didPressVoiceButton:"))
    }
}
//Button Status&image
extension MessageViewController {
    func resetImage(){
        btn_smile?.setImage(icon_smile_normal, forState: UIControlState.Normal)
        btn_smile?.setImage(icon_smile_highlighted, forState: UIControlState.Highlighted)
        btn_smile?.tag = 0
        btn_plus?.setImage(icon_plus_normal, forState: UIControlState.Normal)
        btn_plus?.setImage(icon_plus_highlighted, forState: UIControlState.Highlighted)
        btn_plus?.tag = 0
        self.inputToolbar.contentView.leftBarButtonItem.setImage(icon_speaker_normal, forState: UIControlState.Normal)
        self.inputToolbar.contentView.leftBarButtonItem.setImage(icon_speaker_highlighted, forState: UIControlState.Highlighted)
        btn_voice?.tag = 0
    }
    func showKeyboardImage(btn:UIButton){
        resetImage()
        btn.setImage(icon_keyboard_normal, forState: UIControlState.Normal)
        btn.setImage(icon_keyboard_highlighted, forState: UIControlState.Highlighted)
        
        textView_text = self.inputToolbar!.contentView.textView.text
        self.inputToolbar!.contentView.textView.text = ""
        self.inputToolbar!.contentView.textView.resignFirstResponder()
        
        if(btn == self.inputToolbar.contentView.leftBarButtonItem){
            btn_voice?.tag = 1
        }else{
            btn.tag = 1
        }
    }
    func showKeyboard(){
        btn_voice?.removeFromSuperview()
        self.inputToolbar!.contentView.textView.becomeFirstResponder()
    }
    func changeInputToolbarFrame(){
        //防止键盘跳动
        var  height = UIScreen.mainScreen().bounds.height - self.inputToolbar!.preferredDefaultHeight
        if let cviewHeight = cView?.frame.size.height{
            height -= cviewHeight
        }
        self.inputToolbar!.frame.origin.y = height
    }
}


//Action
extension MessageViewController {
    
    //
    // on Press
    //
    override func didPressAccessoryButton(sender: UIButton!) {
        if btn_voice == nil {
            setVoiceButton()
        }
        if btn_voice?.tag == 0{
            showKeyboardImage(self.inputToolbar.contentView.leftBarButtonItem)
            
            self.inputToolbar!.frame.origin.y = UIScreen.mainScreen().bounds.height - self.inputToolbar!.preferredDefaultHeight
            
            self.inputToolbar!.contentView.addSubview(btn_voice!)
            cView?.removeFromSuperview()
        }else{
            resetImage()
            showKeyboard()
        }
    }
    func didPressButton(sender: UIButton!){
        if sender.tag == 0{
            showKeyboardImage(sender)
            if let parentView = cView?.superview{
                
            }else{
                showKeyboard()
                self.inputToolbar!.contentView.textView.resignFirstResponder()
                self.inputToolbar!.addSubview(cView!)
            }
            cView?.hidden = false
            
        }else{
            resetImage()
            showKeyboard()
        }
    }
    //
    // hold on
    //
    func didPressVoiceButton(longPressedRecognizer:UILongPressGestureRecognizer){
        if longPressedRecognizer.state == UIGestureRecognizerState.Began {
            btn_voice?.backgroundColor = UIColor(hexString: "#0EAA00")
            VoiceController.instance.start()
            NSLog("hold Down");
            
        }//长按结束
        else if longPressedRecognizer.state == UIGestureRecognizerState.Ended || longPressedRecognizer.state == UIGestureRecognizerState.Cancelled{
            
            btn_voice?.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
            let url = VoiceController.instance.stop()
            
            VoiceController.instance.play(url)
            NSLog("hold release");
        }
    }
}

//NSNotificationCenter
extension MessageViewController {
    func keyboardWillShow(notification:NSNotification){
        if "" != textView_text {
            self.inputToolbar!.contentView.textView.text = textView_text
            textView_text = ""
        }
        cView?.hidden = true
        if (cView == nil ){
            if let info = notification.userInfo {
                let frame = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
                
                cView = UIView(frame: CGRectMake(0,self.inputToolbar!.preferredDefaultHeight,frame.size.width,frame.size.height))
                cView?.backgroundColor = UIColor.redColor()
                changeInputToolbarFrame()
                //var duration:NSTimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
                //cView = UICollectionView(frame: frame)
            }
        }
    }
    func keyboardWillHide(notification:NSNotification){
        //防止键盘跳动
        changeInputToolbarFrame()
    }
    func textViewChanged(ntification:NSNotification){
        
        //let height = self.inputToolbar!.contentView.textView.frame.size.height
        //cView?.hidden = height != 30;
        
        //print ("textview:");
        //print (height);
    }
    func textViewBeginEdit(ntification:NSNotification){
        resetImage()
    }
    func textViewEndEdit(ntification:NSNotification){
        print ("end");
    }
    
    override func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            var text:NSString = self.inputToolbar.contentView.textView.text
            self.didPressSendButton(nil, withMessageText: text.jsq_stringByTrimingWhitespace() , senderId: self.senderId(), senderDisplayName: self.senderDisplayName(), date: NSDate())
            self.inputToolbar!.contentView.textView.text = ""
            textView_text = ""
            return false
        }
        return true;
    }
}

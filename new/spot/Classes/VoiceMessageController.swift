//
//  VoiceMessageController.swift
//  spot
//
//  Created by Hikaru on 2015/03/11.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

// MARK: - Voice

//voice
private var textView_text :String = ""
private var btn_voice :UIButton?

extension MessageViewController {
    //
    // background
    //
    func setAccessoryButtonImageView(){
        let icon_speaker = UIImage(named: "icon_speaker")!
        let icon_keyboard = UIImage(named: "icon_keyboard")!
        
        self.icon_speaker_normal = icon_speaker.jsq_imageMaskedWithColor(UIColor.lightGrayColor())
        self.icon_speaker_highlighted = icon_speaker.jsq_imageMaskedWithColor(UIColor.darkGrayColor())
        self.icon_keyboard_normal = icon_keyboard.jsq_imageMaskedWithColor(UIColor.lightGrayColor())
        self.icon_keyboard_highlighted = icon_keyboard.jsq_imageMaskedWithColor(UIColor.darkGrayColor())
        
        self.inputToolbar.contentView.leftBarButtonItem.frame = CGRectMake(0,2,26,26)
        self.changeAccessoryButtonImage(0)
    }
    func changeAccessoryButtonImage(tag:Int){
        if tag == 0{
            self.inputToolbar.contentView.leftBarButtonItem.setImage(self.icon_speaker_normal, forState: UIControlState.Normal)
            self.inputToolbar.contentView.leftBarButtonItem.setImage(self.icon_speaker_highlighted, forState: UIControlState.Highlighted)
        }else{
            self.inputToolbar.contentView.leftBarButtonItem.setImage(self.icon_keyboard_normal, forState: UIControlState.Normal)
            self.inputToolbar.contentView.leftBarButtonItem.setImage(self.icon_keyboard_highlighted, forState: UIControlState.Highlighted)
        }
    }
    //
    // on Press
    //
    override func didPressAccessoryButton(sender: UIButton!) {
        if btn_voice == nil {
            setVoiceButton()
        }
        if btn_voice?.tag == 0{
            btn_voice?.tag = 1
            self.changeAccessoryButtonImage(1)
            self.inputToolbar!.contentView.addSubview(btn_voice!)
            textView_text = self.inputToolbar!.contentView.textView.text
            self.inputToolbar!.contentView.textView.text = ""
            self.inputToolbar!.contentView.textView.resignFirstResponder()
        }else{
            btn_voice?.tag = 0
            self.changeAccessoryButtonImage(0)
            self.inputToolbar!.contentView.textView.text = textView_text
            textView_text = ""
            btn_voice?.removeFromSuperview()
            self.inputToolbar!.contentView.textView.becomeFirstResponder()
        }
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
        
        
        btn_voice?.addGestureRecognizer(UILongPressGestureRecognizer(target: self,action:"record:"))
        //btn_voice?.addTarget(self, action: "holdOn", forControlEvents: UIControlEvents.TouchDown)
        //btn_voice?.addTarget(self, action: "sendVoice", forControlEvents: UIControlEvents.TouchUpInside)
    }
    //
    // hold on
    //
    func record(longPressedRecognizer:UILongPressGestureRecognizer){
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
    /*
    func holdOn(){
        btn_voice?.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        VoiceController.instance.start()
        NSLog("hold Down");
    }
    func sendVoice(){
        btn_voice?.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        let url = VoiceController.instance.stop()
        
        VoiceController.instance.play(url)
        NSLog("hold release");
    }
    */
}

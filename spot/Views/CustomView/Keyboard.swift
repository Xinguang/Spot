//
//  Keyboard.swift
//  spot
//
//  Created by Hikaru on 2015/01/27.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import UIKit

protocol KeyboardDelegate{
    func onSend(message:String)
}
class Keyboard: UIView ,UITextViewDelegate,TextViewAutoHeightDelegate{
    
    //////////////////////////////////////
    private let _ToolBar_Height:CGFloat = 44
    private let _ToolBar_Button_Width:CGFloat = 35
    private let _ToolBar_View_Height:CGFloat = 35
    private let _ToolBar_View_Margin:CGFloat = 5
    private var keyboardFrame: CGRect = CGRectMake(0, 0, 0, 0)
    //////////////////////////////////////
    var delegate:KeyboardDelegate?
    //////////////////////////////////////
    private var textView: TextViewAutoHeight?
    private var btnSmilies: UIButton?
    private var btnPlus: UIButton?
    private var collectionView: UICollectionView?
    
    enum KeyboardType : UInt8 {
        case keyboard = 0x0
        case smilies = 0x1
        case plus = 0x2
    }
    
    private var showType:KeyboardType = .keyboard
    
    override init() {
        super.init()
        self.setSubViews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setSubViews()
        self.frame = frame
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setSubViews(){
        self.backgroundColor = CommonHelper.instance.UIColorFromRGB(0xFFFFFF, alpha: 0.8)
        self.frame = CGRectMake(0, DEVICE_HEIGHT - self._ToolBar_Height, DEVICE_WIDTH, self._ToolBar_Height)
        self.setTextField()
        
        self.setSmilies()
        self.setPlus()
        self.setBackgroundDefault()
    }
    /////////////////////////////////////////
    //SubViews
    /////////////////////////////////////////
    func setTextField(){
        let textFrame = self.getTextFieldFrame(1, rightindex: 2)
        self.textView = TextViewAutoHeight(frame:textFrame)
        //self.textView?.borderStyle = UITextBorderStyle.RoundedRect
        //self.textView?.clearsOnBeginEditing=true
        self.textView?.returnKeyType = UIReturnKeyType.Send
        self.textView?.delegate = self
        self.textView?.heightDelegate = self
        self.textView?.maxHeight=100
        self.textView?.layer.borderWidth = 1
        self.textView?.layer.borderColor = CommonHelper.instance.UIColorFromRGB(0xBDBBBB, alpha: 1).CGColor
        self.textView?.layer.cornerRadius = 5
        self.textView?.layer.masksToBounds = true;
        //self.textView?.backgroundColor = UIColor.blueColor()
        
        //self.textView?.addTarget(self, action: Selector("endEdit:"), forControlEvents: UIControlEvents.EditingDidEndOnExit)
        self.addSubview(self.textView!)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    func setPlus(){
        if (self.btnPlus == nil) {
            self.btnPlus = UIButton(frame:self.getButtonFrame(1,heightChangeed: 0))
            self.btnPlus?.tag = 1
            self.btnPlus?.addTarget(self, action: "showCollectionView:", forControlEvents: UIControlEvents.TouchDown)
            self.addSubview(self.btnPlus!)
        }
    }
    func setSmilies(){
        if (self.btnSmilies == nil) {
            self.btnSmilies = UIButton(frame:self.getButtonFrame(2,heightChangeed: 0))
            self.btnSmilies?.tag = 2
            //self.btnSmilies?.addTarget(self, action: Selector("showCollectionView:"), forControlEvents: UIControlEvents.TouchUpOutside)
            self.btnSmilies?.addTarget(self, action: "showCollectionView:", forControlEvents: UIControlEvents.TouchDown)
            self.addSubview(self.btnSmilies!)
        }
    }
    
    func setCollectionView(frame:CGRect?){
        if nil == self.collectionView{
            if let f = frame{
                let l = WaterFlowLayout();
                self.collectionView = UICollectionView(frame: CGRectMake(0, self.frame.size.height, self.frame.size.width, f.size.height),collectionViewLayout:l)
                self.frame.size.height = self.frame.size.height + f.size.height
                self.addSubview(self.collectionView!)
            }else{
                self.textView?.resignFirstResponder()
                self.textView?.becomeFirstResponder()
            }
        }
        if self.showType != .keyboard{
            self.textView?.resignFirstResponder()
        }else{
            self.textView?.becomeFirstResponder()
        }
    }
    
    func showCollectionView(sender:AnyObject){
        var oldType = self.showType
        var btnType:KeyboardType = (sender.tag == 1 ) ? .plus : .smilies

        self.setBackgroundDefault()
        if(self.showType == btnType){
            self.showType = .keyboard
        }else{
            self.showType = btnType
            (sender as UIButton).backgroundColor = UIColor(patternImage: UIImage(named:"keyboard")!)
        }
        if(oldType != self.showType){
            self.setCollectionView(nil)
        }
        //
        
        //self.collectionView = UICollectionView(frame: CGRectMake(0, self.frame.size.height, self.frame.size.width, 216))
    }
    func setBackgroundDefault(){
        self.btnPlus?.backgroundColor = UIColor(patternImage: UIImage(named:"+")!)
        self.btnSmilies?.backgroundColor = UIColor(patternImage: UIImage(named:"smile")!)
    }
    /////////////////////////////////////////
    //delegate
    /////////////////////////////////////////
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            self.delegate?.onSend(textView.text)
            textView.text = "";
            return false
        }
        return true;
    }
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if self.showType != .keyboard && self.frame.origin.y < DEVICE_HEIGHT - self._ToolBar_Height{
            self.setBackgroundDefault()
            self.showType = .keyboard
            self.setCollectionView(nil)
        }
        return true;
    }
    
    
    func heightChanged(height:CGFloat){
        var frame = self.frame
        var collectionViewHeight:CGFloat = 0
        if let f = self.collectionView?.frame{
            collectionViewHeight = f.size.height
            self.collectionView?.frame.origin.y = f.origin.y + height
        }
        frame.size.height = self._ToolBar_Height + collectionViewHeight + height
        frame.origin.y = DEVICE_HEIGHT - self.keyboardFrame.size.height - frame.size.height + collectionViewHeight
        
        CommonHelper.instance.showDegInfo("\(height)")
        self.frame = frame
        
        self.btnPlus?.frame = self.getButtonFrame(1,heightChangeed: height)
        self.btnSmilies?.frame = self.getButtonFrame(2,heightChangeed: height)
    }
    /////////////////////////////////////////
    //NSNotificationCenter
    /////////////////////////////////////////
    func keyboardWillShow(notification:NSNotification){
        var info = notification.userInfo!
        if let info = notification.userInfo {
            self.keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
            self.setCollectionView(self.keyboardFrame)
            var duration:NSTimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
            var point = keyboardFrame.origin
            point.y = point.y - self._ToolBar_Height
            self.layer.runAnimation(Animation.movePosition(point, delay: duration))
            //self.frame = CGRectMake(0, keyboardFrame.origin.y - self._ToolBar_Height , DEVICE_WIDTH, self._ToolBar_Height)
        } else {
            // no userInfo dictionary present
        }
    }
    func keyboardWillHide(notification:NSNotification){
        if self.showType != .keyboard{
            self.frame.origin.y = DEVICE_HEIGHT - self.frame.size.height
        }else{
            self.frame.origin.y = DEVICE_HEIGHT - self._ToolBar_Height
        }
        
    }

    /////////////////////////////////////////
    //frame
    /////////////////////////////////////////
    func getButtonFrame(index:CGFloat,heightChangeed:CGFloat) -> CGRect{
        return CGRectMake(self.getX(true, index: index),self.getY() + heightChangeed , _ToolBar_Button_Width, _ToolBar_View_Height)
    }
    func getTextFieldFrame(leftindex:CGFloat,rightindex:CGFloat) -> CGRect{
        let x = self.getX(false, index: leftindex)
        let w = self.getX(true, index: rightindex) - x - _ToolBar_View_Margin
         return CGRectMake(x,self.getY() , w, _ToolBar_View_Height)
        
    }
    func getY()->CGFloat{
        return (_ToolBar_Height - _ToolBar_View_Height )/2
    }
    func getX(isLeft:Bool,index:CGFloat)->CGFloat{
        var x = CGFloat(_ToolBar_Button_Width + _ToolBar_View_Margin)*(index-1) + _ToolBar_View_Margin
        if(isLeft){
            x = DEVICE_WIDTH - (x + _ToolBar_Button_Width)
        }
        return x
    }
    
}
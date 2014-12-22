//
//  LoginController.swift
//  spot
//
//  Created by Hikaru on 2014/11/25.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//
import UIKit

class LoginController:CommonController,OpenIDHelperDelegate{
    
    var theAnimator:UIDynamicAnimator?;
    
    var btn_wx: UIButton?
    var btn_qq: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btn_wx = self.addLoginButton("icon_wx", backgroundValue: 0x00cf0d, tag: 1)
        self.btn_qq = self.addLoginButton("icon_qq", backgroundValue: 0x5c8eca, tag: 2)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "becomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)

    }

    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    
    @IBAction func Login_skip(sender: AnyObject) {
        performSegueWithIdentifier("login_skip",sender: "設定")
    }
    
    
    func addLoginButton(imageName:String,backgroundValue: UInt,tag:Int)->UIButton{
        var btn = CommonHelper.instance.createCircleButton(
            UIImage(named: imageName)!,
            origin: CGPointMake(UIScreen.mainScreen().bounds.width/2-120 + CGFloat((tag-1)*160 ), 0),
            radius: 40,
            background: CommonHelper.instance.UIColorFromRGB(backgroundValue,alpha: 0.8),
            borderWidth: 0,
            borderBackground: UIColor.grayColor()
        )
        btn.tag = tag
        btn.addTarget(self, action: "Login:", forControlEvents: .TouchUpInside)
        self.view.addSubview(btn)
        return btn
    }
    
    func becomeActive(notification:NSNotification){
        self.btn_wx!.frame.origin.y = 0
        self.btn_qq!.frame.origin.y = 0
        DynamicHelper.instance.gravityAttachment(self.btn_wx!, length: 200)
        DynamicHelper.instance.gravityAttachment(self.btn_qq!, length: 200)
    }
    
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {
        
    }
    func Login(sender: UIButton) {
        switch(sender.tag ){
        case 1:
            WeixinHelper.instance.delegate = self
            WeixinHelper.instance.checkAuth()
            break;
        case 2:
            QQHelper.instance.delegate = self
            QQHelper.instance.checkAuth()
            break;
        default:
            break;
        }
    }
    
    /////////////////////////////////////////////////
    ////OpenID/////////////////////////////////////////
    /////////////////////////////////////////////////
    //失败
    func onError(type:OpenIDRequestType,errCode:Int32,errMessage:String){
        NSLog("%d----%@", errCode,errMessage)
    }
    //成功
    func onSuccess(type:OpenIDRequestType,res:Dictionary<String, AnyObject>){
        var param :[String: AnyObject] = [:];
        switch(type){
        case .WeiChat_Auth:
            SettingHelper.instance.setList(res, prefix: "wx_")
            param = self.setParamList(res)
            break;
        case .QQ_Auth:
            param = self.setParamList(res)
            break;
        default:
            break;
        }
        NSLog("ok %@", res)
        NSLog("param %@", param)
        performSegueWithIdentifier("setting_pofile",sender: param)
    }
    
    func setParamList(res:Dictionary<String, AnyObject>)->[String: AnyObject]{
        var param:[String: AnyObject] = [:];
        for (key, value) in res {
            let (err,pKey,pValue: AnyObject) = self.setParam(key, value: value)
            if(!err){
                param[pKey] = pValue;
            }
        }
        for key in self.paramKeys {
            if(!contains(param.keys, key)){
                param[key] = "";
            }
        }
        return param;
    }
    
    func setParam(key:String,value:AnyObject)->(err:Bool,pKey:String,pValue:AnyObject){
        var pKey:String = key
        var pValue: AnyObject = value
        var err = false;
        switch(key){
        case "headimgurl":
            pKey = "figure"
            break;
        case "sex":
            if let sexString = value as? String {
                pValue = sexString
            }else if let sexInt = value as? Int {
                if(1 == sexInt ){
                    pValue = "男"
                }else{
                    pValue = "女"
                }
            }
            break;
        case "year":
            pKey = "birthday"
            break;
        case "figureurl_qq_2":
            pKey = "figure"
            break;
        case "gender":
            pKey = "sex"
            break;
        default:break;
        }
        if(!contains(paramKeys, pKey)){
            err = true;
        }
        return (err,pKey,pValue);
    }
    
    let paramKeys:[String] = [
        "nickname",
        "figure",
        "sex",
        "birthday"
    ];
        
    
    
    
}

//
//  CommonController.swift
//  spot
//
//  Created by Hikaru on 2014/11/26.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//
import UIKit

class CommonController:UIViewController {
    var paramData:AnyObject?
    override func viewDidLoad() {
        super.viewDidLoad()
        //var img:UIImage = UIImage(named: "background")!
        //self.view.backgroundColor = UIColor(patternImage: img);
        /*
        // 背景设置为黑色
        self.navigationController?.navigationBar.tintColor = CommonHelper.instance.UIColorFromRGB(0x000000);
        // 透明度设置为0.3
        self.navigationController?.navigationBar.alpha = 0.300;
        */
        // 设置为半透明
        self.navigationController?.navigationBar.translucent = true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let view: CommonController = segue.destinationViewController as? CommonController{
            if let cell = sender as? MessageCell {
                view.title = cell.titleLable.text
            } else if let text = sender as? NSString {
                view.title = text
            } else if let param = sender as? [String: AnyObject] {
                view.paramData = param
            }else{
                view.title = "詳細"
            }
            view.hidesBottomBarWhenPushed = true
        }else{
            let view: UIViewController = segue.destinationViewController as UIViewController
            if let cell = sender as? MessageCell {
                view.title = cell.titleLable.text
            } else if let text = sender as? NSString {
                view.title = text
            } else{
                view.title = "詳細"
            }
            
            view.hidesBottomBarWhenPushed = true
        }
        
    }
    
}
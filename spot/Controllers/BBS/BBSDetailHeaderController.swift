//
//  BBSDetailHeaderController.swift
//  spot
//
//  Created by Hikaru on 2015/01/07.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//
import Foundation

class BBSDetailHeaderController : CommonController{
    
    @IBOutlet var userface: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var detailLabel: UILabel!
    
    var OuterView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(nil != userface){
            
            userface.contentMode = UIViewContentMode.ScaleAspectFit;
            userface.layer.cornerRadius = 5
            userface.layer.masksToBounds = true;
        }
        if let param = self.paramData as? Dictionary<String, AnyObject> {
            var imageHeight:CGFloat = 100;
            //CommonHelper.instance.changeHeight( self.imageView, height:  imageHeight)
            CommonHelper.instance.setImageFromUrl(self.imageView, uri: param["imageurl"] as String, callback: { (imgData) -> () in
                
            })

            CommonHelper.instance.setImageFromUrl(self.userface, uri: param["userface"] as String, callback: { (imgData) -> () in
                
            })
            self.username.text = param["username"] as? String
            self.detailLabel.text = param["contents"] as? String
            
            NSLog("%@", self.detailLabel.frame.size.height)
            let height = CommonHelper.instance.getFitHeight(self.detailLabel.frame.size.width - 10, text: self.detailLabel.text!, fontSize: 14)
            
            NSLog("%@", height)
            NSLog("%@", self.detailLabel.text!)
            
            if(nil != self.OuterView){
                self.OuterView!.backgroundColor = UIColor.blueColor()
                //self.OuterView!.autoresizingMask = UIViewAutoresizing.FlexibleHeight|UIViewAutoresizing.None;
            
                //self.OuterView!.frame.size.height = 44 + imageHeight + height
                self.OuterView!.frame.size.height = self.OuterView!.frame.size.height + ( height - self.detailLabel.frame.size.height)
            }
        }
    }
}
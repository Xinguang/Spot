//
//  CellBBSHeader.swift
//  spot
//
//  Created by Hikaru on 2015/01/13.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import Foundation
class CellBBSHeader: UITableViewCell {
    @IBOutlet var userface: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var bbsImageView: UIImageView!
    @IBOutlet var contentsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if(nil != userface){
            
            userface.contentMode = UIViewContentMode.ScaleAspectFit;
            userface.layer.cornerRadius = 5
            userface.layer.masksToBounds = true;
        }
    }
    
    func configureWithContents(username:String ,userface:String,imageurl: String,contents: String) {
        var imageHeight:CGFloat = 100;
        //CommonHelper.instance.changeHeight( self.bbsImageView, height:  imageHeight)
        CommonHelper.instance.setImageFromUrl(self.bbsImageView, uri: imageurl as String, callback: { (imgData) -> () in
            
        })
        
        CommonHelper.instance.setImageFromUrl(self.userface, uri: userface, callback: { (imgData) -> () in
            
        })
        self.username.text = username

        self.contentsLabel.text = contents
        
        NSLog("%@", self.contentsLabel.frame.size.height)
        let height = CommonHelper.instance.getFitHeight(self.contentsLabel.frame.size.width - 40, text: contents, fontSize: 17)
        
        NSLog("%@", height)
        NSLog("%@", self.contentsLabel.text!)

        self.frame.size.height = (44 + 100 + 20) + height;
    }
}
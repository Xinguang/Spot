//
//  CellBBSList.swift
//  spot
//
//  Created by Hikaru on 2015/01/05.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import Foundation
class CellBBSList: UICollectionViewCell {
    @IBOutlet var userName: UILabel!
    @IBOutlet var userFace: UIImageView!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var detailLabel: UILabel!
    
    @IBOutlet var textArea: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if(nil != userFace){
            userFace.layer.cornerRadius = 5
            userFace.layer.masksToBounds = true;
            /*
            icon.layer.borderWidth = 1
            icon.layer.shadowOpacity = 0.5;
            icon.layer.shadowOffset = CGSizeMake(10, 10)
            */
        }
        
    }
    
    func configureWithContents(username:String ,userface:String,imageUrl: String,contents: String) {
        
        
        self.userName.text = username
        CommonHelper.instance.setImageFromUrl(self.userFace, uri: userface) { (imgData) -> () in
            
        }
        CommonHelper.instance.setImageFromUrl(self.imageView, uri: imageUrl) { (imgData) -> () in
            
        }
        self.detailLabel.text = contents
        
        var height = CommonHelper.instance.getFitHeight(self.bounds.size.width - 10, text: contents, fontSize: 14)
        if height > 28 {
            height = 28
        }
        CommonHelper.instance.changeHeight(self.textArea, height: height)
    }
}
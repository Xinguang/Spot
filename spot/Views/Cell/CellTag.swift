//
//  CellTag.swift
//  spot
//
//  Created by Hikaru on 2014/12/22.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation
class CellTag: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var icon: UIImageView!
    
    var IsCheckeded : Bool = false;
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if(nil != icon){
            icon.layer.cornerRadius = 5
            icon.layer.masksToBounds = true;
        /*
            icon.layer.borderWidth = 1
            icon.layer.shadowOpacity = 0.5;
            icon.layer.shadowOffset = CGSizeMake(10, 10)
        */
        }

    }
    
    func checked (ischeck:Bool){
        self.IsCheckeded = ischeck
        if(ischeck){
            self.icon.image = UIImage(named: "icon_checkmark")
        }else{
            self.icon.image = UIImage(named: "+")
        }
    }
}
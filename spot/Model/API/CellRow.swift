//
//  CellRow.swift
//  spot
//
//  Created by Hikaru on 2014/12/01.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

class CellRow:NSObject{
    
    var image :UIImage;
    var title: String = ""
    var subtitle: String = ""
    
    init(image:UIImage,title:String,subtitle:String){
        self.image = image;
        self.title = title;
        self.subtitle = subtitle;
    }
}
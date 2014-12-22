//
//  CustomRemenuItem.swift
//  spot
//
//  Created by Hikaru on 2014/12/16.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation

class CustomRemenuItem: REMenuItem {
    override init!(title: String!, image: UIImage!, highlightedImage: UIImage!, action: ((REMenuItem!) -> Void)!) {
        super.init(title: title, image: image, highlightedImage: highlightedImage, action: action)
        self.defaultSetting()
    }
    
    override init!(title: String!, subtitle: String!, image: UIImage!, highlightedImage: UIImage!, action: ((REMenuItem!) -> Void)!) {
        super.init(title: title, subtitle: subtitle, image: image, highlightedImage: highlightedImage, action: action)
        self.defaultSetting()
    }
    
    private func defaultSetting(){
        self.backgroundColor = CommonHelper.instance.UIColorFromRGB(0xFFE6CC, alpha: 0.5)
        self.highlightedBackgroundColor = CommonHelper.instance.UIColorFromRGB(0xE0FFE0, alpha: 0.5)
        
        self.highlightedTextColor = UIColor.whiteColor()
        self.subtitleHighlightedTextColor = UIColor.whiteColor()
        self.textColor = UIColor.whiteColor()
        self.subtitleTextColor = UIColor.whiteColor()
    }
}
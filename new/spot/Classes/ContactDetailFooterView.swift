//
//  ContactDetailFooterView.swift
//  spot
//
//  Created by 張志華 on 2015/02/25.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class ContactDetailFooterView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var telBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let image = UIImage(named: "GreenBigBtn")
        
        chatBtn.setBackgroundImage(image?.stretchableImageWithLeftCapWidth(4, topCapHeight: 4), forState: .Normal)
        
        telBtn.setBackgroundImage(UIImage(named: "common_gray_btn")!.stretchableImageWithLeftCapWidth(4, topCapHeight: 4), forState: .Normal)
    }
}

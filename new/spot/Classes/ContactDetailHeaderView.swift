//
//  ContactDetailHeaderView.swift
//  spot
//
//  Created by 張志華 on 2015/02/25.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class ContactDetailHeaderView: UITableViewHeaderFooterView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var sexImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!

    var jid: XMPPJID! {
        didSet {
//            updateIgnoreStorage(true)
            imageView.image = XMPPManager.instance.photoOfJid(jid)
            
            if let vCard = XMPPManager.vCardOfJid(jid) {
                nameLabel.text = vCard.formattedName ?? "匿名"
            }
        }
    }
    var username: String? {
        didSet {
            if let username = username {
                idLabel.text = "現場トモID:\(username)"
            }
        }
    }
    
    func updateIgnoreStorage(ignore: Bool) {
        imageView.image = XMPPManager.instance.photoOfJid(jid)
        
        if ignore {
            XMPPManager.instance.xmppvCardTempModule.fetchvCardTempForJID(jid, ignoreStorage: ignore)
        }
        
        if let vCard = XMPPManager.instance.xmppvCardTempModule.vCardTempForJID(jid, shouldFetch: true) {
//            let sexImageName = vCard
            nameLabel.text = vCard.formattedName ?? "匿名"
        }
    }
}

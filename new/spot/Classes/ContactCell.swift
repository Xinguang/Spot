//
//  ContactCell.swift
//  spot
//
//  Created by 張志華 on 2015/02/04.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    
    var contact: APContact! {
        didSet {
            contactImage.image = contact.thumbnail
            nameLabel.text = contactName(contact)
            phoneNumLabel.text = contactPhones(contact)
        }
    }

    func contactName(contact :APContact) -> String {
        if contact.firstName != nil && contact.lastName != nil {
            return "\(contact.firstName) \(contact.lastName)"
        }
        else if contact.firstName != nil || contact.lastName != nil {
            return (contact.firstName != nil) ? "\(contact.firstName)" : "\(contact.lastName)"
        }
        else {
            return "Unnamed contact"
        }
    }
    
    func contactPhones(contact :APContact) -> String {
        if let phones = contact.phones {
            let array = phones as NSArray
            return array.componentsJoinedByString(" ")
        }
        return "No phone"
    }
}

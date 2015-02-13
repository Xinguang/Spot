//
//  ContactViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/04.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class AddressContactViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let addressBook = APAddressBook()
    var contacts = [APContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressBook.fieldsMask = APContactField.Default | APContactField.Thumbnail
        addressBook.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true),
            NSSortDescriptor(key: "lastName", ascending: true)]
        addressBook.filterBlock = {(contact: APContact!) -> Bool in
            return contact.phones.count > 0
        }
        
        SVProgressHUD.show()
        
        addressBook.loadContacts(
            { (contacts: [AnyObject]!, error: NSError!) in
                SVProgressHUD.dismiss()
                
                if (contacts != nil) {
                    contacts.each({ (i, contact) -> () in
                        self.contacts.append(contact as APContact)
                    })
                    self.tableView.reloadData()
                }
                else if (error != nil) {
                    let alert = UIAlertView(title: "Error", message: error.localizedDescription,
                        delegate: nil, cancelButtonTitle: "OK")
                    alert.show()
                }
        })

    }
    
    // MARK: - Action
    
    
}

extension AddressContactViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("SearchBarCell", forIndexPath: indexPath) as UITableViewCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as ContactCell
        cell.contact = contacts[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

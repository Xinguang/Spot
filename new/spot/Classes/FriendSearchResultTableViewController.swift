//
//  FriendSearchResultTableViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/12.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit


@objc protocol FriendSearchResultTableViewControllerDelegate {
    func didSelectJID(jid: XMPPJID)
}

class FriendSearchResultTableViewController: UITableViewController {

    var pUsers = [PFObject]()
    var isEmpty = false
    var delegate: FriendSearchResultTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("searchAccountComplete:"), name: kXMPPSearchAccountComplete, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
//        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Notification
    
//    func searchAccountComplete(notification: NSNotification) {
//        SVProgressHUD.dismiss()
//        
//        if let obj = notification.object as? [XMPPAccount] {
//            accounts = obj
//            tableView.reloadData()
//        } else {
//            // TODO:
//        }
//    }

}

extension FriendSearchResultTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isEmpty {
            return 1
        }
        
        return pUsers.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isEmpty {
            let cell = tableView.dequeueReusableCellWithIdentifier("EmptyCell", forIndexPath: indexPath) as UITableViewCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountCell", forIndexPath: indexPath) as UITableViewCell
        
//        let pUserModel = pUsers[indexPath.row]
//        
//        cell.textLabel?.text = pUserModel.displayName
//        cell.detailTextLabel?.text = pUserModel.username
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let pUserModel = pUserModels![indexPath.row]
        
//        XMPPManager.instance.xmppRoster.addUser(XMPPJID.jidWithString(account.jid), withNickname: nil)
        
//        delegate?.didSelectJID(XMPPJID.jidWithString(account.jid))
        
//        var friend = Friend.MR_findFirstByAttribute("accountName", withValue: account.jid) as? Friend
//        if friend == nil {
//            friend = Friend.MR_createEntity() as? Friend
//            friend?.accountName = account.jid
//            friend?.displayName = account.name
//            friend?.user = XMPPManager.instance.account
//            friend?.managedObjectContext?.MR_saveToPersistentStoreWithCompletion(nil)
//        }
//        
//        XMPPManager.instance.addFriend(friend!)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

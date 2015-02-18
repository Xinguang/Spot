//
//  FriendSearchResultTableViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/12.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class FriendSearchResultTableViewController: UITableViewController {

    var accounts = [XMPPAccount]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("searchAccountComplete:"), name: kXMPPSearchAccountComplete, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        // TODO: change timing
        accounts = [XMPPAccount]()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Notification
    
    func searchAccountComplete(notification: NSNotification) {
        SVProgressHUD.dismiss()
        
        if let obj = notification.object as? [XMPPAccount] {
            accounts = obj
            tableView.reloadData()
        } else {
            // TODO:
        }
    }

}

extension FriendSearchResultTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return accounts.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountCell", forIndexPath: indexPath) as UITableViewCell
        
        let account = accounts[indexPath.row]
        cell.textLabel?.text = account.username
        cell.detailTextLabel?.text = account.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let account = accounts[indexPath.row]
        
        var friend = Friend.MR_findFirstByAttribute("accountName", withValue: account.jid) as? Friend
        if friend == nil {
            friend = Friend.MR_createEntity() as? Friend
            friend?.accountName = account.jid
            friend?.managedObjectContext?.MR_saveToPersistentStoreWithCompletion(nil)
        }
        
        XMPPManager.instance.addFriend(friend!)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

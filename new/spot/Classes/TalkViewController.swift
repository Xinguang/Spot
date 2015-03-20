//
//  TalkViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/04.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class TalkViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
   
    var frc: NSFetchedResultsController!
    
    var searchController :UISearchController!
    
    var friendCount: Int! {
        if let sectionInfo = frc.sections?[0] as? NSFetchedResultsSectionInfo {
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    override func awakeFromNib() {
        frc = XMPPMessageArchiving_Contact_CoreDataObject.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "mostRecentMessageTimestamp", ascending: false, inContext: XMPPManager.instance.xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext)
        frc.delegate = self

         NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("didReceivedMessage:"), name: kXMPPReceivedMessage, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        Util.checkPermissions()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        //update badge
        self.tableView.reloadData()
        updateBadgeNumber()
    }
    
    func setupSearchController() {
        var resultVC = storyboard?.instantiateViewControllerWithIdentifier("TalkSearchResultTableViewController") as TalkSearchResultTableViewController
        searchController = UISearchController(searchResultsController: resultVC)
        //        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "現場TOMOID"
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false // default is YES
        searchController.searchBar.delegate = self    // so we can monitor text changes + others
        
        // Search is now just presenting a view controller. As such, normal view controller
        // presentation semantics apply. Namely that presentation will walk up the view controller
        // hierarchy until it finds the root view controller or one that defines a presentation context.
        definesPresentationContext = true
    }
    
    func updateBadgeNumber() {
        if Friend.numberOfUnreadMessages() > 0 {
            self.navigationController?.tabBarItem.badgeValue = String(Friend.numberOfUnreadMessages())
        } else {
            self.navigationController?.tabBarItem.badgeValue = nil
        }
    }
    
    // MARK: - Action
    
    @IBAction func groupBtnTapped(sender: AnyObject) {
        SVProgressHUD.showInfoWithStatus("一時停止", maskType: .Clear)
//        let navi = Util.createViewControllerWithIdentifier(nil, storyboardName: "GroupChat") as UINavigationController
//        let friendsPickerViewController = navi.topViewController as FriendsPickerViewController
//        friendsPickerViewController.delegate = self
//        
//        self.presentViewController(navi, animated: true, completion: nil)
    }
    
    // MARK: - Notification
    
    func reloadUI() {
        tableView.reloadData()
        self.updateBadgeNumber()
    }
    
    func didReceivedMessage(notification: NSNotification) {
        let message = notification.object as XMPPMessage
        if isTalkingWithJid(message.from()) {
            return
        }
        
        //chou
        if (message.isGroupChatMessage()) {
            return
        }
        
        Friend.saveUnreadMessage(message, done: { () -> Void in
            if self.navigationController?.tabBarController?.selectedIndex == 0 {
                if self.navigationController?.topViewController == self {
                    self.reloadUI()
                }
            }
        })
    }
    
    func isTalkingWithJid(jid: XMPPJID) -> Bool {
        if let vc = self.navigationController?.topViewController as? MessageViewController {
            if vc.jid.isEqualToJID(jid, options: XMPPJIDCompareUser) {
                return true
            }
        }
        return false
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TalkViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
        
        updateBadgeNumber()
    }
}

// MARK: - Search

extension TalkViewController: UISearchControllerDelegate {
    
}

extension TalkViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        Util.showTodo()
        // TODO: change timing
//        SVProgressHUD.showWithStatus("検索中...", maskType: .Clear)
    }
}

extension TalkViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        }
        return friendCount
//        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecentlyFriendCell", forIndexPath: indexPath) as RecentlyFriendCell
        
        let friend = frc.objectAtIndexPath(indexPath) as XMPPMessageArchiving_Contact_CoreDataObject
        cell.friend = friend
        
        ParseController.getPUserByKeyIncludeAvatarAndUseCache("openfireId", value: friend.bareJidStr, result: { (pUser, data, error) -> Void in
            if let pUser = pUser {
                cell.pUser = pUser
            }
            
            cell.avatarImageData = data
        })
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as RecentlyFriendCell
        
        let friend = frc.objectAtIndexPath(indexPath) as XMPPMessageArchiving_Contact_CoreDataObject
        
        if friend.isGroupChat() {
            Util.enterGroupMessageViewController(friend.bareJidStr, from: self)
        } else {
            Friend.setAllMessageRead(friend.bareJidStr)
            
            if let pUser = cell.pUser {
                Util.enterMessageViewControllerWithPUser(pUser, avatarImageData: cell.avatarImageData, from: self)
            } else {
                ParseController.getPUserByKeyIncludeAvatarAndUseCache("openfireId", value: friend.bareJidStr, result: { (pUser, data, error) -> Void in
                    if let pUser = pUser {
                        Util.enterMessageViewControllerWithPUser(pUser, avatarImageData: cell.avatarImageData, from: self)
                    }
                })
            }
        }
    }
}

// MARK: - FriendsPickerViewControllerDelegate

extension TalkViewController: FriendsPickerViewControllerDelegate {
    
    func friendsPickerDidDismissWithRoster(roster: XMPPUserCoreDataStorageObject) {
        Util.showTodo()
//        Util.enterMessageViewControllerWithFriend(roster, from: self)
    }
    
    func friendsPickerDidDismissWithRoomJidStr(jidStr: String) {
        Util.enterGroupMessageViewController(jidStr, from: self)
    }
}

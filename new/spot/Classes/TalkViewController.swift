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
//        frc = Friend.MR_fetchAllGroupedBy(nil, withPredicate: NSPredicate(format: "lastMessageDate!=nil", argumentArray: nil), sortedBy: "lastMessageDate", ascending: false)
//        frc.delegate = self
        
        frc = XMPPMessageArchiving_Contact_CoreDataObject.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "mostRecentMessageTimestamp", ascending: false, inContext: XMPPManager.instance.xmppMessageArchivingCoreDataStorage.mainThreadManagedObjectContext)
        frc.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reloadUI"), name: kXMPPDidReceivevCardTemp, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reloadUI"), name: kXMPPDidReceiveAvata, object: nil)
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
        let navi = Util.createViewControllerWithIdentifier(nil, storyboardName: "GroupChat") as UINavigationController
        let friendsPickerViewController = navi.topViewController as FriendsPickerViewController
        friendsPickerViewController.delegate = self
        
        self.presentViewController(navi, animated: true, completion: nil)
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
            if vc.roster.jid.isEqualToJID(jid, options: XMPPJIDCompareUser) {
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
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCellWithIdentifier("SearchBarCell", forIndexPath: indexPath) as UITableViewCell
//            return cell
//        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("RecentlyFriendCell", forIndexPath: indexPath) as RecentlyFriendCell
        let friend = frc.objectAtIndexPath(indexPath) as XMPPMessageArchiving_Contact_CoreDataObject


        cell.friend = friend
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let friend = frc.objectAtIndexPath(indexPath) as XMPPMessageArchiving_Contact_CoreDataObject
//        let roster = XMPPUserCoreDataStorageObject.MR_findFirstInContext(XMPPManager.instance.xmppRosterStorage.mainThreadManagedObjectContext) as XMPPUserCoreDataStorageObject

        let roster = XMPPUserCoreDataStorageObject.MR_findFirstByAttribute("jidStr", withValue: friend.bareJidStr, inContext: XMPPManager.instance.xmppRosterStorage.mainThreadManagedObjectContext) as XMPPUserCoreDataStorageObject
        Util.enterMessageViewControllerWithFriend(roster, from: self)
//        friend.bareJidStr
//        Util.enterMessageViewControllerWithFriend(friend, from: self)
    }
}

// MARK: - FriendsPickerViewControllerDelegate

extension TalkViewController: FriendsPickerViewControllerDelegate {
    
    func friendsPickerDidDismissWithRoster(roster: XMPPUserCoreDataStorageObject) {
        Util.enterMessageViewControllerWithFriend(roster, from: self)
    }
}

//
//  ContactViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/13.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class ContactViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var frc: NSFetchedResultsController!
    
//    var frcRequest: NSFetchedResultsController!
//    var frcFriend: NSFetchedResultsController!
    
//    var friendCount: Int! {
//        if let sectionInfo = frcFriend.sections?[0] as? NSFetchedResultsSectionInfo {
//            return sectionInfo.numberOfObjects
//        }
//        
//        return 0
//    }
//    
//    var requestCount: Int! {
//        if let sectionInfo = frcRequest.sections?[0] as? NSFetchedResultsSectionInfo {
//            return sectionInfo.numberOfObjects
//        }
//        
//        return 0
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reloadUI"), name: kXMPPDidReceivevCardTemp, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reloadUI"), name: kXMPPDidReceiveAvata, object: nil)
//        rosters = XMPPUserCoreDataStorageObject.MR_findAllInContext(XMPPManager.instance.xmppRosterStorage.mainThreadManagedObjectContext) as [XMPPUserCoreDataStorageObject]
//        XMPPManager.instance.xmppRosterStorage.mainThreadManagedObjectContext
        frc = XMPPUserCoreDataStorageObject.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "sectionNum", ascending: true, inContext: XMPPManager.instance.xmppRosterStorage.mainThreadManagedObjectContext)
        frc.delegate = self
//
//        frcFriend = Friend.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "createAt", ascending: false)
//        frcFriend.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Notification
    
    func reloadUI() {
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

// MARK: - NSFetchedResultsControllerDelegate

extension ContactViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension ContactViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return frc.sections!.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionInfo = frc.sections?[section] as? NSFetchedResultsSectionInfo {
            return sectionInfo.numberOfObjects
        }
        
        return 0
//        if requestCount > 0 {
//            if section == 0 {
//                return requestCount
//            }
//        }
//        
//        return friendCount
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if requestCount > 0 && section == 0 {
//            return "友人要求"
//        }
//        
//        return "友人"
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        if requestCount > 0 && indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCellWithIdentifier("FriendRequestCell", forIndexPath: indexPath) as FriendRequestCell
//            
//            cell.friendRequest = frcRequest.objectAtIndexPath(indexPath) as FriendRequest
//            cell.delegate = self
//            
//            return cell
//        }
//        
//        if let sectionInfo = frcFriend.sections?[0] as? NSFetchedResultsSectionInfo {
//            let friend = sectionInfo.objects[indexPath.row] as Friend
        let roster = frc.objectAtIndexPath(indexPath) as XMPPUserCoreDataStorageObject
     
        
        
        
            let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as UITableViewCell
            
            let imageView = cell.viewWithTag(1) as UIImageView!
            let label = cell.viewWithTag(2) as UILabel!
            
//            imageView.image = friend.avatarImage()
        
        if let vCard = XMPPManager.instance.xmppvCardTempModule.vCardTempForJID(roster.jid, shouldFetch: true) {
            label.text = vCard.formattedName ?? roster.jid.user
        } else {
            label.text = roster.jid.user
        }
        
        imageView.image = XMPPManager.instance.photoOfJid(roster.jid)
        
//            label.text = roster.displayName ?? "匿名"
        
            return cell
//        }
        
//        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
//        if requestCount > 0 && indexPath.section == 0 {
//            return
//        }
        let roster = frc.objectAtIndexPath(indexPath) as XMPPUserCoreDataStorageObject
        
//        Util.enterMessageViewControllerWithFriend(roster, from: self)
        let vc = Util.createViewControllerWithIdentifier("ContactDetailViewController", storyboardName: "Common") as ContactDetailViewController
        vc.jid = roster.jid
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - FriendRequestCellDelegate

//extension ContactViewController: FriendRequestCellDelegate {
//    func friendRequestCellDidAcceptRequest(cell: FriendRequestCell) {
//        var friendRequest = cell.friendRequest
//        
//        let jid = XMPPJID.jidWithString(friendRequest.jid)
//        XMPPManager.instance.xmppRoster.acceptPresenceSubscriptionRequestFrom(jid, andAddToRoster: true)
//        friendRequest.MR_deleteEntity()
//        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion(nil)
//    }
//}

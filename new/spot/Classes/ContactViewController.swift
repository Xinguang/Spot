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
    
    var pUsers = Dictionary<NSIndexPath, PFObject?>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        frc = XMPPUserCoreDataStorageObject.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "sectionNum", ascending: true, inContext: XMPPManager.instance.xmppRosterStorage.mainThreadManagedObjectContext)
        frc.delegate = self
//
//        frcFriend = Friend.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "createAt", ascending: false)
//        frcFriend.delegate = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //friend detail で最新の取得したため
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Notification
    
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
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let roster = frc.objectAtIndexPath(indexPath) as XMPPUserCoreDataStorageObject
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as UITableViewCell
        
        let imageView = cell.viewWithTag(1) as UIImageView!
        let label = cell.viewWithTag(2) as UILabel!
        imageView.image = nil
        label.text = ""
        
        ParseController.getPUserByKeyIncludeAvatarAndUseCache("openfireId", value: roster.jidStr) { (pUser, data, error) -> Void in
            self.pUsers[indexPath] = pUser
            
            if let error = error {
                return
            }
            
            if let name = pUser?["displayName"] as? String {
                label.text = name
            } else {
                label.text = pUser?["username"] as? String
            }

            imageView.image = Util.avatarImageWithData(data, diameter: kAvatarImageSize)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if let pUser = pUsers[indexPath]? as PFObject? {
            Util.enterFriendDetailViewController(pUser, from: self, isTalking: false)
        }
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

//
//  FriendsPickerViewController.swift
//  spot
//
//  Created by 張志華 on 2015/03/10.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

protocol FriendsPickerViewControllerDelegate {
    func friendsPickerDidDismissWithRoster(roster: XMPPUserCoreDataStorageObject)
    func friendsPickerDidDismissWithRoomJidStr(jidStr: String)
}

class FriendsPickerViewController: ContactViewController {
    
    @IBOutlet weak var okBtn: UIBarButtonItem!

    var selectedFriends = NSMutableArray()
    
    var delegate: FriendsPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("roomCreated:"), name: kXMPPRoomCreated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("roomJoined:"), name: kXMPPRoomJoined, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Action
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func okBtnTapped(sender: AnyObject) {
        if selectedFriends.count == 1 {
            self.dismissViewControllerAnimated(false, completion: { () -> Void in
                if let delegate = self.delegate {
                    delegate.friendsPickerDidDismissWithRoster(self.selectedFriends.firstObject as XMPPUserCoreDataStorageObject)
                }
            })
        } else {
            SVProgressHUD.showWithMaskType(.Clear)
        
            XMPPManager.createNewRoom()
        }
    }
    
    // MARK: - Notification
    
    func roomCreated(notification: NSNotification) {
        println(__FUNCTION__)
        

    }
    
    func roomJoined(notification: NSNotification) {
        println(__FUNCTION__)
        
        let room = notification.object as XMPPRoom
        
        for roster in selectedFriends {
            if let roster = roster as? XMPPUserCoreDataStorageObject {
                XMPPManager.inviteUserToRoom(room, jid: roster.jid)
            }
        }
        
        SVProgressHUD.dismiss()
        
        self.dismissViewControllerAnimated(false, completion: { () -> Void in
            if let delegate = self.delegate {
                delegate.friendsPickerDidDismissWithRoomJidStr(room.roomJID.bare())
            }
        })
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

extension FriendsPickerViewController: UITableViewDataSource, UITableViewDelegate {
    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let roster = frc.objectAtIndexPath(indexPath) as XMPPUserCoreDataStorageObject
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as FriendCell
        cell.friend = roster
        
        if selectedFriends.containsObject(roster) {
            cell.setChecked(true)
        } else {
            cell.setChecked(false)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as FriendCell

        let roster = frc.objectAtIndexPath(indexPath) as XMPPUserCoreDataStorageObject
        
        if selectedFriends.containsObject(roster) {
            selectedFriends.removeObject(roster)
            cell.setChecked(false)
        } else {
            selectedFriends.addObject(roster)
            cell.setChecked(true)
        }
        
        if selectedFriends.count > 0 {
            okBtn.title = "OK(\(selectedFriends.count))"
            okBtn.enabled = true
        } else {
            okBtn.title = "OK"
            okBtn.enabled = false
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        

    }
    
}

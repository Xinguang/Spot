//
//  ContactDetailViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/25.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class ContactDetailViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var pUser: PFObject!
    
    var isFromMessageViewController = false
    
    var headerView: ContactDetailHeaderView!
    var footerView: ContactDetailFooterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseController.getPUserByKeyIncludeAvatarIgnoreCache("openfireId", value: pUser["openfireId"] as String) { (pUser, data, error) -> Void in
            self.pUser = pUser
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

// MARK: - UITableView

extension ContactDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        if indexPath.row == 0 {
            cell.textLabel?.text = "駅"
        }
        
        if indexPath.row == 1 {
            cell.textLabel?.text = "タグ"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 90
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 150
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if headerView == nil {
            headerView = Util.createViewWithNibName("ContactDetailHeaderView") as ContactDetailHeaderView
        }
        
        headerView.pUser = pUser
    
        return headerView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if footerView == nil {
            footerView = Util.createViewWithNibName("ContactDetailFooterView") as ContactDetailFooterView
            footerView.delegate = self
        }
        
        footerView.pUser = pUser
    
        return footerView
    }
}

// MARK: - ContactDetailFooterViewDelegate

extension ContactDetailViewController: ContactDetailFooterViewDelegate {
    
    func didTappedChatBtn(footerView: ContactDetailFooterView, pUser: PFObject) {
        if isFromMessageViewController {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            let tabController = self.navigationController?.tabBarController as? TabBarController
            
            tabController?.enterMessageViewControllerWithPUser(pUser)
        }
    }
    
    func didTappedAddFriendBtn(footerView: ContactDetailFooterView, pUser: PFObject) {
        XMPPManager.addFriend(pUser)
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}

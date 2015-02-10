//
//  AccountViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/06.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

let circleImageName = "31-circle-plus-large"

class AccountViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var fsc: NSFetchedResultsController!
    var userCount: Int! {
        if let sectionInfo = fsc.sections?[0] as? NSFetchedResultsSectionInfo {
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fsc = User.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "uniqueIdentifier", ascending: true)
        fsc.delegate = self
//        user = User.MR_findFirst() as User
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension AccountViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 2
//    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCount + 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "アカウント"
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let accountCellIdentifier = "accountCellIdentifier"
        let addAccountCellIdentifier = "addAccountCellIdentifier"
        
        if indexPath.section == 0 && indexPath.row == userCount {
            var cell = tableView.dequeueReusableCellWithIdentifier(addAccountCellIdentifier) as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: addAccountCellIdentifier)
                cell?.textLabel?.text = "アカウント追加"
                cell?.imageView?.image = UIImage(named: circleImageName)
                cell?.detailTextLabel?.text = nil
            }
            
            return cell!
        }
        
        if let user = fsc.objectAtIndexPath(indexPath) as? User {
            var cell = tableView.dequeueReusableCellWithIdentifier(accountCellIdentifier) as? UITableViewCell
            if cell == nil {
                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: accountCellIdentifier)
                cell?.textLabel?.text = user.username
//                cell?.imageView?.image = UIImage(named: circleImageName)
                cell?.detailTextLabel?.text = nil
            }
            
            return cell!
        } else {
//            var cell = tableView.dequeueReusableCellWithIdentifier(addAccountCellIdentifier) as? UITableViewCell
//            if cell == nil {
//                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: addAccountCellIdentifier)
//                cell?.textLabel?.text = "アカウント追加"
//                cell?.imageView?.image = UIImage(named: circleImageName)
//                cell?.detailTextLabel?.text = nil
//            }
//            cell = [tableView dequeueReusableCellWithIdentifier:addAccountCellIdentifier];
//            if (cell == nil) {
//                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:addAccountCellIdentifier];
//                cell.textLabel.text = NEW_ACCOUNT_STRING;
//                cell.imageView.image = [UIImage imageNamed:circleImageName];
//                cell.detailTextLabel.text = nil;
//            }
        }
        
        return UITableViewCell()
        
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCellWithIdentifier("SearchBarCell", forIndexPath: indexPath) as UITableViewCell
//            return cell
//        }
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as UITableViewCell
//        
//        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == userCount {
            self.performSegueWithIdentifier("SegueCreateAccountNavi", sender: nil)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

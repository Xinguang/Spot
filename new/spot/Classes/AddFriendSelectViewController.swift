//
//  AddContactSelectViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/12.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class AddFriendSelectViewController: UITableViewController {

    var searchController :UISearchController!
    var resultVC: FriendSearchResultTableViewController!
    
    @IBOutlet weak var searchBarCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resultVC = storyboard?.instantiateViewControllerWithIdentifier("FriendSearchResultTableViewController") as FriendSearchResultTableViewController
        resultVC.delegate = self
        
        searchController = UISearchController(searchResultsController: resultVC)
//        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "現場TOMOID"
        tableView.tableHeaderView = searchController.searchBar
        
//        searchBarCell.contentView.addSubview(searchController.searchBar)
//        searchController.searchBar.setTranslatesAutoresizingMaskIntoConstraints(false)
//        searchBarCell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[searchBar]|", options: nil, metrics: nil, views: ["searchBar" : searchController.searchBar]))
//        
//        searchBarCell.contentView.addConstraint(NSLayoutConstraint(item: searchController.searchBar, attribute: NSLayoutAttribute.CenterY, relatedBy: .Equal, toItem: searchBarCell.contentView, attribute: .CenterY, multiplier: 1.0, constant: 0))
        
//        searchBarCell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[searchBar]-|", options: nil, metrics: nil, views: ["searchBar" : searchController.searchBar]))
        
        searchController.delegate = self
        searchController.searchBar.delegate = self    // so we can monitor text changes + others
        
        // Search is now just presenting a view controller. As such, normal view controller
        // presentation semantics apply. Namely that presentation will walk up the view controller
        // hierarchy until it finds the root view controller or one that defines a presentation context.
        definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#EFEFF4")
        
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont.systemFontOfSize(14)
        label.text = "私の現場トモID:未設定"
        
        if let username = XMPPManager.instance.account.username {
            if username.length > 0 {
                label.text = "私の現場トモID:\(username)"
            }
        }
        
        view.addSubview(label)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[label]", options: nil, metrics: nil, views: ["label" : label]))
        view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0))
        
        return view
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 1 {
//            return 50
//        }
        
        return 50
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.row {
        case 1 : //QQ
            SNSController.instance.qqShare(0, title: "現場TOMO", description: "招待テストテストテストテストテスト", url: "http://www.e-business.co.jp")
            break;
        case 2://weChat
            SNSController.instance.wxShare(0, title: "現場TOMO", description: "招待テストテストテストテストテスト")
            break;
        case 3://weChat
            SNSController.instance.wxShare(1, title: "現場TOMO", description: "招待テストテストテストテストテスト")
            break;
        default:
            break
        }
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

//extension AddFriendSelectViewController: UISearchResultsUpdating {
//    
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        
//    }
//}

extension AddFriendSelectViewController: UISearchControllerDelegate {
    
}

extension AddFriendSelectViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.resultVC.isEmpty = false
        self.resultVC.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        // TODO: change timing
        SVProgressHUD.showWithMaskType(.Clear)

        ParseController.getUserByKey("username", value: searchBar.text) { (pUser, error) -> Void in
            if let error = error {
                if error.code == 101 {
                    SVProgressHUD.dismiss()
                    
                    self.resultVC.isEmpty = true
                    self.resultVC.tableView.reloadData()
                } else {
                    SVProgressHUD.showErrorWithStatus(error.localizedDescription, maskType: .Clear)
                }
            } else if let pUser = pUser {
                //                self.resultVC.pUserModels = [pUserModel]
                //                self.resultVC.tableView.reloadData()
                
//                //get vcard
//                XMPPManager.getVCard(pUserModel.xmppJID(), done: { () -> Void in
//                    SVProgressHUD.dismiss()
//                    
//                    // go to detail
//                    Util.enterFriendDetailViewController(pUserModel.xmppJID(), username: pUserModel.username, from: self, isTalking: false)
//                })
                
            } else {
                SVProgressHUD.dismiss()
                
                self.resultVC.isEmpty = true
                self.resultVC.tableView.reloadData()
            }
        }
    }
    
}

extension AddFriendSelectViewController: FriendSearchResultTableViewControllerDelegate {
    func didSelectJID(jid: XMPPJID) {
        Util.enterFriendDetailViewController(jid, username: nil, from: self, isTalking: false)
    }
}

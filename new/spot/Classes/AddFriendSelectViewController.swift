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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var resultVC = storyboard?.instantiateViewControllerWithIdentifier("FriendSearchResultTableViewController") as FriendSearchResultTableViewController
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

//extension AddFriendSelectViewController: UISearchResultsUpdating {
//    
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        
//    }
//}

extension AddFriendSelectViewController: UISearchControllerDelegate {
    
}

extension AddFriendSelectViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        SVProgressHUD.showWithStatus("検索中...", maskType: .Clear)

        XMPPManager.instance.search(searchBar.text)
    }
}



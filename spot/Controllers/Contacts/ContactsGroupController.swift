//
//  ContactsGroupController.swift
//  spot
//
//  Created by Hikaru on 2014/12/03.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation

class ContactsGroupController: UITableViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate{
    
    var msgRow: [MessageRow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var img:UIImage = UIImage(named: "background")!
        self.tableView.backgroundColor = UIColor(patternImage: img);
    
        self.msgRow = TestData.instance.tableViewData("グループ",subtitle: "メンバー")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Section
    override func tableView(tableView: UITableView, numberOfRowsInSection section:  Int) -> Int{
        return self.msgRow.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView .dequeueReusableCellWithIdentifier("cell_message", forIndexPath: indexPath) as MessageCell
        cell.imageView?.image = self.msgRow[indexPath.row].image
        cell.titleLable.text = self.msgRow[indexPath.row].title
        cell.subTitleLable.text = self.msgRow[indexPath.row].subtitle
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let view: UIViewController = segue.destinationViewController as UIViewController
        if let cell = sender as? MessageCell{
            view.title = cell.titleLable.text
        }
        view.hidesBottomBarWhenPushed = true
    }
    
    //search bar
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true;
        return true
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        searchBar.showsCancelButton = false;
    }
    
    
    
}
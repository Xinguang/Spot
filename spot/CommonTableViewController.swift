//
//  CommonTableViewController.swift
//  spot
//
//  Created by Hikaru on 2014/12/22.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//


import UIKit

protocol CommonTableViewDelegate{
    func tableViewOnSelect(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, didSelectDataRow dataRow: MessageRow)
}
class CommonTableViewController: CommonController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate{
    
    var msgData: [MessageData] = []
    var delegate:CommonTableViewDelegate?
    //Sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return self.msgData.count;
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.msgData[section].title
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if("" == self.msgData[section].title){
            return 0
        }else{
            return 30
        }
    }

    //Section
    func tableView(tableView: UITableView, numberOfRowsInSection section:  Int) -> Int{
        return self.msgData[section].msgRow.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView .dequeueReusableCellWithIdentifier("cell_message", forIndexPath: indexPath) as MessageCell
        
        let datarow = self.msgData[indexPath.section].msgRow[indexPath.row];
        cell.imageView?.image = datarow.image
        cell.titleLable.text = datarow.title
        cell.subTitleLable.text = datarow.subtitle
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.delegate?.tableViewOnSelect(tableView, didSelectRowAtIndexPath:indexPath, didSelectDataRow: self.msgData[indexPath.section].msgRow[indexPath.row])    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60;
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

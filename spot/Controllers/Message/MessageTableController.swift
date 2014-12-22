//
//  MessageTableController.swift
//  spot
//
//  Created by Hikaru on 2014/11/27.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit

class MessageTableController: UITableViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate{
    
    var msgRow: [MessageRow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var img:UIImage = UIImage(named: "background")!
        //self.tableView.backgroundColor = UIColor(patternImage: img);
        
        self.msgRow = TestData.instance.tableViewData("メッセージ",subtitle: "「システム・友人・イベント・掲示板」からのメッセージ")
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    //Sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 1;
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "sectionRow  \(section)"
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30;
    }
    */
    //Section
    override func tableView(tableView: UITableView, numberOfRowsInSection section:  Int) -> Int{
        return self.msgRow.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView .dequeueReusableCellWithIdentifier("cell_message", forIndexPath: indexPath) as MessageCell
        
        let datarow = self.msgRow[indexPath.row];
        
        cell.icon.image = datarow.image
        cell.titleLable.text = datarow.title
        cell.subTitleLable.text = datarow.subtitle
        return cell
        /*
        let cell = self.tableview.dequeueReusableCellWithIdentifier("cell_message", forIndexPath: indexPath) as UITableViewCell;//MessageCell;
        cell.textLabel.text = "Row #  \(self.dataArray!.objectAtIndex(indexPath.row))";
        //cell.titleLable.text = "Row #  \(self.dataArray!.objectAtIndex(indexPath.row))"
        return cell
        */
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        let vc:MessageController = segue.destinationViewController as MessageController;
        vc.title = cell.titleLable.text!
        vc.hidesBottomBarWhenPushed = true;
        */
        let view:MessageDetailController = segue.destinationViewController as MessageDetailController;
        if let cell = sender as? MessageCell{
            view.title = cell.titleLable.text
        }else if let text = sender as? NSString{
            view.title = text
        }else{
            view.title = "詳細"
        }
        view.hidesBottomBarWhenPushed = true;
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

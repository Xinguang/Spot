//
//  ContactsTableController.swift
//  spot
//
//  Created by Hikaru on 2014/11/27.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit

class ContactsTableController: UITableViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate{
    
    var systemDataArray: NSMutableArray?
    var dataArray: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var img:UIImage = UIImage(named: "background")!
        self.tableView.backgroundColor = UIColor(patternImage: img);
        
        
        self.systemDataArray = NSMutableArray()
        self.systemDataArray!.addObject("招待")
        self.systemDataArray!.addObject("グループ")
        self.systemDataArray!.addObject("付近")
        self.systemDataArray!.addObject("イベント")
        self.systemDataArray!.addObject("掲示板")
        self.dataArray = NSMutableArray()
        self.dataArray!.addObject("Aさん")
        self.dataArray!.addObject("Bさん")
        self.dataArray!.addObject("Cさん")
        self.dataArray!.addObject("Dさん")
        self.dataArray!.addObject("Eさん")
        self.dataArray!.addObject("Fさん")
        self.dataArray!.addObject("Gさん")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //Sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2;
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return ""
        }else{
            return "友人  \(section)"
        }
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0;
        }else{
            return 30;
        }
    }
    
    //Section
    override func tableView(tableView: UITableView, numberOfRowsInSection section:  Int) -> Int{
        if(section == 1){
            return self.dataArray!.count
        }else{
            return self.systemDataArray!.count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView .dequeueReusableCellWithIdentifier("cell_message", forIndexPath: indexPath) as MessageCell
        
        if(indexPath.section == 1){
            cell.titleLable.text = self.dataArray?.objectAtIndex(indexPath.row) as? String//String(format: "%i", indexPath.row+1)
        }else{
            cell.titleLable.text = self.systemDataArray?.objectAtIndex(indexPath.row) as? String
        }
        return cell
        /*
        let cell = self.tableview.dequeueReusableCellWithIdentifier("cell_message", forIndexPath: indexPath) as UITableViewCell;//MessageCell;
        cell.textLabel.text = "Row #  \(self.dataArray!.objectAtIndex(indexPath.row))";
        //cell.titleLable.text = "Row #  \(self.dataArray!.objectAtIndex(indexPath.row))"
        return cell
        */
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //NSLog("%@", indexPath.section)
        var text:String = ""
        if(0 == indexPath.section ){
            text = self.systemDataArray?.objectAtIndex(indexPath.row) as String
            var identifier = "contacts_nearly";
            if("グループ" == text){
                identifier = "contacts_group";
            }else if("招待" == text){
                identifier = "contacts_weixinqq";
            }else if("付近" == text){
                identifier = "contacts_nearly";
            }else if("イベント" == text){
                identifier = "contacts_event";
            }else if("掲示板" == text){
                identifier = "contacts_bbs";
            }
            performSegueWithIdentifier(identifier,sender: text)
        }else{
            text = self.dataArray?.objectAtIndex(indexPath.row) as String
            performSegueWithIdentifier("contacts_person",sender: text)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let view: UIViewController = segue.destinationViewController as UIViewController
        if let text = sender as? String {
            view.title = text
        }
        view.hidesBottomBarWhenPushed = true
        /*
        if (segue.identifier == "contacts_person") {
            let vc:ContactsDetailController = segue.destinationViewController as ContactsDetailController;
            vc.title = text
            vc.hidesBottomBarWhenPushed = true;
        }else if(segue.identifier == "contacts_nearly") {
            let vc:ContactsMapController = segue.destinationViewController as ContactsMapController;
            vc.title = text
            vc.hidesBottomBarWhenPushed = true;
        }else if(segue.identifier == "contacts_group") {
            let vc:ContactsGroupController = segue.destinationViewController as ContactsGroupController;
            vc.title = text
            vc.hidesBottomBarWhenPushed = true;
        }else if(segue.identifier == "contacts_weixinqq") {
            let vc:ContactsWeiXinQQController = segue.destinationViewController as ContactsWeiXinQQController;
            vc.title = text
            vc.hidesBottomBarWhenPushed = true;
            
        }
        */
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
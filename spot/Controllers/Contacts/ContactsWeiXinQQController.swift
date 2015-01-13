//
//  ContactsWeiXinQQController.swift
//  spot
//
//  Created by Hikaru on 2014/12/03.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation


class ContactsWeiXinQQController: UITableViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate{
    
    var dataArray: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var img:UIImage = UIImage(named: "background")!
        //self.tableView.backgroundColor = UIColor(patternImage: img);
        
        self.dataArray = NSMutableArray()
        self.dataArray!.addObject("電話帳Aさん")
        self.dataArray!.addObject("電話帳Bさん")
        self.dataArray!.addObject("電話帳Cさん")
        self.dataArray!.addObject("電話帳Dさん")
        self.dataArray!.addObject("WeixinAさん")
        self.dataArray!.addObject("WeixinBさん")
        self.dataArray!.addObject("WeixinCさん")
        self.dataArray!.addObject("WeixinDさん")
        self.dataArray!.addObject("QQAさん")
        self.dataArray!.addObject("QQBさん")
        self.dataArray!.addObject("QQCさん")
        self.dataArray!.addObject("QQDさん")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Section
    override func tableView(tableView: UITableView, numberOfRowsInSection section:  Int) -> Int{
        return self.dataArray!.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView .dequeueReusableCellWithIdentifier("cell_message", forIndexPath: indexPath) as MessageCell
        
        cell.titleLable.text = self.dataArray?.objectAtIndex(indexPath.row) as? String
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let view: UIViewController = segue.destinationViewController as UIViewController
        
        if let cell = sender as? MessageCell{
            view.title = cell.titleLable.text
        }else if let text = sender as? NSString{
            view.title = text
        }else{
            view.title = "詳細"
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
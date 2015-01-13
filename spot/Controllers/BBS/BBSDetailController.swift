//
//  BBSDetailController.swift
//  spot
//
//  Created by Hikaru on 2015/01/06.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import Foundation

class BBSDetailController : CommonController{
    
    @IBOutlet var tableView: UITableView!
    
    
    var msgRow: [CellRow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor =  UIColor.lightGrayColor()
        
        
        //self.tableView.tableHeaderView = BBSDetailHeaderView(frame: CGRectMake(0, 64, self.tableView.frame.size.width, 300))
        self.tableView.tableHeaderView = self.tableViewHeader(self.tableView)
        
        self.msgRow = TestData.instance.tableViewData("設定",subtitle: "subtitle")
    }
    
    func tableViewHeader(tableView: UITableView) -> UIView? {
        let header = tableView .dequeueReusableCellWithIdentifier("cell_header") as CellBBSHeader
        
        
        if let param = self.paramData as? Dictionary<String, AnyObject> {
            let imageurl = param["imageurl"] as? String
            let userface = param["userface"] as? String
            let username = param["username"] as? String
            let detailLabel = param["contents"] as? String
            
      
            header.configureWithContents(username!, userface: userface!, imageurl: imageurl!, contents: detailLabel!)
        }
        return header
        
    }
    
    //Section
    func tableView(tableView: UITableView, numberOfRowsInSection section:  Int) -> Int{
        return self.msgRow.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView .dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let datarow = self.msgRow[indexPath.row];
        
        cell.textLabel!.text = datarow.title;
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }

}
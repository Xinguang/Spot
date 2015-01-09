//
//  BBSDetailController.swift
//  spot
//
//  Created by Hikaru on 2015/01/06.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import Foundation

class BBSDetailController : CommonController{
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var tableView: UITableView!
    
    
    var msgRow: [CellRow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor =  UIColor.redColor()
        
        
        //self.tableView.tableHeaderView = BBSDetailHeaderView(frame: CGRectMake(0, 64, self.tableView.frame.size.width, 300))
        
        
        self.msgRow = TestData.instance.tableViewData("設定",subtitle: "subtitle")
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if("tableHeader" == segue.identifier){
            var viewController = segue.destinationViewController as? BBSDetailHeaderController;
            viewController?.paramData = self.paramData
            viewController?.OuterView = self.headerView

        }else{
            super.prepareForSegue(segue, sender: sender)
        }
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
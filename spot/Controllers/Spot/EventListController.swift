//
//  EventListController.swift
//  spot
//
//  Created by Hikaru on 2014/12/24.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation

class EventListController:CommonController ,CommonTableViewDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "作成", style: .Plain, target: self, action: Selector("eventCreate"))
    }
    func eventCreate(){
        self.performSegueWithIdentifier("event_create",sender: "イベントを作成")
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var viewController = segue.destinationViewController as? CommonTableViewController;
        if("contact_event_list" == segue.identifier){
            var msgData = [
                MessageData(title: "", msgRows: TestData.instance.tableViewData("イベント",subtitle: "メンバー"))
            ]
            viewController?.msgData = msgData
            viewController?.delegate = self   
        }
    }
    func tableViewOnSelect(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, didSelectDataRow dataRow: MessageRow)->(identifier: String, sender: AnyObject){
        return ("event_detail",dataRow.title)
        
    }
}
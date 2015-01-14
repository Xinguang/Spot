//
//  MessageListController.swift
//  spot
//
//  Created by Hikaru on 2014/12/22.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation
class MessageListController:CommonController,CommonTableViewDelegate {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         var viewController = segue.destinationViewController as? CommonTableViewController;
        
        if( "message_list" == segue.identifier ){
            var msgData = [
                CellData(title: "", msgRows: TestData.instance.systemMessageList()),
                CellData(title: "友人", msgRows: TestData.instance.getUserList())
                
            ]
            viewController?.msgData = msgData
            viewController?.delegate = self
        }
    }
    func tableViewOnSelect(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, didSelectDataRow dataRow: CellRow)->(identifier: String, sender: AnyObject)?{
        
        return ("message_detail",dataRow.title)
        
    }

}
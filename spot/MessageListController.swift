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
                MessageData(title: "", msgRows: TestData.instance.tableViewData("メッセージ",subtitle: "「システム・友人・イベント・掲示板」からのメッセージ"))
            ]
            viewController?.msgData = msgData
            viewController?.delegate = self
        }
    }
    func tableViewOnSelect(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, didSelectDataRow dataRow: MessageRow)->(identifier: String, sender: AnyObject){
        
        return ("message_detail",dataRow.title)
        
    }

}
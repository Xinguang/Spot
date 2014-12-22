//
//  MessageListController.swift
//  spot
//
//  Created by Hikaru on 2014/12/22.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation
class MessageListController:CommonController,CommonTableViewDelegate {
    var viewController:CommonTableViewController?
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        self.viewController = segue.destinationViewController as? CommonTableViewController;
        
        if( "message_list" == segue.identifier ){
            var msgData = [
                MessageData(title: "", msgRows: TestData.instance.tableViewData("メッセージ",subtitle: "「システム・友人・イベント・掲示板」からのメッセージ"))
            ]
            self.viewController?.msgData = msgData
            self.viewController?.delegate = self
        }
    }
    func tableViewOnSelect(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, didSelectDataRow dataRow: MessageRow){
        
        var text:String = dataRow.title
        self.viewController?.performSegueWithIdentifier("message_detail",sender: text)
        
    }

}
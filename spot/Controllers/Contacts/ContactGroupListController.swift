//
//  ContactGroupListController.swift
//  spot
//
//  Created by Hikaru on 2014/12/24.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation

class ContactsGroupListController:CommonController ,CommonTableViewDelegate{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var viewController = segue.destinationViewController as? CommonTableViewController;
        viewController?.identifier = segue.identifier!
        viewController?.delegate = self
        if("contact_group_list" == segue.identifier){
            var msgData = [
                CellData(title: "", msgRows: TestData.instance.tableViewData("グループ",subtitle: "メンバー"))
            ]
            viewController?.msgData = msgData
        }
    }
    func tableViewOnSelect(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, didSelectDataRow dataRow: CellRow)->(identifier: String, sender: AnyObject){
        return ("contact_person_list",dataRow.title)
        
    }
}
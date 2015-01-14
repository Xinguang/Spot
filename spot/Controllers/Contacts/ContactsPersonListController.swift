//
//  ContactsPersonListController.swift
//  spot
//
//  Created by Hikaru on 2014/01/15.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation


class ContactsPersonListController:CommonController ,CommonTableViewDelegate{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var viewController = segue.destinationViewController as? CommonTableViewController;
        if("contact_person_list" == segue.identifier){
            var msgData:[CellData] = []
            msgData.append(CellData(title: "", msgRows: TestData.instance.getUserList()))
            viewController?.msgData = msgData
            viewController?.delegate = self
        }
    }
    func tableViewOnSelect(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, didSelectDataRow dataRow: CellRow)->(identifier: String, sender: AnyObject)?{
        
        var text:String = dataRow.title
        var identifier = "contacts_person"
        return (identifier,text)
        
    }
}
//
//  ContactListController.swift
//  spot
//
//  Created by Hikaru on 2014/12/22.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import Foundation

class ContactListController:CommonController ,CommonTableViewDelegate{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var viewController = segue.destinationViewController as? CommonTableViewController;
        if("contact_list" == segue.identifier){
            var img:UIImage = UIImage(named: "icon_qq")!
            let msgRow = [
                MessageRow(image: img, title: "招待", subtitle: "招待招待"),
                MessageRow(image: img, title: "グループ", subtitle: "グループ"),
                MessageRow(image: img, title: "付近", subtitle: "付近付近"),
                MessageRow(image: img, title: "イベント", subtitle: "イベント"),
                MessageRow(image: img, title: "掲示板", subtitle: "掲示板"),
            ]
            var msgData = [
                MessageData(title: "", msgRows: msgRow)
            ]
            msgData.append(MessageData(title: "友人", msgRows: TestData.instance.tableViewData("XXさん",subtitle: "XXさんの連絡情報xdxcdxcdffsdgsfgfdhgfdgsdhsgertsfghgfsfgdzfdsgfgf")))
            viewController?.msgData = msgData
            viewController?.delegate = self
        }
    }
    func tableViewOnSelect(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, didSelectDataRow dataRow: MessageRow)->(identifier: String, sender: AnyObject){
        
        var text:String = dataRow.title
        var identifier = "contacts_person"
        
        if(0 == indexPath.section ){
            if("グループ" == text){
                identifier = "contacts_group";
            }else if("招待" == text){
                identifier = "contact_person_list";
            }else if("付近" == text){
                identifier = "contacts_nearly";
            }else if("イベント" == text){
                identifier = "contacts_event";
            }else if("掲示板" == text){
                identifier = "contacts_bbs";
            }
        }
        return (identifier,text)

    }
}
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
                CellRow(image: CommonHelper.instance.coloredImage(UIImage(named: "icon_setting")!, color:CommonHelper.instance.UIColorFromRGB(0xFF00FF, alpha: 0.75)), title: "設定", subtitle: "個人情報"),
                CellRow(image: CommonHelper.instance.coloredImage(UIImage(named: "icon_share")!, color:CommonHelper.instance.UIColorFromRGB(0xF2BD5A, alpha: 0.75)), title: "招待", subtitle: "招待招待"),
                //CellRow(image: CommonHelper.instance.coloredImage(UIImage(named: "icon_member")!, color:CommonHelper.instance.UIColorFromRGB(0x7AEA9C, alpha: 0.75)), title: "グループ", subtitle: "グループ"),
                //CellRow(image: CommonHelper.instance.coloredImage(UIImage(named: "icon_spot")!, color:CommonHelper.instance.UIColorFromRGB(0xE33B6D, alpha: 0.75)), title: "付近", subtitle: "付近付近"),
                //CellRow(image: CommonHelper.instance.coloredImage(UIImage(named: "icon_event")!, color:CommonHelper.instance.UIColorFromRGB(0x4166CC, alpha: 0.75)), title: "イベント", subtitle: "イベント"),
                CellRow(image: CommonHelper.instance.coloredImage(UIImage(named: "icon_bbs")!, color:CommonHelper.instance.UIColorFromRGB(0x41CC9E, alpha: 0.75)), title: "掲示板", subtitle: "掲示板"),
            ]
            var msgData = [
                CellData(title: "", msgRows: msgRow)
            ]
            msgData.append(CellData(title: "友人", msgRows: TestData.instance.getUserList()))
            viewController?.msgData = msgData
            viewController?.delegate = self
        }
    }
    func tableViewOnSelect(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, didSelectDataRow dataRow: CellRow)->(identifier: String, sender: AnyObject)?{
        
        var text:String = dataRow.title
        var identifier = "contacts_person"
        
        if(0 == indexPath.section ){
            if("設定" == text){
                identifier = "contacts_person";
            }else if("グループ" == text){
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
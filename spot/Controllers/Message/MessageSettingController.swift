//
//  MessageSettingController.swift
//  spot
//
//  Created by Hikaru on 2015/01/14.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//

import Foundation

class MessageSettingController:CommonController,CommonTableViewDelegate {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var viewController = segue.destinationViewController as? CommonTableViewController;
        
        if( "message_setting" == segue.identifier ){
            let msgRow = [
                CellRow(image: CommonHelper.instance.coloredImage(UIImage(named: "smile")!, color:CommonHelper.instance.UIColorFromRGB(0xF2BD5A, alpha: 0.75)), title: "プッシュ", subtitle: "受ける"),
                CellRow(image: CommonHelper.instance.coloredImage(UIImage(named: "smile")!, color:CommonHelper.instance.UIColorFromRGB(0xF2BD5A, alpha: 0.75)), title: "受信", subtitle: "受信する"),
                CellRow(image: CommonHelper.instance.coloredImage(UIImage(named: "smile")!, color:CommonHelper.instance.UIColorFromRGB(0x7AEA9C, alpha: 0.75)), title: "設定ア", subtitle: "設定あ"),
                CellRow(image: CommonHelper.instance.coloredImage(UIImage(named: "smile")!, color:CommonHelper.instance.UIColorFromRGB(0x7AEA9C, alpha: 0.75)), title: "設定い", subtitle: "設定い"),
            ]
            var msgData = [
                CellData(title: "", msgRows: msgRow)
            ]
            viewController?.msgData = msgData
            viewController?.delegate = self
        }
    }
    func didLoad(view:CommonTableViewController){
        view.searchBar.hidden = true;
    }
    func tableViewOnSelect(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath, didSelectDataRow dataRow: CellRow)->(identifier: String, sender: AnyObject)?{
        
        return nil
        
    }
    
}
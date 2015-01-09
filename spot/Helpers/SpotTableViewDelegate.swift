//
//  SpotTableViewDelegate.swift
//  spot
//
//  Created by Hikaru on 2015/01/09.
//  Copyright (c) 2015年 Hikaru. All rights reserved.
//
protocol SpotTableViewDelegate{
    func onSelect(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath,didSelectRowData data:AnyObject?)
}
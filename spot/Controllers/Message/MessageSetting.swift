//
//  MessageSetting.swift
//  spot
//
//  Created by Hikaru on 2014/12/03.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit
class MessageSetting: CommonController , UITableViewDataSource, UITableViewDelegate{
    
    var tableView : UITableView?
    var msgRow: [CellRow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.msgRow = TestData.instance.tableViewData("設定",subtitle: "subtitle")
        
        
        
        tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        tableView!.delegate = self;
        tableView!.dataSource = self;
        
        tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(tableView!)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //Section
    func tableView(tableView: UITableView, numberOfRowsInSection section:  Int) -> Int{
        return self.msgRow.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView .dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let switchview = UISwitch(frame: CGRectZero)
        cell.accessoryView = switchview;
        
        let datarow = self.msgRow[indexPath.row];
        
        cell.textLabel!.text = datarow.title;
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
}


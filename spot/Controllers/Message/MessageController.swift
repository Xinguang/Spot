//
//  MessageController.swift
//  spot
//
//  Created by Hikaru on 2014/11/28.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit

class MessageController: UITableViewController, UITableViewDataSource, UITableViewDelegate{
    
    var msg: [MessageModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var img:UIImage = UIImage(named: "background")!
        self.tableView.backgroundColor = UIColor(patternImage: img);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        var tableFrame = self.tableView.frame;
        
        tableFrame.size.height = self.tableView.frame.size.height - 44 ;
        
        self.tableView.frame = tableFrame;
        
        self.msg = TestData.instance.messageData()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Section
    override func tableView(tableView: UITableView, numberOfRowsInSection section:  Int) -> Int{
        return self.msg.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let datarow = self.msg[indexPath.row];
        var cell = tableView.dequeueReusableCellWithIdentifier("cell_chat") as CellChat!
        if cell == nil {
            cell = CellChat(style: .Default, reuseIdentifier: "cell_chat")
        }
        let message = datarow.text
        var imageName = "user" + String(datarow.userid) + ".jpg"
        if(datarow.userid > 15){
            imageName = "user1.jpg"
        }
        cell.configureWithMessage(datarow.userid < 16,imageUrl: imageName,message: message)
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let view:MessageController = segue.destinationViewController as MessageController;
        if let cell = sender as? MessageCell{
            view.title = cell.titleLable.text
        }else if let text = sender as? NSString{
            view.title = text
        }else{
            view.title = "詳細"
        }
        view.hidesBottomBarWhenPushed = true;
    }
    
    
}

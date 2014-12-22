//
//  MessageController.swift
//  spot
//
//  Created by Hikaru on 2014/11/28.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit

class MessageController: UITableViewController, UITableViewDataSource, UITableViewDelegate{
    
    var msgRow: [MessageRow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var img:UIImage = UIImage(named: "background")!
        self.tableView.backgroundColor = UIColor(patternImage: img);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        var tableFrame = self.tableView.frame;
        
        tableFrame.size.height = self.tableView.frame.size.height - 44 ;
        
        self.tableView.frame = tableFrame;
        
        
        self.msgRow = TestData.instance.tableViewData("title",subtitle: "subtitle")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Section
    override func tableView(tableView: UITableView, numberOfRowsInSection section:  Int) -> Int{
        return self.msgRow.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell_messagedetail", forIndexPath: indexPath) as MessageDetailCell
        
        let datarow = self.msgRow[indexPath.row];
        
        cell.icon_friend.image = nil;
        cell.icon_me.image     = nil;
        cell.message.text = datarow.title
        
        if((indexPath.row % 2) == 0 ){
            cell.backImage.image = UIImage(named: "chat1")!
            cell.icon_me.image = UIImage(named: "me")!
        }else{
            cell.backImage.image = UIImage(named: "chat")!
            cell.icon_friend.image = UIImage(named: "icon_qq")!
        }
        
        var frame = cell.message.frame;
        
        frame.size.width = cell.frame.size.width - 150;
        
        cell.message.frame = frame
        cell.message.numberOfLines = 0
        cell.message.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.message.sizeToFit()
        
        var frame_back = cell.backImage.frame;
        
        frame_back.size.width = frame.size.width + 20;
        frame_back.size.height = frame.size.height + 10;
        if(frame_back.size.height < 70){
            frame_back.size.height=70
        }
        
        cell.backImage.frame = frame_back
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
        /*
        let datarow = self.msgRow[indexPath.row];
        
        let label: UILabel = {
        let temporaryLabel = UILabel(frame: CGRect(x: 0, y: 0, width: Int.max, height: Int.max))
        temporaryLabel.text = datarow.title
        return temporaryLabel
        }()
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        label.frame = CGRectMake(0, 0, self.tableView.frame.size.width-150, 70)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.sizeToFit()
        return label.frame.height * 1.7 + 50
        */
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

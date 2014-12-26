//
//  EventDetailController.swift
//  spot
//
//  Created by Hikaru on 2014/12/05.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit

class EventDetailController :CommonController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var eventImage: UIImageView!
    
    
    var msgRow: [CellRow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.eventImage.image = UIImage(named: "bg_event")!
        
        var icon = UIImageView(frame: CGRect(x: 20,y: 20,width: 50,height: 50))
        icon.layer.cornerRadius = CGRectGetHeight(icon.bounds) / 2
        icon.layer.masksToBounds = true;
        
        icon.layer.borderWidth = 5
        //icon.layer.borderColor = CGColor(UIColor.whiteColor())
        icon.image = UIImage(named: "icon_qq")

        self.eventImage.addSubview(icon)
        
        
        self.msgRow = [
            CellRow(image: UIImage(named: "icon_qq")!,title: "責任者",subtitle: ""),
            CellRow(image: UIImage(named: "icon_qq")!,title: "開催時間",subtitle: ""),
            CellRow(image: UIImage(named: "icon_qq")!,title: "開催場所",subtitle: ""),
            CellRow(image: UIImage(named: "icon_qq")!,title: "参加条件",subtitle: ""),
            CellRow(image: UIImage(named: "icon_qq")!,title: "概要",subtitle: ""),
            CellRow(image: UIImage(named: "icon_qq")!,title: "連絡事項",subtitle: ""),
        ];
    }

    
    
    
    
    
    //Section
    func tableView(tableView: UITableView, numberOfRowsInSection section:  Int) -> Int{
        return self.msgRow.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView .dequeueReusableCellWithIdentifier("cell_message", forIndexPath: indexPath) as MessageCell
        let datarow = self.msgRow[indexPath.row];
        
        cell.titleLable.text = datarow.title;
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }

}
//
//  BBSListcontroller.swift
//  spot
//
//  Created by Hikaru on 2014/12/05.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import UIKit

class BBSListcontroller :CommonController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var eventImage: UIImageView!
    
    
    var msgRow: [MessageRow] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.eventImage.image = UIImage(named: "bg_event")!
        
        self.msgRow = [
            MessageRow(image: UIImage(named: "bg_event")!,title: "不具合",subtitle: "直接依頼のプロジェクトキャンセルのメールが他のユーザーに複数配信される"),
            MessageRow(image: UIImage(named: "bg_event")!,title: "不具合",subtitle: "直接依頼のプロジェクトキャンセルのメールが他のユーザーに複数配信される"),
            MessageRow(image: UIImage(named: "bg_event")!,title: "不具合",subtitle: "直接依頼のプロジェクトキャンセルのメールが他のユーザーに複数配信される"),
            MessageRow(image: UIImage(named: "bg_event")!,title: "不具合",subtitle: "直接依頼のプロジェクトキャンセルのメールが他のユーザーに複数配信される"),
            MessageRow(image: UIImage(named: "bg_event")!,title: "不具合",subtitle: "直接依頼のプロジェクトキャンセルのメールが他のユーザーに複数配信される"),
            MessageRow(image: UIImage(named: "bg_event")!,title: "不具合",subtitle: "直接依頼のプロジェクトキャンセルのメールが他のユーザーに複数配信される"),
            MessageRow(image: UIImage(named: "bg_event")!,title: "不具合",subtitle: "直接依頼のプロジェクトキャンセルのメールが他のユーザーに複数配信される"),
            MessageRow(image: UIImage(named: "bg_event")!,title: "不具合",subtitle: "直接依頼のプロジェクトキャンセルのメールが他のユーザーに複数配信される"),
            MessageRow(image: UIImage(named: "bg_event")!,title: "不具合",subtitle: "直接依頼のプロジェクトキャンセルのメールが他のユーザーに複数配信される"),
            MessageRow(image: UIImage(named: "bg_event")!,title: "不具合",subtitle: "直接依頼のプロジェクトキャンセルのメールが他のユーザーに複数配信される"),
            MessageRow(image: UIImage(named: "bg_event")!,title: "不具合",subtitle: "直接依頼のプロジェクトキャンセルのメールが他のユーザーに複数配信される"),
            MessageRow(image: UIImage(named: "bg_event")!,title: "不具合",subtitle: "直接依頼のプロジェクトキャンセルのメールが他のユーザーに複数配信される"),
        ];
    }
    
    
    
    
    
    
    //Section
    func tableView(tableView: UITableView, numberOfRowsInSection section:  Int) -> Int{
        return self.msgRow.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView .dequeueReusableCellWithIdentifier("cell_message", forIndexPath: indexPath) as MessageCell
        let datarow = self.msgRow[indexPath.row];
        cell.imageView?.image = datarow.image
        cell.titleLable.text = datarow.title;
        cell.subTitleLable.text = datarow.subtitle;
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    /*
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250;
    }
    */
}
//
//  AppInfoViewController.swift
//  spot
//
//  Created by 張志華 on 2015/03/25.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class AppInfoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var cellForHeight: AppHistoryCell!
    
    var histories = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SVProgressHUD.show()
        
        ParseController.getAppHistoryDone { (res, error) -> Void in
            
            if let res = res {
                self.histories = res
                self.tableView.reloadData()
            }
            
            SVProgressHUD.dismiss()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AppInfoViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return histories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCell", forIndexPath: indexPath) as AppHistoryCell
        cell.history = histories[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "アップデート履歴"
    }
    
    func calculateHeightForConfiguredSizingCell(cell: UITableViewCell) -> CGFloat {
        cell.bounds = CGRectMake(0,0,tableView.bounds.width,cell.bounds.height)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        let size = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize) as CGSize
        
        return size.height + 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if cellForHeight == nil {
            cellForHeight = self.tableView.dequeueReusableCellWithIdentifier("HistoryCell") as? AppHistoryCell
        }
        
        cellForHeight.history = histories[indexPath.row]
        
        return calculateHeightForConfiguredSizingCell(cellForHeight)
    }
}

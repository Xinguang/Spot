//
//  ContactViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/13.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var fsc: NSFetchedResultsController!
    
    var count: Int! {
        if let sectionInfo = fsc.sections?[0] as? NSFetchedResultsSectionInfo {
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fsc = Friend.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "createAt", ascending: false)
        fsc.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

// MARK: - NSFetchedResultsControllerDelegate

extension ContactViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate

extension ContactViewController: UITableViewDataSource, UITableViewDelegate {
    
    //    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    //        return 2
    //    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "友人"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let friend = fsc.objectAtIndexPath(indexPath) as Friend
        var cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = friend.accountName
                //                cell?.imageView?.image = UIImage(named: circleImageName)
        cell.detailTextLabel?.text = friend.displayName
        
            
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

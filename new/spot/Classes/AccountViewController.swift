//
//  AccountViewController.swift
//  spot
//
//  Created by 張志華 on 2015/02/06.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

//let circleImageName = "31-circle-plus-large"

class AccountViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var user :User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupVersionLabel()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reloadUI"), name: kXMPPDidReceivevCardTemp, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("reloadUI"), name: kXMPPDidReceiveAvata, object: nil)
    }
    
    func setupVersionLabel() {
        let label = UILabel(frame: CGRectZero)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor(hexString: "#666666")
        label.text = UIApplication.versionBuild()
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = .Center
        
        view.addSubview(label)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[label]-50-|", options: nil, metrics: nil, views: ["label" : label]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[label]|", options: nil, metrics: nil, views: ["label" : label]))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        user = User.MR_findFirst() as? User
                
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        setupVersionLabel()
    }
    // MARK: - Notification
    
    func reloadUI() {
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SegueAccountEdit" {
            let vc = segue.destinationViewController as AccountEditViewController
            vc.user = user
        }
    }
}

// MARK: - UITableViewDelegate

extension AccountViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user != nil ? 1 : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as UserCell
        cell.user = user
        
        return cell
    }

}

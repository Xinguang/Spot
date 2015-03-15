//
//  FriendListViewController.swift
//  spot
//
//  Created by 張志華 on 2015/03/10.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class UserListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var users = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as UITableViewCell
        
        let user = users[indexPath.row]
        let name = (user["displayName"] ?? user["username"]) as? String
        
        cell.textLabel?.text = name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let user = users[indexPath.row]
        
        let jidStr = user["openfireId"] as String
        let username = user["username"] as String
        
        Util.enterFriendDetailViewController(XMPPJID.jidWithString(jidStr), username: username, from: self, isTalking: false)
    }
}

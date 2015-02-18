//
//  FriendRequestCell.swift
//  spot
//
//  Created by 張志華 on 2015/02/18.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

@objc protocol FriendRequestCellDelegate {
    func friendRequestCellDidAcceptRequest(cell: FriendRequestCell) -> Void
}
    
class FriendRequestCell: UITableViewCell {

    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    
    weak var delegate: AnyObject!
    
    var friendRequest: FriendRequest! {
        didSet {
            self.accountNameLabel.text = friendRequest.jid
            self.displayNameLabel.text = friendRequest.displayName
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Action
    
    @IBAction func acceptRequest(sender: AnyObject) {
        delegate.friendRequestCellDidAcceptRequest(self)
    }
}

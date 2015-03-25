//
//  AppHistoryCell.swift
//  spot
//
//  Created by 張志華 on 2015/03/25.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class AppHistoryCell: UITableViewCell {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailLabel: MultilineLabel!
    
    var history: PFObject! {
        didSet {
            versionLabel.text = history["build"] as? String
            
            let date = history.createdAt
            let df = NSDateFormatter()
            df.locale = NSLocale(localeIdentifier: "en_US")
            df.dateFormat = "yyyy年MM月dd日"
            
            dateLabel.text = df.stringFromDate(date)
            
            detailLabel.text = history["text"] as? String
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

}

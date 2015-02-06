//
//  DataController.swift
//  spot
//
//  Created by 張志華 on 2015/02/04.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class DataController: NSObject {
    class var instance : DataController {
        struct Static {
            static let instance : DataController = DataController()
        }
        return Static.instance
    }
    
    func friends() -> [Friend] {
        return Friend.MR_findAll() as [Friend]
    }
}

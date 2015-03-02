//
//  MapDataConroller.swift
//  spot
//
//  Created by 張志華 on 2015/03/02.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class MapDataConroller: NSObject {
    class var instance : MapDataConroller {
        struct Static {
            static let instance : MapDataConroller = MapDataConroller()
        }
        return Static.instance
    }
    
    class func stationUsers() -> GPSModel {
        let path = NSBundle.mainBundle().pathForResource("gpx", ofType: "json")
        let str = NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
        
        return GPSModel(string: str, error: nil)
    }
}

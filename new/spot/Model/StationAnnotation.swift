//
//  UserAnnotation.swift
//  spot
//
//  Created by 張志華 on 2015/03/03.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class StationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    var pfObject: PFObject!
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
    init(model: PositionModel) {
        self.coordinate = CLLocationCoordinate2D(latitude: model.lat, longitude: model.lon)
        self.title = "title"
        self.subtitle = "subtitle"
    }
    
    init(obj: PFObject) {
        pfObject = obj
        
        self.coordinate = CLLocationCoordinate2D(latitude: (obj["lat"] as String).toDouble()!, longitude: (obj["lon"] as String).toDouble()!)
        self.title = obj["name"] as String
        self.subtitle = ""
//        let count = obj["count"] as Int
        
//        self.subtitle = "\(count)人"
    }
}

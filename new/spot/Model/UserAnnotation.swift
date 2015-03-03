//
//  UserAnnotation.swift
//  spot
//
//  Created by 張志華 on 2015/03/03.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

import UIKit

class UserAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    
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
}

//
//  MapPoint.swift
//  spot
//
//  Created by Hikaru on 2014/12/01.
//  Copyright (c) 2014年 Hikaru. All rights reserved.
//

import MapKit

class MapPoint:NSObject,MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }

}
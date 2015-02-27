//
//  ParseStationModel.swift
//  spot
//
//  Created by Hikaru on 2015/02/17.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

class ParseStationModel :ParseModel{
    
    // MARK: - Properties
    var name: String = ""
    var lat: String = ""
    var lon: String = ""
    override init(){
        
    }
    convenience init(
        name: String
        , lat:String
        , lon:String
        ){
            self.init()
            self.name = name
            self.lat = lat
            self.lon = lon
    }
    
//    override func toPFObject()->PFObject{
//        var pfObject = super.toPFObject()
//        
//        self.setPFObject(pfObject,key: "name",object: self.name)
//        self.setPFObject(pfObject,key: "lat",object: self.lat)
//        self.setPFObject(pfObject,key: "lon",object: self.lon)
//        return pfObject
//    }
}
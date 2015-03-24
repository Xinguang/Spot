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
    var add: String = ""
    var line: String = ""
    var post: String = ""
    override init(){
        
    }
    convenience init(
        name: String
        , lat:String
        , lon:String
        , add:String
        , line:String
        , post:String
        ){
            self.init()
            self.name = name
            self.lat = lat
            self.lon = lon
            self.add = add
            self.line = line
            self.post = post
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
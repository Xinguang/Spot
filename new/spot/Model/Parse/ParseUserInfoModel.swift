//
//  ParseUserInfoModel.swift
//  spot
//
//  Created by Hikaru on 2015/02/17.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

class ParseUserInfoModel :ParseModel{
    
    // MARK: - Properties
    var nickname: String = ""
    var figure: String = ""
    var stations: [ParseStationModel] = []
    var sex: String = ""
    var birthday: String = ""
    var tags: [ParseTagModel] = []
    var openids: [ParseSNSModel] = []
    var devices: [ParseDeviceModel] = []
    override init(){
        
    }
    convenience init(
        nickname: String
        , figure: String
        , stations: [ParseStationModel]
        , sex: String
        , birthday: String
        , tags: [ParseTagModel]
        , openids: [ParseSNSModel]
        , devices: [ParseDeviceModel]){
            self.init()
            self.nickname = nickname
            self.figure = figure
            self.stations = stations
            self.sex = sex
            
            self.birthday = birthday
            self.tags = tags
            self.openids = openids
            self.devices = devices
    }
    
//    override func toPFObject()->PFObject{
//        var pfObject = super.toPFObject()
//        
//        self.setPFObject(pfObject,key: "nickname",object: self.nickname)
//        self.setPFObject(pfObject,key: "figure",object: self.figure)
//        self.setPFObject(pfObject,key: "stations",object: self.stations)
//        self.setPFObject(pfObject,key: "sex",object: self.sex)
//        self.setPFObject(pfObject,key: "birthday",object: self.birthday)
//        self.setPFObject(pfObject,key: "tags",object: self.tags)
//        self.setPFObject(pfObject,key: "openids",object: self.openids)
//        self.setPFObject(pfObject,key: "devices",object: self.devices)
//        
//        return pfObject
//    }
    
}
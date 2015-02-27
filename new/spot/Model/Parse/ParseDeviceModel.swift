//
//  ParseDeviceModel.swift
//  spot
//
//  Created by Hikaru on 2015/02/17.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

class ParseDeviceModel :ParseModel{
    
    // MARK: - Properties
    var uuid: String = ""
    var name: String = ""
    var model: String = ""
    override init(){
        
    }
    convenience init(
        uuid: String
        , name:String
        , model:String
        ){
            self.init()
            self.uuid = uuid
            self.name = name
            self.model = model
    }
    
//    override func toPFObject()->PFObject{
//        var pfObject = super.toPFObject()
//        
//        self.setPFObject(pfObject,key: "uuid",object: self.uuid)
//        self.setPFObject(pfObject,key: "name",object: self.name)
//        self.setPFObject(pfObject,key: "model",object: self.model)
//        
//        return pfObject
//    }
}

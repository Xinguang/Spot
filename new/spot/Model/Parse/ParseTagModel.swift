//
//  ParseTagModel.swift
//  spot
//
//  Created by Hikaru on 2015/02/17.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

class ParseTagModel :ParseModel{
    
    // MARK: - Properties
    var name: String = ""
    var creator: ParseUserModel = ParseUserModel()
    override init(){
        
    }
    convenience init(
        name: String
        , creator:ParseUserModel
        ){
            self.init()
            self.name = name
            self.creator = creator
    }
    
//    override func toPFObject()->PFObject{
//        var pfObject = super.toPFObject()
//        
//        self.setPFObject(pfObject,key: "name",object: self.name)
//        self.setPFObject(pfObject,key: "creator",object: self.creator)
//        return pfObject
//    }
}
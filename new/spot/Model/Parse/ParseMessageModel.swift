//
//  ParseMessageModel.swift
//  spot
//
//  Created by Hikaru on 2015/02/17.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

class ParseMessageModel :ParseModel{
    
    // MARK: - Properties
    var from: ParseUserModel = ParseUserModel()
    var to: ParseUserModel = ParseUserModel()
    var message: String = ""
    override init(){
        
    }
    convenience init(
        from: ParseUserModel
        , to:ParseUserModel
        , message:String
        ){
            self.init()
            self.from = from
            self.to = to
            self.message = message
    }
    
//    override func toPFObject()->PFObject{
//        var pfObject = super.toPFObject()
//        
//        self.setPFObject(pfObject,key: "from",object: self.from)
//        self.setPFObject(pfObject,key: "to",object: self.to)
//        self.setPFObject(pfObject,key: "message",object: self.message)
//        
//        return pfObject
//    }
}
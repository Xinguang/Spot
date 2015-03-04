//
//  ParseModel.swift
//  spot
//
//  Created by Hikaru on 2015/02/17.
//  Copyright (c) 2015年 e-business. All rights reserved.
//

class ParseModel :NSObject{
    private var query:PFQuery?
    
    // MARK: - Properties
    var objectId: String?
    var createAt:String?
    var updatedAt:String?
    var ACL:String?
    override init(){
    }
    convenience init(
        objectId: String?
        , createAt:String?
        , updatedAt:String?
    , ACL:String?){
            self.init()
            self.objectId = objectId
            self.createAt = createAt
            self.updatedAt = updatedAt
            self.ACL = ACL
        
    }
    
    convenience init(pfObject:PFObject){
        self.init()
        
        var aClass : AnyClass? = self.dynamicType
        
        var propertiesCount : CUnsignedInt = 0
        let propertiesInAClass : UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(aClass, &propertiesCount)
        
        for var i = 0; i < Int(propertiesCount); i++ {
            
            if let key = NSString(CString: property_getName(propertiesInAClass[i]), encoding: NSUTF8StringEncoding) {
                var val: AnyObject? = pfObject[key]
                
                if let str = val as? String{
                    self.setValue(str, forKey: key)
                }else if let pf = val as? PFRelation{
                    
                    if let objects = pf.query().findObjects() {
                        var arr:[AnyObject] = []
                        for o in objects {
                            if let pf = o as? PFObject{
                                let c = self.getModel(pf.parseClassName,pfObject: pf)
                                arr.append(c)
                            }
                        }
                        self.setValue(arr, forKey: key)
                    }
                }
            }
        }
    }
    
    func getModel(classname:String,pfObject:PFObject)->ParseModel{
        switch classname{
        case"User":
            return ParseUserModel(pfObject:pfObject)
        case"Device":
            return ParseDeviceModel(pfObject:pfObject)
        case"Message":
            return ParseMessageModel(pfObject:pfObject)
        case"SNS":
            return ParseSNSModel(pfObject:pfObject)
        case"Station":
            return ParseStationModel(pfObject:pfObject)
        case"Tag":
            return ParseTagModel(pfObject:pfObject)
        case"UserInfo":
            return ParseUserInfoModel(pfObject:pfObject)
        default:
            return ParseModel(pfObject:pfObject)
        }
    }
    
    func getClassName()->String{
        if let classname = NSString(UTF8String: class_getName(self.dynamicType)) as? String{
            return classname.replace("^spot.Parse(.*)Model$",template: "$1");
        }
        return ""
    }
}
/*
class PFQueryEx<T:ParseModel>:PFQuery{
    override init(){
        super.init()
    }
    
    func getClassName()->String{
        let reflector = ReflectorUtils<T>()
        return reflector.name.replace("^spot.Parse(.*)Model$",template: "$1");
    }
}
*/
extension ParseModel {
    func getQuery() -> PFQuery {
        if let q = self.query {
            return q
        }else{
            let q = PFQuery(className: self.getClassName())
            self.query = q
            return q
        }
    }
    
    func getFirst<T:ParseModel>()->T?{
        if let obj = self.getQuery().getFirstObject() {
            return T(pfObject: obj)
        }
        return nil
    }
    func getObjectWithId<T:ParseModel>(objectId:String)->T?{
        if let obj = self.getQuery().getObjectWithId(objectId) {
            return T(pfObject: obj)
        }
        return nil
    }
    
    func getFirst<T:ParseModel>(cls:T.Type,complete:(result: T?, error: NSError?)->()){
        let q = self.getQuery()
        q.getFirstObjectInBackgroundWithBlock { (obj, error) -> Void in
            if let error = error {
                complete(result: nil, error: error)
                return
            }
            
            complete(result: T(pfObject: obj), error: nil)
        }
    }
    
    func find<T:ParseModel>(cls:T.Type,complete:(result: [T]?)->()){
        let q = self.getQuery()
        q.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let arr = objects {
                if objects.count > 0 {
                    var res :[T] = []
                    for object in objects{
                        if let o = object as? PFObject{
                            res.append(T(pfObject: o))
                        }
                    }
                    complete(result: res)
                }
            }
            complete(result: nil)
        }
    }
    
    func find<T:ParseModel>(fix:T?)->[T]?{
        if let arr = self.getQuery().findObjects() {
            var res :[T] = []
            for object in arr{
                if let o = object as? PFObject{
                    res.append(T(pfObject: o))
                }
            }
            return res
        }
        return nil
    }
}
extension ParseModel {
    func toPFObject() -> PFObject {
        
        var pfObject:PFObject
        if nil == self.objectId{
            pfObject = PFObject(className:self.getClassName())
        }else{
            pfObject = PFObject(withoutDataWithClassName:self.getClassName(),objectId: self.objectId)
        }
        
        
        var aClass : AnyClass? = self.dynamicType
        
        var propertiesCount : CUnsignedInt = 0
        let propertiesInAClass : UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(aClass, &propertiesCount)
        
        for var i = 0; i < Int(propertiesCount); i++ {
            
            if let key = NSString(CString: property_getName(propertiesInAClass[i]), encoding: NSUTF8StringEncoding) {
                var val: AnyObject? = self.valueForKey(key)
                
                if let str = val as? String{
                    pfObject[key] = str
                }else if let pm = val as? ParseModel{
                    var relation = pfObject.relationForKey(key)
                    self.saveRelationObject(pm,relation:relation)
                }else if let arr = val as? [ParseModel]{
                    if arr.count > 0 {
                        var relation = pfObject.relationForKey(key)
                        relation.removeAll()
                        for o in arr {
                            self.saveRelationObject(o,relation:relation)
                        }
                    }
                }
            }
        }
        return pfObject
    }
    ////////////////
    private func saveRelationObject(pm:ParseModel,relation:PFRelation){
        let pf = pm.toPFObject()
        //if nil == pf.objectId{//关系表 不直接更新 只有不存在时保存
            pf.save()
        //}
        relation.addObject(pf)
    }
}
extension PFRelation{
    
    func removeAll(){
        let q = self.query()
        if let arr = q.findObjects() {
            for obj in arr {
                if let pf = obj as? PFObject{
                    self.removeObject(pf)
                }
            }
        }
    }
    func removeObjectByKey(objectDds:[String]){
        let q = self.query()
        q.whereKey("objectId", containedIn: objectDds)
        if let arr = q.findObjects() {
            for obj in arr {
                if let pf = obj as? PFObject{
                    self.removeObject(pf)
                }
            }
        }

    }
}


//extension ParseModel {
//    func toPFObject()->PFObject{
//        var pfObject:PFObject
//        if nil == self.objectId{
//            pfObject = PFObject(className:self.getClassName())
//        }else{
//            pfObject = PFObject(withoutDataWithClassName:self.getClassName(),objectId: self.objectId)
//        }
//        /*
//        pfObject["createAt"] = self.createAt
//        pfObject["updatedAt"] = self.updatedAt
//        pfObject["ACL"] = self.ACL
//        */
//        return pfObject
//    }
//
//
//    func setPFObject(pfObject:PFObject,key:String,object:AnyObject){
//        if let str = object as? String{
//            pfObject[key] = str
//        }else if let pm = object as? ParseModel{
//            var relation = pfObject.relationForKey(key)
//            relation.addObject(pm.toPFObject())
//        }else if let arr = object as? [ParseModel]{
//            var relation = pfObject.relationForKey(key)
//            for o in arr {
//                relation.addObject(o.toPFObject())
//            }
//        }
//    }
//
//}




//extension ParseModel {
//    func toDictionary() -> Dictionary<String,AnyObject> {
//        
//        var aClass : AnyClass? = self.dynamicType
//        
//        var propertiesCount : CUnsignedInt = 0
//        let propertiesInAClass : UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(aClass, &propertiesCount)
//        
//        var dict : Dictionary<String,AnyObject> = [:]
//        
//        for var i = 0; i < Int(propertiesCount); i++ {
//            
//            if let key = NSString(CString: property_getName(propertiesInAClass[i]), encoding: NSUTF8StringEncoding) {
//                var val: AnyObject? = self.valueForKey(key)
//                if let v = val as? String{
//                    dict[key] = v
//                }else if let arr = val as? [ParseModel] {
//                    var cdict:[AnyObject] = []
//                    for o in arr {
//                        cdict.append(o.toDictionary())
//                    }
//                    dict[key] = cdict
//                }
//            }
//            
//        }
//        return dict
//    }
//    func initWithDictionary(dict:Dictionary<String,AnyObject>){
//        let structMirror = reflect(self)
//        let numChildren = structMirror.count
//        println("child count:\(numChildren)")
//        for index in 0..<numChildren{
//            let (propertyName, propertyMirror) = structMirror[index]
//            println("name: \(propertyName) value: \(propertyMirror.value)")
//            println(propertyMirror)
//        }
//        
//        
//        
//        
//        
//        var aClass : AnyClass? = self.dynamicType
//        
//        var propertiesCount : CUnsignedInt = 0
//        let propertiesInAClass : UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(aClass, &propertiesCount)
//        
//        for var i = 0; i < Int(propertiesCount); i++ {
//            
//            if let key = NSString(CString: property_getName(propertiesInAClass[i]), encoding: NSUTF8StringEncoding) {
//                if let val:AnyObject = dict[key] {
//                    if let v = val as? String {
//                        self.setValue(v, forKey: key)
//                    }else if let arr = val as? NSArray {
//                        println(arr)
//                    }
//                }
//            }
//        }
//    }
//    
//    func toDictionary1()->Dictionary<String,AnyObject> {
//        
//        /*
//        let aPerson = Person(name:"Sally", age:35, height:5.9)
//        let structMirror = reflect(aPerson)
//        let numChildren = structMirror.count
//        println("child count:\(numChildren)")
//        for index in 0..<numChildren{
//        let (propertyName, propertyMirror) = structMirror[index]
//        println("name: \(propertyName) value: \(propertyMirror.value)")
//        }
//        */
//        let mirror = reflect(self)
//        
//        var dict:Dictionary<String,AnyObject> = [:]
//        
//        let numChildren = mirror.count
//        println("child count:\(numChildren)")
//        for index in 0..<numChildren{
//            let (propertyName, propertyMirror) = mirror[index]
//            
//            if let val = propertyMirror.value as? NSString {
//                dict[propertyName] = val
//                //println("name: \(propertyName) value: \(val) type: \(propertyMirror.summary)")
//                //self.setValue(val, forKey: propertyName)
//            }else if let arr = propertyMirror.value as? NSArray {
//                var cdict:[AnyObject] = []
//                for obj in arr {
//                    if let o = obj as? ParseModel{
//                        cdict.append(o.toDictionary())
//                    }
//                }
//                dict[propertyName] = cdict
//                //println("name: \(propertyName) value: \(propertyMirror.value) type: \(propertyMirror.summary)")
//            }else{
//                println("name: \(propertyName) value: \(propertyMirror.value) type: \(propertyMirror.summary)")
//                dict[propertyName] = ""
//            }
//        }
//        return dict;
//    }
//}
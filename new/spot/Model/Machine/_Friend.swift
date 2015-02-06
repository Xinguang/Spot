// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Friend.swift instead.

import CoreData

enum FriendAttributes: String {
    case nickName = "nickName"
    case usrName = "usrName"
}

@objc
class _Friend: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "Friend"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _Friend.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var nickName: String?

    // func validateNickName(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var usrName: String?

    // func validateUsrName(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

}


// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FriendRequest.swift instead.

import CoreData

enum FriendRequestAttributes: String {
    case createAt = "createAt"
    case displayName = "displayName"
    case jid = "jid"
}

@objc
class _FriendRequest: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "FriendRequest"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _FriendRequest.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var createAt: NSDate?

    // func validateCreateAt(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var displayName: String?

    // func validateDisplayName(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var jid: String?

    // func validateJid(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

}


// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.swift instead.

import CoreData

enum UserAttributes: String {
    case age = "age"
    case birthday = "birthday"
    case displayName = "displayName"
    case nickName = "nickName"
    case uniqueIdentifier = "uniqueIdentifier"
    case username = "username"
}

enum UserRelationships: String {
    case friends = "friends"
}

@objc
class _User: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "User"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _User.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var age: NSNumber?

    // func validateAge(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var birthday: NSDate?

    // func validateBirthday(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var displayName: String?

    // func validateDisplayName(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var nickName: String?

    // func validateNickName(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var uniqueIdentifier: String?

    // func validateUniqueIdentifier(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var username: String?

    // func validateUsername(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var friends: NSOrderedSet

}

extension _User {

    func addFriends(objects: NSOrderedSet) {
        let mutable = self.friends.mutableCopy() as NSMutableOrderedSet
        mutable.unionOrderedSet(objects)
        self.friends = mutable.copy() as NSOrderedSet
    }

    func removeFriends(objects: NSOrderedSet) {
        let mutable = self.friends.mutableCopy() as NSMutableOrderedSet
        mutable.minusOrderedSet(objects)
        self.friends = mutable.copy() as NSOrderedSet
    }

    func addFriendsObject(value: Friend!) {
        let mutable = self.friends.mutableCopy() as NSMutableOrderedSet
        mutable.addObject(value)
        self.friends = mutable.copy() as NSOrderedSet
    }

    func removeFriendsObject(value: Friend!) {
        let mutable = self.friends.mutableCopy() as NSMutableOrderedSet
        mutable.removeObject(value)
        self.friends = mutable.copy() as NSOrderedSet
    }

}

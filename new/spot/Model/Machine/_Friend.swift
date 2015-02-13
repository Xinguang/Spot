// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Friend.swift instead.

import CoreData

enum FriendAttributes: String {
    case accountName = "accountName"
    case chatState = "chatState"
    case composingMessageString = "composingMessageString"
    case currentStatus = "currentStatus"
    case displayName = "displayName"
    case lastMessageDate = "lastMessageDate"
    case lastMessageDisconnected = "lastMessageDisconnected"
    case lastSentChatState = "lastSentChatState"
    case pendingApproval = "pendingApproval"
    case photo = "photo"
}

enum FriendRelationships: String {
    case user = "user"
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
    var accountName: String?

    // func validateAccountName(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var chatState: NSNumber?

    // func validateChatState(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var composingMessageString: String?

    // func validateComposingMessageString(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var currentStatus: NSNumber?

    // func validateCurrentStatus(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var displayName: String?

    // func validateDisplayName(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var lastMessageDate: NSDate?

    // func validateLastMessageDate(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var lastMessageDisconnected: NSNumber?

    // func validateLastMessageDisconnected(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var lastSentChatState: NSNumber?

    // func validateLastSentChatState(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var pendingApproval: NSNumber?

    // func validatePendingApproval(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var photo: AnyObject?

    // func validatePhoto(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var user: User?

    // func validateUser(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

}


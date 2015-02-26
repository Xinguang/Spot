// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Friend.h instead.

#import <CoreData/CoreData.h>

extern const struct FriendAttributes {
	__unsafe_unretained NSString *jidStr;
	__unsafe_unretained NSString *unreadMessages;
} FriendAttributes;

@interface FriendID : NSManagedObjectID {}
@end

@interface _Friend : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FriendID* objectID;

@property (nonatomic, strong) NSString* jidStr;

//- (BOOL)validateJidStr:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* unreadMessages;

@property (atomic) int32_t unreadMessagesValue;
- (int32_t)unreadMessagesValue;
- (void)setUnreadMessagesValue:(int32_t)value_;

//- (BOOL)validateUnreadMessages:(id*)value_ error:(NSError**)error_;

@end

@interface _Friend (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveJidStr;
- (void)setPrimitiveJidStr:(NSString*)value;

- (NSNumber*)primitiveUnreadMessages;
- (void)setPrimitiveUnreadMessages:(NSNumber*)value;

- (int32_t)primitiveUnreadMessagesValue;
- (void)setPrimitiveUnreadMessagesValue:(int32_t)value_;

@end

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FriendRequest.h instead.

#import <CoreData/CoreData.h>

extern const struct FriendRequestAttributes {
	__unsafe_unretained NSString *createAt;
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *jid;
} FriendRequestAttributes;

@interface FriendRequestID : NSManagedObjectID {}
@end

@interface _FriendRequest : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FriendRequestID* objectID;

@property (nonatomic, strong) NSDate* createAt;

//- (BOOL)validateCreateAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* displayName;

//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* jid;

//- (BOOL)validateJid:(id*)value_ error:(NSError**)error_;

@end

@interface _FriendRequest (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreateAt;
- (void)setPrimitiveCreateAt:(NSDate*)value;

- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;

- (NSString*)primitiveJid;
- (void)setPrimitiveJid:(NSString*)value;

@end

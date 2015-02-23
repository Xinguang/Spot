// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

#import <CoreData/CoreData.h>

extern const struct UserAttributes {
	__unsafe_unretained NSString *age;
	__unsafe_unretained NSString *avatarData;
	__unsafe_unretained NSString *birthday;
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *nickName;
	__unsafe_unretained NSString *uniqueIdentifier;
	__unsafe_unretained NSString *username;
} UserAttributes;

extern const struct UserRelationships {
	__unsafe_unretained NSString *friends;
} UserRelationships;

@class Friend;

@interface UserID : NSManagedObjectID {}
@end

@interface _User : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) UserID* objectID;

@property (nonatomic, strong) NSNumber* age;

@property (atomic) int32_t ageValue;
- (int32_t)ageValue;
- (void)setAgeValue:(int32_t)value_;

//- (BOOL)validateAge:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSData* avatarData;

//- (BOOL)validateAvatarData:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* birthday;

//- (BOOL)validateBirthday:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* displayName;

//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* nickName;

//- (BOOL)validateNickName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* uniqueIdentifier;

//- (BOOL)validateUniqueIdentifier:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* username;

//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSOrderedSet *friends;

- (NSMutableOrderedSet*)friendsSet;

@end

@interface _User (FriendsCoreDataGeneratedAccessors)
- (void)addFriends:(NSOrderedSet*)value_;
- (void)removeFriends:(NSOrderedSet*)value_;
- (void)addFriendsObject:(Friend*)value_;
- (void)removeFriendsObject:(Friend*)value_;

- (void)insertObject:(Friend*)value inFriendsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFriendsAtIndex:(NSUInteger)idx;
- (void)insertFriends:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFriendsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFriendsAtIndex:(NSUInteger)idx withObject:(Friend*)value;
- (void)replaceFriendsAtIndexes:(NSIndexSet *)indexes withFriends:(NSArray *)values;

@end

@interface _User (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveAge;
- (void)setPrimitiveAge:(NSNumber*)value;

- (int32_t)primitiveAgeValue;
- (void)setPrimitiveAgeValue:(int32_t)value_;

- (NSData*)primitiveAvatarData;
- (void)setPrimitiveAvatarData:(NSData*)value;

- (NSDate*)primitiveBirthday;
- (void)setPrimitiveBirthday:(NSDate*)value;

- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;

- (NSString*)primitiveNickName;
- (void)setPrimitiveNickName:(NSString*)value;

- (NSString*)primitiveUniqueIdentifier;
- (void)setPrimitiveUniqueIdentifier:(NSString*)value;

- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;

- (NSMutableOrderedSet*)primitiveFriends;
- (void)setPrimitiveFriends:(NSMutableOrderedSet*)value;

@end

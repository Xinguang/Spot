// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

#import <CoreData/CoreData.h>

extern const struct UserAttributes {
	__unsafe_unretained NSString *age;
	__unsafe_unretained NSString *avatarOrg;
	__unsafe_unretained NSString *avatarThumbnail;
	__unsafe_unretained NSString *birthday;
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *gender;
	__unsafe_unretained NSString *openfireId;
	__unsafe_unretained NSString *username;
} UserAttributes;

extern const struct UserRelationships {
	__unsafe_unretained NSString *snses;
	__unsafe_unretained NSString *stations;
} UserRelationships;

@class SNS;
@class Station;

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

@property (nonatomic, strong) NSData* avatarOrg;

//- (BOOL)validateAvatarOrg:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSData* avatarThumbnail;

//- (BOOL)validateAvatarThumbnail:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* birthday;

//- (BOOL)validateBirthday:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* displayName;

//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* gender;

//- (BOOL)validateGender:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* openfireId;

//- (BOOL)validateOpenfireId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* username;

//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSOrderedSet *snses;

- (NSMutableOrderedSet*)snsesSet;

@property (nonatomic, strong) NSOrderedSet *stations;

- (NSMutableOrderedSet*)stationsSet;

@end

@interface _User (SnsesCoreDataGeneratedAccessors)
- (void)addSnses:(NSOrderedSet*)value_;
- (void)removeSnses:(NSOrderedSet*)value_;
- (void)addSnsesObject:(SNS*)value_;
- (void)removeSnsesObject:(SNS*)value_;

- (void)insertObject:(SNS*)value inSnsesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSnsesAtIndex:(NSUInteger)idx;
- (void)insertSnses:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSnsesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSnsesAtIndex:(NSUInteger)idx withObject:(SNS*)value;
- (void)replaceSnsesAtIndexes:(NSIndexSet *)indexes withSnses:(NSArray *)values;

@end

@interface _User (StationsCoreDataGeneratedAccessors)
- (void)addStations:(NSOrderedSet*)value_;
- (void)removeStations:(NSOrderedSet*)value_;
- (void)addStationsObject:(Station*)value_;
- (void)removeStationsObject:(Station*)value_;

- (void)insertObject:(Station*)value inStationsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromStationsAtIndex:(NSUInteger)idx;
- (void)insertStations:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeStationsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInStationsAtIndex:(NSUInteger)idx withObject:(Station*)value;
- (void)replaceStationsAtIndexes:(NSIndexSet *)indexes withStations:(NSArray *)values;

@end

@interface _User (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveAge;
- (void)setPrimitiveAge:(NSNumber*)value;

- (int32_t)primitiveAgeValue;
- (void)setPrimitiveAgeValue:(int32_t)value_;

- (NSData*)primitiveAvatarOrg;
- (void)setPrimitiveAvatarOrg:(NSData*)value;

- (NSData*)primitiveAvatarThumbnail;
- (void)setPrimitiveAvatarThumbnail:(NSData*)value;

- (NSDate*)primitiveBirthday;
- (void)setPrimitiveBirthday:(NSDate*)value;

- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;

- (NSString*)primitiveGender;
- (void)setPrimitiveGender:(NSString*)value;

- (NSString*)primitiveOpenfireId;
- (void)setPrimitiveOpenfireId:(NSString*)value;

- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;

- (NSMutableOrderedSet*)primitiveSnses;
- (void)setPrimitiveSnses:(NSMutableOrderedSet*)value;

- (NSMutableOrderedSet*)primitiveStations;
- (void)setPrimitiveStations:(NSMutableOrderedSet*)value;

@end

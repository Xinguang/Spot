// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Station.h instead.

#import <CoreData/CoreData.h>

extern const struct StationAttributes {
	__unsafe_unretained NSString *name;
} StationAttributes;

extern const struct StationRelationships {
	__unsafe_unretained NSString *user;
} StationRelationships;

@class User;

@interface StationID : NSManagedObjectID {}
@end

@interface _Station : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) StationID* objectID;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _Station (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;

@end

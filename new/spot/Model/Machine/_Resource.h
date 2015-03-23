// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Resource.h instead.

#import <CoreData/CoreData.h>

extern const struct ResourceAttributes {
	__unsafe_unretained NSString *data;
	__unsafe_unretained NSString *path;
} ResourceAttributes;

@interface ResourceID : NSManagedObjectID {}
@end

@interface _Resource : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ResourceID* objectID;

@property (nonatomic, strong) NSData* data;

//- (BOOL)validateData:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* path;

//- (BOOL)validatePath:(id*)value_ error:(NSError**)error_;

@end

@interface _Resource (CoreDataGeneratedPrimitiveAccessors)

- (NSData*)primitiveData;
- (void)setPrimitiveData:(NSData*)value;

- (NSString*)primitivePath;
- (void)setPrimitivePath:(NSString*)value;

@end

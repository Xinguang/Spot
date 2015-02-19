// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SNS.h instead.

#import <CoreData/CoreData.h>

extern const struct SNSAttributes {
	__unsafe_unretained NSString *access_token;
	__unsafe_unretained NSString *expirationDate;
	__unsafe_unretained NSString *openid;
	__unsafe_unretained NSString *refresh_token;
	__unsafe_unretained NSString *type;
} SNSAttributes;

@interface SNSID : NSManagedObjectID {}
@end

@interface _SNS : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SNSID* objectID;

@property (nonatomic, strong) NSString* access_token;

//- (BOOL)validateAccess_token:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* expirationDate;

//- (BOOL)validateExpirationDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* openid;

//- (BOOL)validateOpenid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* refresh_token;

//- (BOOL)validateRefresh_token:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;

@end

@interface _SNS (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAccess_token;
- (void)setPrimitiveAccess_token:(NSString*)value;

- (NSDate*)primitiveExpirationDate;
- (void)setPrimitiveExpirationDate:(NSDate*)value;

- (NSString*)primitiveOpenid;
- (void)setPrimitiveOpenid:(NSString*)value;

- (NSString*)primitiveRefresh_token;
- (void)setPrimitiveRefresh_token:(NSString*)value;

@end
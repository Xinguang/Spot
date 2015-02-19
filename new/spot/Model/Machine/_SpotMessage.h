// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SpotMessage.h instead.

#import <CoreData/CoreData.h>

extern const struct SpotMessageAttributes {
	__unsafe_unretained NSString *createAt;
	__unsafe_unretained NSString *delivered;
	__unsafe_unretained NSString *incoming;
	__unsafe_unretained NSString *messageId;
	__unsafe_unretained NSString *read;
	__unsafe_unretained NSString *text;
} SpotMessageAttributes;

extern const struct SpotMessageRelationships {
	__unsafe_unretained NSString *friend;
} SpotMessageRelationships;

@class Friend;

@interface SpotMessageID : NSManagedObjectID {}
@end

@interface _SpotMessage : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SpotMessageID* objectID;

@property (nonatomic, strong) NSDate* createAt;

//- (BOOL)validateCreateAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* delivered;

@property (atomic) BOOL deliveredValue;
- (BOOL)deliveredValue;
- (void)setDeliveredValue:(BOOL)value_;

//- (BOOL)validateDelivered:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* incoming;

@property (atomic) BOOL incomingValue;
- (BOOL)incomingValue;
- (void)setIncomingValue:(BOOL)value_;

//- (BOOL)validateIncoming:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* messageId;

//- (BOOL)validateMessageId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* read;

@property (atomic) BOOL readValue;
- (BOOL)readValue;
- (void)setReadValue:(BOOL)value_;

//- (BOOL)validateRead:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Friend *friend;

//- (BOOL)validateFriend:(id*)value_ error:(NSError**)error_;

@end

@interface _SpotMessage (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreateAt;
- (void)setPrimitiveCreateAt:(NSDate*)value;

- (NSNumber*)primitiveDelivered;
- (void)setPrimitiveDelivered:(NSNumber*)value;

- (BOOL)primitiveDeliveredValue;
- (void)setPrimitiveDeliveredValue:(BOOL)value_;

- (NSNumber*)primitiveIncoming;
- (void)setPrimitiveIncoming:(NSNumber*)value;

- (BOOL)primitiveIncomingValue;
- (void)setPrimitiveIncomingValue:(BOOL)value_;

- (NSString*)primitiveMessageId;
- (void)setPrimitiveMessageId:(NSString*)value;

- (NSNumber*)primitiveRead;
- (void)setPrimitiveRead:(NSNumber*)value;

- (BOOL)primitiveReadValue;
- (void)setPrimitiveReadValue:(BOOL)value_;

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (Friend*)primitiveFriend;
- (void)setPrimitiveFriend:(Friend*)value;

@end

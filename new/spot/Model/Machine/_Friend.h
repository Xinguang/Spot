// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Friend.h instead.

#import <CoreData/CoreData.h>

extern const struct FriendAttributes {
	__unsafe_unretained NSString *accountName;
	__unsafe_unretained NSString *chatState;
	__unsafe_unretained NSString *composingMessageString;
	__unsafe_unretained NSString *createAt;
	__unsafe_unretained NSString *currentStatus;
	__unsafe_unretained NSString *displayName;
	__unsafe_unretained NSString *lastMessageDate;
	__unsafe_unretained NSString *lastMessageDisconnected;
	__unsafe_unretained NSString *lastSentChatState;
	__unsafe_unretained NSString *pendingApproval;
	__unsafe_unretained NSString *photo;
} FriendAttributes;

extern const struct FriendRelationships {
	__unsafe_unretained NSString *messages;
	__unsafe_unretained NSString *user;
} FriendRelationships;

@class SpotMessage;
@class User;

@class NSObject;

@interface FriendID : NSManagedObjectID {}
@end

@interface _Friend : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FriendID* objectID;

@property (nonatomic, strong) NSString* accountName;

//- (BOOL)validateAccountName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* chatState;

@property (atomic) int16_t chatStateValue;
- (int16_t)chatStateValue;
- (void)setChatStateValue:(int16_t)value_;

//- (BOOL)validateChatState:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* composingMessageString;

//- (BOOL)validateComposingMessageString:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* createAt;

//- (BOOL)validateCreateAt:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* currentStatus;

@property (atomic) int16_t currentStatusValue;
- (int16_t)currentStatusValue;
- (void)setCurrentStatusValue:(int16_t)value_;

//- (BOOL)validateCurrentStatus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* displayName;

//- (BOOL)validateDisplayName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* lastMessageDate;

//- (BOOL)validateLastMessageDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* lastMessageDisconnected;

@property (atomic) BOOL lastMessageDisconnectedValue;
- (BOOL)lastMessageDisconnectedValue;
- (void)setLastMessageDisconnectedValue:(BOOL)value_;

//- (BOOL)validateLastMessageDisconnected:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* lastSentChatState;

@property (atomic) int16_t lastSentChatStateValue;
- (int16_t)lastSentChatStateValue;
- (void)setLastSentChatStateValue:(int16_t)value_;

//- (BOOL)validateLastSentChatState:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* pendingApproval;

@property (atomic) BOOL pendingApprovalValue;
- (BOOL)pendingApprovalValue;
- (void)setPendingApprovalValue:(BOOL)value_;

//- (BOOL)validatePendingApproval:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) id photo;

//- (BOOL)validatePhoto:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSOrderedSet *messages;

- (NSMutableOrderedSet*)messagesSet;

@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _Friend (MessagesCoreDataGeneratedAccessors)
- (void)addMessages:(NSOrderedSet*)value_;
- (void)removeMessages:(NSOrderedSet*)value_;
- (void)addMessagesObject:(SpotMessage*)value_;
- (void)removeMessagesObject:(SpotMessage*)value_;

- (void)insertObject:(SpotMessage*)value inMessagesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMessagesAtIndex:(NSUInteger)idx;
- (void)insertMessages:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMessagesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMessagesAtIndex:(NSUInteger)idx withObject:(SpotMessage*)value;
- (void)replaceMessagesAtIndexes:(NSIndexSet *)indexes withMessages:(NSArray *)values;

@end

@interface _Friend (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAccountName;
- (void)setPrimitiveAccountName:(NSString*)value;

- (NSNumber*)primitiveChatState;
- (void)setPrimitiveChatState:(NSNumber*)value;

- (int16_t)primitiveChatStateValue;
- (void)setPrimitiveChatStateValue:(int16_t)value_;

- (NSString*)primitiveComposingMessageString;
- (void)setPrimitiveComposingMessageString:(NSString*)value;

- (NSDate*)primitiveCreateAt;
- (void)setPrimitiveCreateAt:(NSDate*)value;

- (NSNumber*)primitiveCurrentStatus;
- (void)setPrimitiveCurrentStatus:(NSNumber*)value;

- (int16_t)primitiveCurrentStatusValue;
- (void)setPrimitiveCurrentStatusValue:(int16_t)value_;

- (NSString*)primitiveDisplayName;
- (void)setPrimitiveDisplayName:(NSString*)value;

- (NSDate*)primitiveLastMessageDate;
- (void)setPrimitiveLastMessageDate:(NSDate*)value;

- (NSNumber*)primitiveLastMessageDisconnected;
- (void)setPrimitiveLastMessageDisconnected:(NSNumber*)value;

- (BOOL)primitiveLastMessageDisconnectedValue;
- (void)setPrimitiveLastMessageDisconnectedValue:(BOOL)value_;

- (NSNumber*)primitiveLastSentChatState;
- (void)setPrimitiveLastSentChatState:(NSNumber*)value;

- (int16_t)primitiveLastSentChatStateValue;
- (void)setPrimitiveLastSentChatStateValue:(int16_t)value_;

- (NSNumber*)primitivePendingApproval;
- (void)setPrimitivePendingApproval:(NSNumber*)value;

- (BOOL)primitivePendingApprovalValue;
- (void)setPrimitivePendingApprovalValue:(BOOL)value_;

- (id)primitivePhoto;
- (void)setPrimitivePhoto:(id)value;

- (NSMutableOrderedSet*)primitiveMessages;
- (void)setPrimitiveMessages:(NSMutableOrderedSet*)value;

- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;

@end

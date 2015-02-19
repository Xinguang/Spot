// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Friend.m instead.

#import "_Friend.h"

const struct FriendAttributes FriendAttributes = {
	.accountName = @"accountName",
	.chatState = @"chatState",
	.composingMessageString = @"composingMessageString",
	.createAt = @"createAt",
	.currentStatus = @"currentStatus",
	.displayName = @"displayName",
	.lastMessageDate = @"lastMessageDate",
	.lastMessageDisconnected = @"lastMessageDisconnected",
	.lastSentChatState = @"lastSentChatState",
	.pendingApproval = @"pendingApproval",
	.photo = @"photo",
};

const struct FriendRelationships FriendRelationships = {
	.messages = @"messages",
	.user = @"user",
};

@implementation FriendID
@end

@implementation _Friend

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Friend";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:moc_];
}

- (FriendID*)objectID {
	return (FriendID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"chatStateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"chatState"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"currentStatusValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"currentStatus"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lastMessageDisconnectedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lastMessageDisconnected"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lastSentChatStateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lastSentChatState"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"pendingApprovalValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"pendingApproval"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic accountName;

@dynamic chatState;

- (int16_t)chatStateValue {
	NSNumber *result = [self chatState];
	return [result shortValue];
}

- (void)setChatStateValue:(int16_t)value_ {
	[self setChatState:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveChatStateValue {
	NSNumber *result = [self primitiveChatState];
	return [result shortValue];
}

- (void)setPrimitiveChatStateValue:(int16_t)value_ {
	[self setPrimitiveChatState:[NSNumber numberWithShort:value_]];
}

@dynamic composingMessageString;

@dynamic createAt;

@dynamic currentStatus;

- (int16_t)currentStatusValue {
	NSNumber *result = [self currentStatus];
	return [result shortValue];
}

- (void)setCurrentStatusValue:(int16_t)value_ {
	[self setCurrentStatus:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCurrentStatusValue {
	NSNumber *result = [self primitiveCurrentStatus];
	return [result shortValue];
}

- (void)setPrimitiveCurrentStatusValue:(int16_t)value_ {
	[self setPrimitiveCurrentStatus:[NSNumber numberWithShort:value_]];
}

@dynamic displayName;

@dynamic lastMessageDate;

@dynamic lastMessageDisconnected;

- (BOOL)lastMessageDisconnectedValue {
	NSNumber *result = [self lastMessageDisconnected];
	return [result boolValue];
}

- (void)setLastMessageDisconnectedValue:(BOOL)value_ {
	[self setLastMessageDisconnected:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveLastMessageDisconnectedValue {
	NSNumber *result = [self primitiveLastMessageDisconnected];
	return [result boolValue];
}

- (void)setPrimitiveLastMessageDisconnectedValue:(BOOL)value_ {
	[self setPrimitiveLastMessageDisconnected:[NSNumber numberWithBool:value_]];
}

@dynamic lastSentChatState;

- (int16_t)lastSentChatStateValue {
	NSNumber *result = [self lastSentChatState];
	return [result shortValue];
}

- (void)setLastSentChatStateValue:(int16_t)value_ {
	[self setLastSentChatState:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveLastSentChatStateValue {
	NSNumber *result = [self primitiveLastSentChatState];
	return [result shortValue];
}

- (void)setPrimitiveLastSentChatStateValue:(int16_t)value_ {
	[self setPrimitiveLastSentChatState:[NSNumber numberWithShort:value_]];
}

@dynamic pendingApproval;

- (BOOL)pendingApprovalValue {
	NSNumber *result = [self pendingApproval];
	return [result boolValue];
}

- (void)setPendingApprovalValue:(BOOL)value_ {
	[self setPendingApproval:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitivePendingApprovalValue {
	NSNumber *result = [self primitivePendingApproval];
	return [result boolValue];
}

- (void)setPrimitivePendingApprovalValue:(BOOL)value_ {
	[self setPrimitivePendingApproval:[NSNumber numberWithBool:value_]];
}

@dynamic photo;

@dynamic messages;

- (NSMutableOrderedSet*)messagesSet {
	[self willAccessValueForKey:@"messages"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"messages"];

	[self didAccessValueForKey:@"messages"];
	return result;
}

@dynamic user;

@end

@implementation _Friend (MessagesCoreDataGeneratedAccessors)
- (void)addMessages:(NSOrderedSet*)value_ {
	[self.messagesSet unionOrderedSet:value_];
}
- (void)removeMessages:(NSOrderedSet*)value_ {
	[self.messagesSet minusOrderedSet:value_];
}
- (void)addMessagesObject:(SpotMessage*)value_ {
	[self.messagesSet addObject:value_];
}
- (void)removeMessagesObject:(SpotMessage*)value_ {
	[self.messagesSet removeObject:value_];
}
- (void)insertObject:(SpotMessage*)value inMessagesAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"messages"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self messages]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"messages"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"messages"];
}
- (void)removeObjectFromMessagesAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"messages"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self messages]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"messages"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"messages"];
}
- (void)insertMessages:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"messages"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self messages]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"messages"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"messages"];
}
- (void)removeMessagesAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"messages"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self messages]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"messages"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"messages"];
}
- (void)replaceObjectInMessagesAtIndex:(NSUInteger)idx withObject:(SpotMessage*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"messages"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self messages]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"messages"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"messages"];
}
- (void)replaceMessagesAtIndexes:(NSIndexSet *)indexes withMessages:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"messages"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self messages]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"messages"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"messages"];
}
@end


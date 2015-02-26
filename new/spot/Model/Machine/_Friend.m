// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Friend.m instead.

#import "_Friend.h"

const struct FriendAttributes FriendAttributes = {
	.jidStr = @"jidStr",
	.unreadMessages = @"unreadMessages",
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

	if ([key isEqualToString:@"unreadMessagesValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"unreadMessages"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic jidStr;

@dynamic unreadMessages;

- (int32_t)unreadMessagesValue {
	NSNumber *result = [self unreadMessages];
	return [result intValue];
}

- (void)setUnreadMessagesValue:(int32_t)value_ {
	[self setUnreadMessages:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveUnreadMessagesValue {
	NSNumber *result = [self primitiveUnreadMessages];
	return [result intValue];
}

- (void)setPrimitiveUnreadMessagesValue:(int32_t)value_ {
	[self setPrimitiveUnreadMessages:[NSNumber numberWithInt:value_]];
}

@end


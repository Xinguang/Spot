// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.m instead.

#import "_User.h"

const struct UserAttributes UserAttributes = {
	.age = @"age",
	.birthday = @"birthday",
	.displayName = @"displayName",
	.nickName = @"nickName",
	.uniqueIdentifier = @"uniqueIdentifier",
	.username = @"username",
};

const struct UserRelationships UserRelationships = {
	.friends = @"friends",
};

@implementation UserID
@end

@implementation _User

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"User";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc_];
}

- (UserID*)objectID {
	return (UserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"ageValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"age"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic age;

- (int32_t)ageValue {
	NSNumber *result = [self age];
	return [result intValue];
}

- (void)setAgeValue:(int32_t)value_ {
	[self setAge:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveAgeValue {
	NSNumber *result = [self primitiveAge];
	return [result intValue];
}

- (void)setPrimitiveAgeValue:(int32_t)value_ {
	[self setPrimitiveAge:[NSNumber numberWithInt:value_]];
}

@dynamic birthday;

@dynamic displayName;

@dynamic nickName;

@dynamic uniqueIdentifier;

@dynamic username;

@dynamic friends;

- (NSMutableOrderedSet*)friendsSet {
	[self willAccessValueForKey:@"friends"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"friends"];

	[self didAccessValueForKey:@"friends"];
	return result;
}

@end

@implementation _User (FriendsCoreDataGeneratedAccessors)
- (void)addFriends:(NSOrderedSet*)value_ {
	[self.friendsSet unionOrderedSet:value_];
}
- (void)removeFriends:(NSOrderedSet*)value_ {
	[self.friendsSet minusOrderedSet:value_];
}
- (void)addFriendsObject:(Friend*)value_ {
	[self.friendsSet addObject:value_];
}
- (void)removeFriendsObject:(Friend*)value_ {
	[self.friendsSet removeObject:value_];
}
- (void)insertObject:(Friend*)value inFriendsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"friends"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self friends]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"friends"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"friends"];
}
- (void)removeObjectFromFriendsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"friends"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self friends]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"friends"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"friends"];
}
- (void)insertFriends:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"friends"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self friends]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"friends"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"friends"];
}
- (void)removeFriendsAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"friends"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self friends]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"friends"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"friends"];
}
- (void)replaceObjectInFriendsAtIndex:(NSUInteger)idx withObject:(Friend*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"friends"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self friends]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"friends"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"friends"];
}
- (void)replaceFriendsAtIndexes:(NSIndexSet *)indexes withFriends:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"friends"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self friends]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"friends"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"friends"];
}
@end


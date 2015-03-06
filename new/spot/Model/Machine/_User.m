// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.m instead.

#import "_User.h"

const struct UserAttributes UserAttributes = {
	.age = @"age",
	.avatarData = @"avatarData",
	.birthday = @"birthday",
	.displayName = @"displayName",
	.openfireId = @"openfireId",
	.username = @"username",
};

const struct UserRelationships UserRelationships = {
	.snses = @"snses",
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

@dynamic avatarData;

@dynamic birthday;

@dynamic displayName;

@dynamic openfireId;

@dynamic username;

@dynamic snses;

- (NSMutableOrderedSet*)snsesSet {
	[self willAccessValueForKey:@"snses"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"snses"];

	[self didAccessValueForKey:@"snses"];
	return result;
}

@end

@implementation _User (SnsesCoreDataGeneratedAccessors)
- (void)addSnses:(NSOrderedSet*)value_ {
	[self.snsesSet unionOrderedSet:value_];
}
- (void)removeSnses:(NSOrderedSet*)value_ {
	[self.snsesSet minusOrderedSet:value_];
}
- (void)addSnsesObject:(SNS*)value_ {
	[self.snsesSet addObject:value_];
}
- (void)removeSnsesObject:(SNS*)value_ {
	[self.snsesSet removeObject:value_];
}
- (void)insertObject:(SNS*)value inSnsesAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"snses"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self snses]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"snses"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"snses"];
}
- (void)removeObjectFromSnsesAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"snses"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self snses]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"snses"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"snses"];
}
- (void)insertSnses:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"snses"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self snses]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"snses"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"snses"];
}
- (void)removeSnsesAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"snses"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self snses]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"snses"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"snses"];
}
- (void)replaceObjectInSnsesAtIndex:(NSUInteger)idx withObject:(SNS*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"snses"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self snses]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"snses"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"snses"];
}
- (void)replaceSnsesAtIndexes:(NSIndexSet *)indexes withSnses:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"snses"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self snses]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"snses"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"snses"];
}
@end


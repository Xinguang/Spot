// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.m instead.

#import "_User.h"

const struct UserAttributes UserAttributes = {
	.age = @"age",
	.avatarData = @"avatarData",
	.birthday = @"birthday",
	.displayName = @"displayName",
	.figureurl = @"figureurl",
	.nickName = @"nickName",
	.openfireId = @"openfireId",
	.username = @"username",
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

@dynamic figureurl;

@dynamic nickName;

@dynamic openfireId;

@dynamic username;

@end


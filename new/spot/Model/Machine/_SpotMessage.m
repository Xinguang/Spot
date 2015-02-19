// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SpotMessage.m instead.

#import "_SpotMessage.h"

const struct SpotMessageAttributes SpotMessageAttributes = {
	.createAt = @"createAt",
	.delivered = @"delivered",
	.incoming = @"incoming",
	.messageId = @"messageId",
	.read = @"read",
	.text = @"text",
};

const struct SpotMessageRelationships SpotMessageRelationships = {
	.friend = @"friend",
};

@implementation SpotMessageID
@end

@implementation _SpotMessage

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SpotMessage" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SpotMessage";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SpotMessage" inManagedObjectContext:moc_];
}

- (SpotMessageID*)objectID {
	return (SpotMessageID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"deliveredValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"delivered"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"incomingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"incoming"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"readValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"read"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic createAt;

@dynamic delivered;

- (BOOL)deliveredValue {
	NSNumber *result = [self delivered];
	return [result boolValue];
}

- (void)setDeliveredValue:(BOOL)value_ {
	[self setDelivered:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveDeliveredValue {
	NSNumber *result = [self primitiveDelivered];
	return [result boolValue];
}

- (void)setPrimitiveDeliveredValue:(BOOL)value_ {
	[self setPrimitiveDelivered:[NSNumber numberWithBool:value_]];
}

@dynamic incoming;

- (BOOL)incomingValue {
	NSNumber *result = [self incoming];
	return [result boolValue];
}

- (void)setIncomingValue:(BOOL)value_ {
	[self setIncoming:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIncomingValue {
	NSNumber *result = [self primitiveIncoming];
	return [result boolValue];
}

- (void)setPrimitiveIncomingValue:(BOOL)value_ {
	[self setPrimitiveIncoming:[NSNumber numberWithBool:value_]];
}

@dynamic messageId;

@dynamic read;

- (BOOL)readValue {
	NSNumber *result = [self read];
	return [result boolValue];
}

- (void)setReadValue:(BOOL)value_ {
	[self setRead:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveReadValue {
	NSNumber *result = [self primitiveRead];
	return [result boolValue];
}

- (void)setPrimitiveReadValue:(BOOL)value_ {
	[self setPrimitiveRead:[NSNumber numberWithBool:value_]];
}

@dynamic text;

@dynamic friend;

@end


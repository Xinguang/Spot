// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FriendRequest.m instead.

#import "_FriendRequest.h"

const struct FriendRequestAttributes FriendRequestAttributes = {
	.createAt = @"createAt",
	.displayName = @"displayName",
	.jid = @"jid",
};

@implementation FriendRequestID
@end

@implementation _FriendRequest

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"FriendRequest" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"FriendRequest";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"FriendRequest" inManagedObjectContext:moc_];
}

- (FriendRequestID*)objectID {
	return (FriendRequestID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic createAt;

@dynamic displayName;

@dynamic jid;

@end


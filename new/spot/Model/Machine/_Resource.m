// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Resource.m instead.

#import "_Resource.h"

const struct ResourceAttributes ResourceAttributes = {
	.data = @"data",
	.path = @"path",
};

@implementation ResourceID
@end

@implementation _Resource

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Resource" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Resource";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Resource" inManagedObjectContext:moc_];
}

- (ResourceID*)objectID {
	return (ResourceID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic data;

@dynamic path;

@end


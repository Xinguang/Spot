// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Station.m instead.

#import "_Station.h"

const struct StationAttributes StationAttributes = {
	.name = @"name",
};

const struct StationRelationships StationRelationships = {
	.user = @"user",
};

@implementation StationID
@end

@implementation _Station

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Station" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Station";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Station" inManagedObjectContext:moc_];
}

- (StationID*)objectID {
	return (StationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic name;

@dynamic user;

@end


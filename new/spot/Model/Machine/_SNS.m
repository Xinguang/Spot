// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SNS.m instead.

#import "_SNS.h"

const struct SNSAttributes SNSAttributes = {
	.access_token = @"access_token",
	.expirationDate = @"expirationDate",
	.figureurl = @"figureurl",
	.nickName = @"nickName",
	.openid = @"openid",
	.refresh_token = @"refresh_token",
	.type = @"type",
};

const struct SNSRelationships SNSRelationships = {
	.user = @"user",
};

@implementation SNSID
@end

@implementation _SNS

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SNS" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SNS";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SNS" inManagedObjectContext:moc_];
}

- (SNSID*)objectID {
	return (SNSID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic access_token;

@dynamic expirationDate;

@dynamic figureurl;

@dynamic nickName;

@dynamic openid;

@dynamic refresh_token;

@dynamic type;

@dynamic user;

@end


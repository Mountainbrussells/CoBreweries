// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CBFUser.m instead.

#import "_CBFUser.h"

const struct CBFUserAttributes CBFUserAttributes = {
	.dateCreated = @"dateCreated",
	.dateUpdated = @"dateUpdated",
	.email = @"email",
	.password = @"password",
	.uid = @"uid",
	.userName = @"userName",
};

const struct CBFUserRelationships CBFUserRelationships = {
	.beerRatings = @"beerRatings",
	.beers = @"beers",
	.breweryRatings = @"breweryRatings",
};

@implementation CBFUserID
@end

@implementation _CBFUser

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

- (CBFUserID*)objectID {
	return (CBFUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"uidValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"uid"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic dateCreated;

@dynamic dateUpdated;

@dynamic email;

@dynamic password;

@dynamic uid;

- (float)uidValue {
	NSNumber *result = [self uid];
	return [result floatValue];
}

- (void)setUidValue:(float)value_ {
	[self setUid:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveUidValue {
	NSNumber *result = [self primitiveUid];
	return [result floatValue];
}

- (void)setPrimitiveUidValue:(float)value_ {
	[self setPrimitiveUid:[NSNumber numberWithFloat:value_]];
}

@dynamic userName;

@dynamic beerRatings;

- (NSMutableSet*)beerRatingsSet {
	[self willAccessValueForKey:@"beerRatings"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"beerRatings"];

	[self didAccessValueForKey:@"beerRatings"];
	return result;
}

@dynamic beers;

- (NSMutableSet*)beersSet {
	[self willAccessValueForKey:@"beers"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"beers"];

	[self didAccessValueForKey:@"beers"];
	return result;
}

@dynamic breweryRatings;

- (NSMutableSet*)breweryRatingsSet {
	[self willAccessValueForKey:@"breweryRatings"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"breweryRatings"];

	[self didAccessValueForKey:@"breweryRatings"];
	return result;
}

@end


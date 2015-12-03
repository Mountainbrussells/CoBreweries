// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CBFBeer.m instead.

#import "_CBFBeer.h"

const struct CBFBeerAttributes CBFBeerAttributes = {
	.dateCreated = @"dateCreated",
	.dateUpdated = @"dateUpdated",
	.name = @"name",
};

const struct CBFBeerRelationships CBFBeerRelationships = {
	.brewery = @"brewery",
	.ratings = @"ratings",
	.user = @"user",
};

@implementation CBFBeerID
@end

@implementation _CBFBeer

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Beer" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Beer";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Beer" inManagedObjectContext:moc_];
}

- (CBFBeerID*)objectID {
	return (CBFBeerID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic dateCreated;

@dynamic dateUpdated;

@dynamic name;

@dynamic brewery;

@dynamic ratings;

- (NSMutableSet*)ratingsSet {
	[self willAccessValueForKey:@"ratings"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"ratings"];

	[self didAccessValueForKey:@"ratings"];
	return result;
}

@dynamic user;

@end


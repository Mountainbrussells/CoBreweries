// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CBFBeer.m instead.

#import "_CBFBeer.h"

const struct CBFBeerAttributes CBFBeerAttributes = {
	.averageRating = @"averageRating",
	.createdBy = @"createdBy",
	.dateCreated = @"dateCreated",
	.dateUpdated = @"dateUpdated",
	.name = @"name",
};

const struct CBFBeerRelationships CBFBeerRelationships = {
	.brewery = @"brewery",
	.ratings = @"ratings",
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

	if ([key isEqualToString:@"averageRatingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"averageRating"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic averageRating;

- (float)averageRatingValue {
	NSNumber *result = [self averageRating];
	return [result floatValue];
}

- (void)setAverageRatingValue:(float)value_ {
	[self setAverageRating:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveAverageRatingValue {
	NSNumber *result = [self primitiveAverageRating];
	return [result floatValue];
}

- (void)setPrimitiveAverageRatingValue:(float)value_ {
	[self setPrimitiveAverageRating:[NSNumber numberWithFloat:value_]];
}

@dynamic createdBy;

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

@end


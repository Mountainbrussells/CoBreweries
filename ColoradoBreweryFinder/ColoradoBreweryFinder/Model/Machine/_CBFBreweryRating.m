// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CBFBreweryRating.m instead.

#import "_CBFBreweryRating.h"

const struct CBFBreweryRatingAttributes CBFBreweryRatingAttributes = {
	.dateCreated = @"dateCreated",
	.dateUpdated = @"dateUpdated",
	.rating = @"rating",
};

const struct CBFBreweryRatingRelationships CBFBreweryRatingRelationships = {
	.brewery = @"brewery",
	.user = @"user",
};

@implementation CBFBreweryRatingID
@end

@implementation _CBFBreweryRating

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BreweryRating" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BreweryRating";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BreweryRating" inManagedObjectContext:moc_];
}

- (CBFBreweryRatingID*)objectID {
	return (CBFBreweryRatingID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"ratingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rating"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic dateCreated;

@dynamic dateUpdated;

@dynamic rating;

- (float)ratingValue {
	NSNumber *result = [self rating];
	return [result floatValue];
}

- (void)setRatingValue:(float)value_ {
	[self setRating:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveRatingValue {
	NSNumber *result = [self primitiveRating];
	return [result floatValue];
}

- (void)setPrimitiveRatingValue:(float)value_ {
	[self setPrimitiveRating:[NSNumber numberWithFloat:value_]];
}

@dynamic brewery;

@dynamic user;

@end


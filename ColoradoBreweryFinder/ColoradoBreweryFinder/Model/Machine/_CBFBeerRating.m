// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CBFBeerRating.m instead.

#import "_CBFBeerRating.h"

const struct CBFBeerRatingAttributes CBFBeerRatingAttributes = {
	.dateCreated = @"dateCreated",
	.dateUpdated = @"dateUpdated",
	.rating = @"rating",
	.review = @"review",
	.uid = @"uid",
	.userUID = @"userUID",
};

const struct CBFBeerRatingRelationships CBFBeerRatingRelationships = {
	.beer = @"beer",
	.user = @"user",
};

@implementation CBFBeerRatingID
@end

@implementation _CBFBeerRating

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BeerRating" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BeerRating";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BeerRating" inManagedObjectContext:moc_];
}

- (CBFBeerRatingID*)objectID {
	return (CBFBeerRatingID*)[super objectID];
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

@dynamic review;

@dynamic uid;

@dynamic userUID;

@dynamic beer;

@dynamic user;

@end


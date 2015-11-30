// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CBFBrewery.m instead.

#import "_CBFBrewery.h"

const struct CBFBreweryAttributes CBFBreweryAttributes = {
	.address = @"address",
	.averageRating = @"averageRating",
	.dateCreated = @"dateCreated",
	.dateUpdated = @"dateUpdated",
	.lattitude = @"lattitude",
	.logo = @"logo",
	.longitude = @"longitude",
	.name = @"name",
	.phoneNumber = @"phoneNumber",
	.websiteURL = @"websiteURL",
};

const struct CBFBreweryRelationships CBFBreweryRelationships = {
	.beers = @"beers",
	.ratings = @"ratings",
};

@implementation CBFBreweryID
@end

@implementation _CBFBrewery

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Brewery" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Brewery";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Brewery" inManagedObjectContext:moc_];
}

- (CBFBreweryID*)objectID {
	return (CBFBreweryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"averageRatingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"averageRating"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"lattitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lattitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic address;

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

@dynamic dateCreated;

@dynamic dateUpdated;

@dynamic lattitude;

- (double)lattitudeValue {
	NSNumber *result = [self lattitude];
	return [result doubleValue];
}

- (void)setLattitudeValue:(double)value_ {
	[self setLattitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLattitudeValue {
	NSNumber *result = [self primitiveLattitude];
	return [result doubleValue];
}

- (void)setPrimitiveLattitudeValue:(double)value_ {
	[self setPrimitiveLattitude:[NSNumber numberWithDouble:value_]];
}

@dynamic logo;

@dynamic longitude;

- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithDouble:value_]];
}

@dynamic name;

@dynamic phoneNumber;

@dynamic websiteURL;

@dynamic beers;

- (NSMutableSet*)beersSet {
	[self willAccessValueForKey:@"beers"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"beers"];

	[self didAccessValueForKey:@"beers"];
	return result;
}

@dynamic ratings;

- (NSMutableSet*)ratingsSet {
	[self willAccessValueForKey:@"ratings"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"ratings"];

	[self didAccessValueForKey:@"ratings"];
	return result;
}

@end


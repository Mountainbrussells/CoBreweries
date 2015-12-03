// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CBFBreweryRating.h instead.

#import <CoreData/CoreData.h>

extern const struct CBFBreweryRatingAttributes {
	__unsafe_unretained NSString *dateCreated;
	__unsafe_unretained NSString *dateUpdated;
	__unsafe_unretained NSString *rating;
} CBFBreweryRatingAttributes;

extern const struct CBFBreweryRatingRelationships {
	__unsafe_unretained NSString *brewery;
	__unsafe_unretained NSString *user;
} CBFBreweryRatingRelationships;

@class CBFBrewery;
@class CBFUser;

@interface CBFBreweryRatingID : NSManagedObjectID {}
@end

@interface _CBFBreweryRating : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CBFBreweryRatingID* objectID;

@property (nonatomic, strong) NSDate* dateCreated;

//- (BOOL)validateDateCreated:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateUpdated;

//- (BOOL)validateDateUpdated:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* rating;

@property (atomic) float ratingValue;
- (float)ratingValue;
- (void)setRatingValue:(float)value_;

//- (BOOL)validateRating:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) CBFBrewery *brewery;

//- (BOOL)validateBrewery:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) CBFUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _CBFBreweryRating (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveDateCreated;
- (void)setPrimitiveDateCreated:(NSDate*)value;

- (NSDate*)primitiveDateUpdated;
- (void)setPrimitiveDateUpdated:(NSDate*)value;

- (NSNumber*)primitiveRating;
- (void)setPrimitiveRating:(NSNumber*)value;

- (float)primitiveRatingValue;
- (void)setPrimitiveRatingValue:(float)value_;

- (CBFBrewery*)primitiveBrewery;
- (void)setPrimitiveBrewery:(CBFBrewery*)value;

- (CBFUser*)primitiveUser;
- (void)setPrimitiveUser:(CBFUser*)value;

@end

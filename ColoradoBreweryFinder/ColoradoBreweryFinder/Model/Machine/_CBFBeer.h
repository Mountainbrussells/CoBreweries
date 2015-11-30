// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CBFBeer.h instead.

#import <CoreData/CoreData.h>

extern const struct CBFBeerAttributes {
	__unsafe_unretained NSString *averageRating;
	__unsafe_unretained NSString *createdBy;
	__unsafe_unretained NSString *dateCreated;
	__unsafe_unretained NSString *dateUpdated;
	__unsafe_unretained NSString *name;
} CBFBeerAttributes;

extern const struct CBFBeerRelationships {
	__unsafe_unretained NSString *brewery;
	__unsafe_unretained NSString *ratings;
} CBFBeerRelationships;

@class CBFBrewery;
@class CBFBeerRating;

@interface CBFBeerID : NSManagedObjectID {}
@end

@interface _CBFBeer : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CBFBeerID* objectID;

@property (nonatomic, strong) NSNumber* averageRating;

@property (atomic) float averageRatingValue;
- (float)averageRatingValue;
- (void)setAverageRatingValue:(float)value_;

//- (BOOL)validateAverageRating:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* createdBy;

//- (BOOL)validateCreatedBy:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateCreated;

//- (BOOL)validateDateCreated:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateUpdated;

//- (BOOL)validateDateUpdated:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) CBFBrewery *brewery;

//- (BOOL)validateBrewery:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *ratings;

- (NSMutableSet*)ratingsSet;

@end

@interface _CBFBeer (RatingsCoreDataGeneratedAccessors)
- (void)addRatings:(NSSet*)value_;
- (void)removeRatings:(NSSet*)value_;
- (void)addRatingsObject:(CBFBeerRating*)value_;
- (void)removeRatingsObject:(CBFBeerRating*)value_;

@end

@interface _CBFBeer (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveAverageRating;
- (void)setPrimitiveAverageRating:(NSNumber*)value;

- (float)primitiveAverageRatingValue;
- (void)setPrimitiveAverageRatingValue:(float)value_;

- (NSString*)primitiveCreatedBy;
- (void)setPrimitiveCreatedBy:(NSString*)value;

- (NSDate*)primitiveDateCreated;
- (void)setPrimitiveDateCreated:(NSDate*)value;

- (NSDate*)primitiveDateUpdated;
- (void)setPrimitiveDateUpdated:(NSDate*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (CBFBrewery*)primitiveBrewery;
- (void)setPrimitiveBrewery:(CBFBrewery*)value;

- (NSMutableSet*)primitiveRatings;
- (void)setPrimitiveRatings:(NSMutableSet*)value;

@end

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CBFBrewery.h instead.

#import <CoreData/CoreData.h>

extern const struct CBFBreweryAttributes {
	__unsafe_unretained NSString *address;
	__unsafe_unretained NSString *dateCreated;
	__unsafe_unretained NSString *dateUpdated;
	__unsafe_unretained NSString *lattitude;
	__unsafe_unretained NSString *logo;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *phoneNumber;
	__unsafe_unretained NSString *websiteURL;
} CBFBreweryAttributes;

extern const struct CBFBreweryRelationships {
	__unsafe_unretained NSString *beers;
	__unsafe_unretained NSString *ratings;
} CBFBreweryRelationships;

@class CBFBeer;
@class CBFBreweryRating;

@interface CBFBreweryID : NSManagedObjectID {}
@end

@interface _CBFBrewery : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CBFBreweryID* objectID;

@property (nonatomic, strong) NSString* address;

//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateCreated;

//- (BOOL)validateDateCreated:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateUpdated;

//- (BOOL)validateDateUpdated:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* lattitude;

@property (atomic) double lattitudeValue;
- (double)lattitudeValue;
- (void)setLattitudeValue:(double)value_;

//- (BOOL)validateLattitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSData* logo;

//- (BOOL)validateLogo:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* longitude;

@property (atomic) double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* phoneNumber;

//- (BOOL)validatePhoneNumber:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* websiteURL;

//- (BOOL)validateWebsiteURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *beers;

- (NSMutableSet*)beersSet;

@property (nonatomic, strong) NSSet *ratings;

- (NSMutableSet*)ratingsSet;

@end

@interface _CBFBrewery (BeersCoreDataGeneratedAccessors)
- (void)addBeers:(NSSet*)value_;
- (void)removeBeers:(NSSet*)value_;
- (void)addBeersObject:(CBFBeer*)value_;
- (void)removeBeersObject:(CBFBeer*)value_;

@end

@interface _CBFBrewery (RatingsCoreDataGeneratedAccessors)
- (void)addRatings:(NSSet*)value_;
- (void)removeRatings:(NSSet*)value_;
- (void)addRatingsObject:(CBFBreweryRating*)value_;
- (void)removeRatingsObject:(CBFBreweryRating*)value_;

@end

@interface _CBFBrewery (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAddress;
- (void)setPrimitiveAddress:(NSString*)value;

- (NSDate*)primitiveDateCreated;
- (void)setPrimitiveDateCreated:(NSDate*)value;

- (NSDate*)primitiveDateUpdated;
- (void)setPrimitiveDateUpdated:(NSDate*)value;

- (NSNumber*)primitiveLattitude;
- (void)setPrimitiveLattitude:(NSNumber*)value;

- (double)primitiveLattitudeValue;
- (void)setPrimitiveLattitudeValue:(double)value_;

- (NSData*)primitiveLogo;
- (void)setPrimitiveLogo:(NSData*)value;

- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitivePhoneNumber;
- (void)setPrimitivePhoneNumber:(NSString*)value;

- (NSString*)primitiveWebsiteURL;
- (void)setPrimitiveWebsiteURL:(NSString*)value;

- (NSMutableSet*)primitiveBeers;
- (void)setPrimitiveBeers:(NSMutableSet*)value;

- (NSMutableSet*)primitiveRatings;
- (void)setPrimitiveRatings:(NSMutableSet*)value;

@end

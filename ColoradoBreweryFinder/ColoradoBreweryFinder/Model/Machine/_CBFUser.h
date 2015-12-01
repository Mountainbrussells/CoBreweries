// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CBFUser.h instead.

#import <CoreData/CoreData.h>

extern const struct CBFUserAttributes {
	__unsafe_unretained NSString *dateCreated;
	__unsafe_unretained NSString *dateUpdated;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *password;
	__unsafe_unretained NSString *uid;
	__unsafe_unretained NSString *userName;
} CBFUserAttributes;

extern const struct CBFUserRelationships {
	__unsafe_unretained NSString *beerRatings;
	__unsafe_unretained NSString *beers;
	__unsafe_unretained NSString *breweryRatings;
} CBFUserRelationships;

@class CBFBeerRating;
@class CBFBeer;
@class CBFBreweryRating;

@interface CBFUserID : NSManagedObjectID {}
@end

@interface _CBFUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CBFUserID* objectID;

@property (nonatomic, strong) NSDate* dateCreated;

//- (BOOL)validateDateCreated:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateUpdated;

//- (BOOL)validateDateUpdated:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* email;

//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* password;

//- (BOOL)validatePassword:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* uid;

@property (atomic) float uidValue;
- (float)uidValue;
- (void)setUidValue:(float)value_;

//- (BOOL)validateUid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userName;

//- (BOOL)validateUserName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *beerRatings;

- (NSMutableSet*)beerRatingsSet;

@property (nonatomic, strong) NSSet *beers;

- (NSMutableSet*)beersSet;

@property (nonatomic, strong) NSSet *breweryRatings;

- (NSMutableSet*)breweryRatingsSet;

@end

@interface _CBFUser (BeerRatingsCoreDataGeneratedAccessors)
- (void)addBeerRatings:(NSSet*)value_;
- (void)removeBeerRatings:(NSSet*)value_;
- (void)addBeerRatingsObject:(CBFBeerRating*)value_;
- (void)removeBeerRatingsObject:(CBFBeerRating*)value_;

@end

@interface _CBFUser (BeersCoreDataGeneratedAccessors)
- (void)addBeers:(NSSet*)value_;
- (void)removeBeers:(NSSet*)value_;
- (void)addBeersObject:(CBFBeer*)value_;
- (void)removeBeersObject:(CBFBeer*)value_;

@end

@interface _CBFUser (BreweryRatingsCoreDataGeneratedAccessors)
- (void)addBreweryRatings:(NSSet*)value_;
- (void)removeBreweryRatings:(NSSet*)value_;
- (void)addBreweryRatingsObject:(CBFBreweryRating*)value_;
- (void)removeBreweryRatingsObject:(CBFBreweryRating*)value_;

@end

@interface _CBFUser (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveDateCreated;
- (void)setPrimitiveDateCreated:(NSDate*)value;

- (NSDate*)primitiveDateUpdated;
- (void)setPrimitiveDateUpdated:(NSDate*)value;

- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;

- (NSString*)primitivePassword;
- (void)setPrimitivePassword:(NSString*)value;

- (NSNumber*)primitiveUid;
- (void)setPrimitiveUid:(NSNumber*)value;

- (float)primitiveUidValue;
- (void)setPrimitiveUidValue:(float)value_;

- (NSString*)primitiveUserName;
- (void)setPrimitiveUserName:(NSString*)value;

- (NSMutableSet*)primitiveBeerRatings;
- (void)setPrimitiveBeerRatings:(NSMutableSet*)value;

- (NSMutableSet*)primitiveBeers;
- (void)setPrimitiveBeers:(NSMutableSet*)value;

- (NSMutableSet*)primitiveBreweryRatings;
- (void)setPrimitiveBreweryRatings:(NSMutableSet*)value;

@end

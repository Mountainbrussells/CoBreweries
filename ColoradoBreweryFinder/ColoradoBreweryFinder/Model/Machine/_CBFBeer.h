// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CBFBeer.h instead.

#import <CoreData/CoreData.h>

extern const struct CBFBeerAttributes {
	__unsafe_unretained NSString *abv;
	__unsafe_unretained NSString *dateCreated;
	__unsafe_unretained NSString *dateUpdated;
	__unsafe_unretained NSString *ibus;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *style;
	__unsafe_unretained NSString *uid;
} CBFBeerAttributes;

extern const struct CBFBeerRelationships {
	__unsafe_unretained NSString *brewery;
	__unsafe_unretained NSString *ratings;
	__unsafe_unretained NSString *user;
} CBFBeerRelationships;

@class CBFBrewery;
@class CBFBeerRating;
@class CBFUser;

@interface CBFBeerID : NSManagedObjectID {}
@end

@interface _CBFBeer : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CBFBeerID* objectID;

@property (nonatomic, strong) NSString* abv;

//- (BOOL)validateAbv:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateCreated;

//- (BOOL)validateDateCreated:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateUpdated;

//- (BOOL)validateDateUpdated:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* ibus;

//- (BOOL)validateIbus:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* style;

//- (BOOL)validateStyle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* uid;

//- (BOOL)validateUid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) CBFBrewery *brewery;

//- (BOOL)validateBrewery:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *ratings;

- (NSMutableSet*)ratingsSet;

@property (nonatomic, strong) CBFUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _CBFBeer (RatingsCoreDataGeneratedAccessors)
- (void)addRatings:(NSSet*)value_;
- (void)removeRatings:(NSSet*)value_;
- (void)addRatingsObject:(CBFBeerRating*)value_;
- (void)removeRatingsObject:(CBFBeerRating*)value_;

@end

@interface _CBFBeer (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAbv;
- (void)setPrimitiveAbv:(NSString*)value;

- (NSDate*)primitiveDateCreated;
- (void)setPrimitiveDateCreated:(NSDate*)value;

- (NSDate*)primitiveDateUpdated;
- (void)setPrimitiveDateUpdated:(NSDate*)value;

- (NSString*)primitiveIbus;
- (void)setPrimitiveIbus:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveStyle;
- (void)setPrimitiveStyle:(NSString*)value;

- (NSString*)primitiveUid;
- (void)setPrimitiveUid:(NSString*)value;

- (CBFBrewery*)primitiveBrewery;
- (void)setPrimitiveBrewery:(CBFBrewery*)value;

- (NSMutableSet*)primitiveRatings;
- (void)setPrimitiveRatings:(NSMutableSet*)value;

- (CBFUser*)primitiveUser;
- (void)setPrimitiveUser:(CBFUser*)value;

@end

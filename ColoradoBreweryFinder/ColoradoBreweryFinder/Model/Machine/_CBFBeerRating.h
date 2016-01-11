// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CBFBeerRating.h instead.

#import <CoreData/CoreData.h>

extern const struct CBFBeerRatingAttributes {
	__unsafe_unretained NSString *dateCreated;
	__unsafe_unretained NSString *dateUpdated;
	__unsafe_unretained NSString *rating;
	__unsafe_unretained NSString *review;
	__unsafe_unretained NSString *uid;
	__unsafe_unretained NSString *userUID;
	__unsafe_unretained NSString *username;
} CBFBeerRatingAttributes;

extern const struct CBFBeerRatingRelationships {
	__unsafe_unretained NSString *beer;
	__unsafe_unretained NSString *user;
} CBFBeerRatingRelationships;

@class CBFBeer;
@class CBFUser;

@interface CBFBeerRatingID : NSManagedObjectID {}
@end

@interface _CBFBeerRating : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CBFBeerRatingID* objectID;

@property (nonatomic, strong) NSDate* dateCreated;

//- (BOOL)validateDateCreated:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateUpdated;

//- (BOOL)validateDateUpdated:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* rating;

@property (atomic) float ratingValue;
- (float)ratingValue;
- (void)setRatingValue:(float)value_;

//- (BOOL)validateRating:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* review;

//- (BOOL)validateReview:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* uid;

//- (BOOL)validateUid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userUID;

//- (BOOL)validateUserUID:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* username;

//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) CBFBeer *beer;

//- (BOOL)validateBeer:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) CBFUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _CBFBeerRating (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveDateCreated;
- (void)setPrimitiveDateCreated:(NSDate*)value;

- (NSDate*)primitiveDateUpdated;
- (void)setPrimitiveDateUpdated:(NSDate*)value;

- (NSNumber*)primitiveRating;
- (void)setPrimitiveRating:(NSNumber*)value;

- (float)primitiveRatingValue;
- (void)setPrimitiveRatingValue:(float)value_;

- (NSString*)primitiveReview;
- (void)setPrimitiveReview:(NSString*)value;

- (NSString*)primitiveUid;
- (void)setPrimitiveUid:(NSString*)value;

- (NSString*)primitiveUserUID;
- (void)setPrimitiveUserUID:(NSString*)value;

- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;

- (CBFBeer*)primitiveBeer;
- (void)setPrimitiveBeer:(CBFBeer*)value;

- (CBFUser*)primitiveUser;
- (void)setPrimitiveUser:(CBFUser*)value;

@end

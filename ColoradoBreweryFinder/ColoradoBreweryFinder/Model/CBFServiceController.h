//
//  CBFServiceController.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/3/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "BRPersistenceController.h"
#import "CBFCoreDataController.h"

@class CBFUser;
@class CBFBrewery;
@class CBFBreweryRating;

@interface CBFServiceController : NSObject

@property (strong, readonly) CBFUser *user;

@property (strong, nonatomic) CBFCoreDataController *coreDataController;

- (id) initWithPersistenceController:(BRPersistenceController *)persistenceController;

- (void) createUserWithUserName:(NSString *)name password:(NSString *)password email:(NSString *)email completion:(void (^)(NSManagedObjectID *objectId, NSString *sessionToken,  NSError *error))completion;


- (void) logInUserWithName:(NSString *)name andPassword:(NSString *)password completion:(void (^)(NSManagedObjectID *objectId, NSString *sessionToken, NSError *error))completion;

- (void) requestBreweriesWithCompletion:(void (^)(NSError *error))completion;

- (void) getImageForBrewery:(CBFBrewery *)brewery completion:(void (^)(UIImage *image, NSError *error))completion;

- (UIImage *) getImageWithURL:(NSString *)imageURLString completion:(void (^)(UIImage *)) completion;
- (void)createBreweryRating:(NSInteger)rating breweryId:(NSString *)breweryId completion:(void (^)(NSManagedObjectID *ratingObjectID, NSError *error))completion;

- (void)updateBreweryRating:(CBFBreweryRating *)rating withValue:(NSInteger)newRating completion:(void (^)(NSError *error))completion;

- (void) requestBreweryRatingsWithCompletion:(void (^)(NSError *error))completion;

- (void) requestBeersWithCompletion:(void (^)(NSError *error))completion;

- (void)requestBeerReviewsWithCompletion:(void (^)(NSError *error))completion;

- (NSString *)getUserNameWithUID:(NSString *)uid completion:(void (^)(NSString *userName))completion;

- (void) createBeerRating:(NSString *)rating withNote:(NSString *)note beerId:(NSString *)beerId completion:(void (^)(NSManagedObjectID *ratingObjectID, NSError *error))completion;



@end

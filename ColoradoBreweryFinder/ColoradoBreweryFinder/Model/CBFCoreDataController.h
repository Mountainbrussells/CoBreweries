//
//  CBFCoreDataController.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/4/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CBFUser.h"
#import "CBFBrewery.h"
#import "CBFBeer.h"
#import "CBFBeerRating.h"
#import "BRPersistenceController.h"



@interface CBFCoreDataController : NSObject

- (id)initWithPersistenceController:(BRPersistenceController *)persistenceController;

- (CBFUser *) fetchUserWithId:(NSManagedObjectID *)ManagedObjectId;

- (CBFUser *) fetchUserWithId:(NSManagedObjectID *)ManagedObjectId inContext:(NSManagedObjectContext *)context;

- (CBFUser *) fetchUserWithUID:(NSString *)uid;

- (CBFUser *) fetchUserWithUID:(NSString *)uid moc:(NSManagedObjectContext *)moc;

- (NSArray *) fetchBreweries;

- (NSArray *) fetchBreweriesInContext:(NSManagedObjectContext *)context;

- (NSArray *) fetchBreweriesWithCompletion:(void (^)(NSError *error))completion;

- (CBFBrewery *) fetchBreweryWithNSManagedObjectId:(NSManagedObjectID *)ManagedObjectId;

- (CBFBrewery *)fetchBreweryWithNSManagedObjectId:(NSManagedObjectID *)ManagedObjectId context:(NSManagedObjectContext *)context;

- (CBFBeer *) fetchBeerWithManagedObjectId:(NSManagedObjectID *)ManagedObjectId;

- (CBFBeer *) fetchBeerWithManagedObjectId:(NSManagedObjectID *)ManagedObjectId inContext:(NSManagedObjectContext *)context;

- (CBFBrewery *) fetchBreweryWithUID:(NSString *)uid;

- (CBFBrewery *) fetchBreweryWithUID:(NSString *)uid moc:(NSManagedObjectContext *)moc;

- (NSArray *) fetchBreweryRatings;

-(NSArray *) fetchBreweryRatingsInContext:(NSManagedObjectContext *)context;

- (CBFBreweryRating *) fetchBreweryRatingWithUID:(NSString *)uid;

- (CBFBreweryRating *) fetchBreweryRatingWithUID:(NSString *)uid moc:(NSManagedObjectContext *)moc;

- (NSArray *) fetchBeerReviewsForBeer:(CBFBeer *)beer;

- (NSArray *) fetchBreweryRatingsForBrewery:(CBFBrewery *)brewery;

- (NSArray *) fetchBeersForBrewery:(CBFBrewery *)brewery;

- (NSArray *) fetchBeers;

- (NSArray *) fetchBeersInContext:(NSManagedObjectContext *)context;

- (CBFBeer *) fetchBeerWithUID:(NSString *)uid;

- (CBFBeer *) fetchBeerWithUID:(NSString *)uid moc:(NSManagedObjectContext *)moc;

- (NSArray *) fetchBeerReviews;

- (NSArray *) fetchBeerReviewsInContext:(NSManagedObjectContext *)context;

- (CBFBeerRating *) fetchBeerRatingForBeer:(CBFBeer *)beer andUser:(CBFUser *)user;

- (CBFBeerRating *)fetchBeerRatingWithNSManagedObjectId:(NSManagedObjectID *)ManagedObjectId;

- (CBFBeerRating *)fetchBeerRatingWithUID:(NSString *)uid moc:(NSManagedObjectContext *)moc;


@end

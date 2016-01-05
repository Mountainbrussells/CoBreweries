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
#import "BRPersistenceController.h"



@interface CBFCoreDataController : NSObject

- (id)initWithPersistenceController:(BRPersistenceController *)persistenceController;

- (CBFUser *)fetchUserWithId:(NSManagedObjectID *)ManagedObjectId;

- (CBFUser *)fetchUserWithUID:(NSString *)uid;

- (NSArray *)fetchBreweries;

- (CBFBrewery *)fetchBreweryWithNSManagedObjectId:(NSManagedObjectID *)ManagedObjectId;

- (CBFBrewery *)fetchBreweryWithUID:(NSString *)uid;

- (NSArray *)fetchBreweryRatings;

- (NSArray *)fetchBreweryRatingsForBrewery:(CBFBrewery *)brewery;

- (NSArray *)fetchBeersForBrewery:(CBFBrewery *)brewery;



@end

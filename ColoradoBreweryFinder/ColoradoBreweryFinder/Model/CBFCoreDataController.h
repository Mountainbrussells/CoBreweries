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
#import "BRPersistenceController.h"



@interface CBFCoreDataController : NSObject

- (id)initWithPersistenceController:(BRPersistenceController *)persistenceController;

- (CBFUser *)fetchUserWithId:(NSManagedObjectID *)ManagedObjectId;

- (NSArray *)fetchBreweries;

@end

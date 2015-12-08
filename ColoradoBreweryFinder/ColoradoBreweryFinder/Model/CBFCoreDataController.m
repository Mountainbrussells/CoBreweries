//
//  CBFCoreDataController.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/4/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "CBFCoreDataController.h"

@interface CBFCoreDataController ()

@property (strong, nonatomic) BRPersistenceController *persistencController;

@end

@implementation CBFCoreDataController

- (id)initWithPersistenceController:(BRPersistenceController *)persistenceController
{
    self = [super init];
    self.persistencController = persistenceController;
    return self;
}

- (CBFUser *)fetchUserWithId:(NSManagedObjectID *)ManagedObjectId
{
    // MOC is passed from AppDelegate when CoreDataController is initialized
    NSManagedObjectContext *moc = self.persistencController.managedObjectContext;
    CBFUser *user;
    NSError *error;
    user = [moc existingObjectWithID:ManagedObjectId error:&error];
    
    
    if (!user) {
        NSLog(@"Fetch failed with Error: %@", error);
        return nil;
    } 
    
    
    return user;
}


@end

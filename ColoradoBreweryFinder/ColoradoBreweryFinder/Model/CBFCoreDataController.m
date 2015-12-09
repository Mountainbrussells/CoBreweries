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
@property (strong, nonatomic) NSManagedObjectContext *moc;

@end

@implementation CBFCoreDataController

- (id)initWithPersistenceController:(BRPersistenceController *)persistenceController
{
    self = [super init];
    self.persistencController = persistenceController;
    self.moc = self.persistencController.managedObjectContext;
    return self;
}

- (CBFUser *)fetchUserWithId:(NSManagedObjectID *)ManagedObjectId
{
    // MOC is passed from AppDelegate when CoreDataController is initialized
    
    CBFUser *user;
    NSError *error;
    user = [self.moc existingObjectWithID:ManagedObjectId error:&error];
    
    
    if (!user) {
        NSLog(@"Fetch failed with Error: %@", error);
        return nil;
    } 
    
    
    return user;
}

- (NSArray *)fetchBreweries
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Brewery" inManagedObjectContext:self.moc];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedBreweries = [self.moc executeFetchRequest:fetchRequest error:&error];
    
    return fetchedBreweries;
    
}


@end

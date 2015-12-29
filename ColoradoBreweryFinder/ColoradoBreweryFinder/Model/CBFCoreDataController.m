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

- (CBFUser *)fetchUserWithUID:(NSString *)uid
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", uid];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.moc];
    [request setPredicate:predicate];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchResults = [self.moc executeFetchRequest:request error:&error];
    if (fetchResults.count > 0) {
        CBFUser *user = fetchResults[0];
        return user;
    } else {
        return nil;
    }
}

- (CBFBrewery *)fetchBreweryWithNSManagedObjectId:(NSManagedObjectID *)ManagedObjectId
{
    CBFBrewery *brewery;
    NSError *error;
    brewery = [self.moc existingObjectWithID:ManagedObjectId error:&error];
    
    if (!brewery) {
        NSLog(@"Fetch failed with error: %@", error);
        return nil;
    }
    
    return brewery;
}

- (CBFBrewery *)fetchBreweryWithUID:(NSString *)uid
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", uid];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Brewery" inManagedObjectContext:self.moc];
    [request setPredicate:predicate];
    [request setEntity:entity];
    NSError *error;
    NSArray *fetchResults = [self.moc executeFetchRequest:request error:&error];
    if (fetchResults.count > 0) {
        CBFBrewery *brewery = fetchResults[0];
        return brewery;
    } else {
        return nil;
    }
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

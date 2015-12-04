//
//  CBFCoreDataController.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/4/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "CBFCoreDataController.h"

@interface CBFCoreDataController ()



@end

@implementation CBFCoreDataController

- (CBFUser *)fetchUserWithId:(NSString *)userId inManagedObjectContext:(NSManagedObjectContext *)moc
{
    CBFUser *user;
    NSString *objectID = userId;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", objectID];
    fetchRequest.predicate = predicate;
    NSError *error;
    NSArray *fetchedUser = [moc executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedUser.count > 0 && fetchedUser.count < 2) {
        user = fetchedUser[0];
    }
    
    return user;
}


@end

//
//  CBFServiceController.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/3/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BRPersistenceController.h"

@class CBFUser;

@interface CBFServiceController : NSObject

@property (strong, readonly) CBFUser *user;

- (id)initWithPersistenceController:(BRPersistenceController *)persistenceController;

- (void)createUserWithUserName:(NSString *)name password:(NSString *)password email:(NSString *)email completion:(void (^)(NSManagedObjectID *objectId, NSString *sessionToken,  NSError *error))completion;


- (void)logInUserWithName:(NSString *)name andPassword:(NSString *)password completion:(void (^)(NSManagedObjectID *objectId, NSString *sessionToken, NSError *error))completion;

- (void)requestBreweriesWithCompletion:(void (^)(NSError *error))completion;


@end

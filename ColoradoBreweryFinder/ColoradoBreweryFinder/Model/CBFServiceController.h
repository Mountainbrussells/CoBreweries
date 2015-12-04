//
//  CBFServiceController.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/3/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CBFUser;

@interface CBFServiceController : NSObject

// May need to add error:(NSError *__autoreleasing *)error to this method
- (void)createUserWithUserName:(NSString *)name password:(NSString *)password email:(NSString *)email managedObjectContext:(NSManagedObjectContext *)moc completion:(void (^)(NSString *userId,  NSError *error))completion;



- (CBFUser *)logInUserWithName:(NSString *)name andPassword:(NSString *)password inManagedObjectContext:(NSManagedObjectContext *)moc;

@end

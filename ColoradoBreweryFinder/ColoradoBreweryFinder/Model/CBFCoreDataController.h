//
//  CBFCoreDataController.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/4/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBFUser.h"

@interface CBFCoreDataController : NSObject

- (CBFUser *)fetchUserWithId:(NSString *)userId inManagedObjectContext:(NSManagedObjectContext *)moc;

@end

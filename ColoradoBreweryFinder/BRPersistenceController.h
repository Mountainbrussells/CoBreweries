//
//  BRPersistenceController.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 11/20/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^InitCallbackBlock)(void);

@interface BRPersistenceController : NSObject

@property (strong, readonly) NSManagedObjectContext *managedObjectContext;

- (id) initWithCallBack:(InitCallbackBlock)callBack;

- (void) save;

@end

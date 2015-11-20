//
//  AppDelegate.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 11/19/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class BRPersistenceController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, readonly) BRPersistenceController *persistenceController;


@end


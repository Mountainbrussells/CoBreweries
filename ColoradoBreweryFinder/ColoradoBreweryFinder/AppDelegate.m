//
//  AppDelegate.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 11/19/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "AppDelegate.h"
#import "BRPersistenceController.h"
#import "ViewController.h"
#import "CBFLogInViewController.h"
#import "CBFServiceController.h"
#import "CBFCoreDataController.h"
#import "CBFUser.h"

#import "STKeychain.h"


@interface AppDelegate ()

@property (strong, readwrite) BRPersistenceController *persistenceController;
@property (strong, readwrite) CBFCoreDataController *coreDataController;
@property (strong, readwrite) CBFServiceController *serviceController;


- (void)completeUserInterface;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setPersistenceController:[[BRPersistenceController alloc] initWithCallBack:^{
        [self completeUserInterface];
    }]];
    self.serviceController = [[CBFServiceController alloc] initWithPersistenceController:self.persistenceController];
    self.coreDataController = [[CBFCoreDataController alloc] initWithPersistenceController:self.persistenceController];
    self.serviceController.coreDataController = self.coreDataController;
    
    
    
    
    CBFLogInViewController *livc = (CBFLogInViewController *)self.window.rootViewController;
    livc.persistenceController = self.persistenceController;
    livc.serviceController = self.serviceController;
    livc.coreDataController = self.coreDataController;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    if ([defaults valueForKey:@"DataHasBeenLoaded"] == NO) {
        // populate brewery data
        [self.serviceController requestBreweriesWithCompletion:nil];
        [defaults setBool:YES forKey:@"DataHasBeenLoaded"];
    }
    
    return YES;
    
}

- (void)completeUserInterface
{

}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[self persistenceController] save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[self persistenceController] save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    CBFUser *user = self.serviceController.user;
    if (user) {
//        [self.serviceController updateBreweriesWithCompletion:^(NSError *error) {
//            [self.serviceController updateBreweryRatingsWithCompletion:nil];
//        }];
//        
//        [self.serviceController updateBeersWtihCompletion:^(NSError *error) {
//            [self.serviceController updateBeerReviewsWithCompletion:nil];
//        }];
    }

    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    CBFUser *user = self.serviceController.user;
    if (user) {
//        [self.serviceController updateBreweriesWithCompletion:^(NSError *error) {
//            [self.serviceController updateBreweryRatingsWithCompletion:nil];
//        }];
//        [self.serviceController updateBeersWtihCompletion:^(NSError *error) {
//            [self.serviceController updateBeerReviewsWithCompletion:nil];
//        }];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[self persistenceController] save];
    
}


@end

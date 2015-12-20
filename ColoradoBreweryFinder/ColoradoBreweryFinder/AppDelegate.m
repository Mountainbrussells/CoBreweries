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
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[self persistenceController] save];
    
}


@end

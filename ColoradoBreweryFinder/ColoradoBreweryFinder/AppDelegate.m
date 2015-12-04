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


@interface AppDelegate ()

@property (strong, readwrite) BRPersistenceController *persistenceController;

- (void)completeUserInterface;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setPersistenceController:[[BRPersistenceController alloc] initWithCallBack:^{
        [self completeUserInterface];
    }]];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"UserLoggedIn"]) {
        
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ViewController *uvc = [storyboard instantiateViewControllerWithIdentifier:@"Main"];
        uvc.persistenceController = self.persistenceController;
        self.window.rootViewController = uvc;
        [self.window makeKeyAndVisible];
        
        
    } else {
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        CBFLogInViewController *uvc = [storyboard instantiateViewControllerWithIdentifier:@"LogIn"];
        uvc.persistenceController = self.persistenceController;
        self.window.rootViewController = uvc;
        [self.window makeKeyAndVisible];
    }
    
    
    
    return YES;
    
}

- (void)completeUserInterface
{
    // 
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

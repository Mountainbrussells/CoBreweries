//
//  ViewController.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 11/19/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRPersistenceController.h"
#import "CBFServiceController.h"
#import "CBFCoreDataController.h"
#import "CBFUser.h"


@interface ViewController : UIViewController

@property (strong, nonatomic) BRPersistenceController *persistenceController;
@property (strong, nonatomic) CBFServiceController *serviceController;
@property (strong, nonatomic) CBFCoreDataController *coreDataController;
@property (strong, nonatomic) CBFUser *user;
@property (strong, nonatomic) NSString *sessionToken;

@end


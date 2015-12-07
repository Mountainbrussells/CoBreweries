//
//  CBFLogInViewController.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/2/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRPersistenceController.h"
#import "CBFServiceController.h"
#import "CBFCoreDataController.h"
#import "STKeychain.h"

@interface CBFLogInViewController : UIViewController

@property (strong, nonatomic) CBFServiceController *serviceController;
@property (strong, nonatomic) CBFCoreDataController *coreDataController;
@property (strong, nonatomic) BRPersistenceController *persistenceController;


@end

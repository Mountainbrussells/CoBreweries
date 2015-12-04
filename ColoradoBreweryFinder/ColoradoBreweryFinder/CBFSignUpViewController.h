//
//  CBFSignUpViewController.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/3/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBFServiceController.h"
#import "BRPersistenceController.h"
#import "CBFCoreDataController.h"

@interface CBFSignUpViewController : UIViewController

@property (strong, nonatomic) CBFServiceController *serviceController;
@property (strong, nonatomic) BRPersistenceController *persistenceController;
@property (strong, nonatomic) CBFCoreDataController *coreDataController;


@end

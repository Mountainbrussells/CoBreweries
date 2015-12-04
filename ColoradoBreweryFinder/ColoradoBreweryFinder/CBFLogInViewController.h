//
//  CBFLogInViewController.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/2/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRPersistenceController.h"

@class CBFServiceController;

@interface CBFLogInViewController : UIViewController

@property (strong, nonatomic) CBFServiceController *serviceController;
@property (strong, nonatomic) BRPersistenceController *persistenceController;

@end

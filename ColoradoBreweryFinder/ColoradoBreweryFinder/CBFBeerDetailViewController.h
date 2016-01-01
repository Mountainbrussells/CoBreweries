//
//  CBFBeerDetailViewController.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/31/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CBFCoreDataController.h"
#import "CBFServiceController.h"


@interface CBFBeerDetailViewController : UITableViewController

@property (strong, nonatomic) NSManagedObjectID *userObjectId;
@property (strong, nonatomic) NSManagedObjectID *beerObjectId;

@property (strong, nonatomic) CBFCoreDataController *coreDataController;
@property (strong, nonatomic) CBFServiceController *serviceController;

@end

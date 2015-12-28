//
//  CBFBreweryDetailController.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/15/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CBFCoreDataController.h"
#import "CBFBrewery.h"
#import "CBFUser.h"

@interface CBFBreweryDetailController : UITableViewController


@property (strong, nonatomic) NSManagedObjectID *userdObjectId;
@property (strong, nonatomic) NSManagedObjectID *breweryObjectId;

@property (strong, nonatomic) CBFCoreDataController *coreDataController;
@property (strong, nonatomic) UIImage *logoImage;

@end

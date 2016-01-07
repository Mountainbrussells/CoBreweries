//
//  CBFBreweryMapViewController.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/20/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import "BRPersistenceController.h"
#import "CBFServiceController.h"
#import "CBFCoreDataController.h"





@interface CBFBreweryMapViewController : UIViewController

@property (strong, nonatomic)BRPersistenceController *persistenceController;
@property (strong, nonatomic)CBFServiceController *serviceController;
@property (strong, nonatomic)CBFCoreDataController *coreDataController;
@property (strong, nonatomic)NSManagedObjectID *beerReviewObjectId;




@end

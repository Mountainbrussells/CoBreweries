//
//  CBFBeerReviewDetailViewController.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 1/6/16.
//  Copyright © 2016 Ben Russell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBFServiceController.h"
#import "CBFCoreDataController.h"

#import <CoreData/CoreData.h>


@interface CBFBeerReviewDetailViewController : UIViewController

@property (strong, nonatomic)CBFServiceController *serviceController;
@property (strong, nonatomic)CBFCoreDataController *coredataController;
@property (strong, nonatomic)NSManagedObjectID *beerReviewManagedObjectId;
@end

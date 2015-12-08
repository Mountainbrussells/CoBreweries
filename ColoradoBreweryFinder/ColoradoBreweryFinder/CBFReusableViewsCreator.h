//
//  CBFReusableViewsCreator.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/8/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CBFReusableViewsCreator : NSObject

+ (UIActivityIndicatorView *)createSpinnerViewWithParentController:(UIViewController *)parentVC;

@end

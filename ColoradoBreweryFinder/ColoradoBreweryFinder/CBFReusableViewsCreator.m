//
//  CBFReusableViewsCreator.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/8/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "CBFReusableViewsCreator.h"

@implementation CBFReusableViewsCreator

+ (UIActivityIndicatorView *)createSpinnerViewWithParentController:(UIViewController *)parentVC
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setFrame:CGRectMake(0, 0, 100, 100)];
    spinner.transform = CGAffineTransformMakeScale(2, 2);
    [spinner setColor:[UIColor darkGrayColor]];
    [parentVC.view addSubview:spinner];
    [spinner setCenter:CGPointMake(parentVC.view.center.x, 150)];
    
    return spinner;
}

@end

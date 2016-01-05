//
//  CBFFlipSegue.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/30/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "CBFFlipSegue.h"

@implementation CBFFlipSegue

-(void)perform
{
    
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    
    [UIView transitionWithView:src.navigationController.view duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        if(src.navigationController.viewControllers.firstObject == dst) {
                            [dst.navigationController popViewControllerAnimated:NO];
                        } else {
                            [src.navigationController pushViewController:dst animated:NO];
                        }
                    }
                    completion:NULL];
    
}

@end

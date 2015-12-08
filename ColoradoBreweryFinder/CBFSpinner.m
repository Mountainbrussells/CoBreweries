//
//  CBFSpinner.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/7/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "CBFSpinner.h"

@implementation CBFSpinner

-(id)init
{
    self = [super init];
    
    if (self) {
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [self setFrame:CGRectMake(0, 0, 100, 100)];
        self.transform = CGAffineTransformMakeScale(2, 2);
        [self setColor:[UIColor darkGrayColor]];
    }
    
    return self;
}

@end

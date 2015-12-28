//
//  CBFBreweryLocation.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/21/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "CBFBreweryLocation.h"

@interface CBFBreweryLocation ()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@end

@implementation CBFBreweryLocation

- (id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init]) {
        if ([name isKindOfClass:[NSString class]]) {
            self.name = name;
        } else {
            self.name = @"Brewey";
        }
        self.address = address;
        self.coordinate = coordinate;
    }
    return self;
}

- (NSString *)title
{
    return  _name;
}

- (NSString *)subtitle
{
    return _address;
}

- (CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}

@end

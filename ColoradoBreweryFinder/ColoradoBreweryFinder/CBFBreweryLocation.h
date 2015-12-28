//
//  CBFBreweryLocation.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/21/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CBFBreweryLocation : NSObject <MKAnnotation>

- (id)initWithName:(NSString *)name address:(NSString *)address coordinate:(CLLocationCoordinate2D)coordinate;

@end

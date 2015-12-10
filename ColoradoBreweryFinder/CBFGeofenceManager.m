//
//  CBFGeofenceManager.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/10/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "CBFGeofenceManager.h"
#import <CoreLocation/CoreLocation.h>

static double const kCLLocationHorizontalAccuracyDistance = 20;
static double const kCLLocationMinimumDistanceFromlastLocation = 804;


@interface CBFGeofenceManager () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@end

@implementation CBFGeofenceManager

+ (id)sharedManager
{
    static CBFGeofenceManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    
    return sharedInstance;
}

- (void)setUpLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    NSLog(@"Current Location: %@", [locations lastObject]);
    CLLocation *lastlocation = [locations lastObject];
    BOOL accuracyGood = lastlocation.horizontalAccuracy < kCLLocationHorizontalAccuracyDistance;
    if (!self.location) {
        if (accuracyGood) {
            [defaultCenter postNotificationName:@"LocationWillChange" object:self];
            self.location = lastlocation;
            [self setCurrentState:CBFGeofenceManagerLocationLocated];
            [defaultCenter postNotificationName:@"LocationDidChange" object:self];
        } else {
            [self setCurrentState:CBFGeofenceManagerLocationLocating];
            [self.locationManager requestLocation];
        }
    } else {
        double distanceFromLastLocation = [lastlocation distanceFromLocation:self.location];
        BOOL isEnoughDistance = distanceFromLastLocation > kCLLocationMinimumDistanceFromlastLocation;
        if (accuracyGood) {
            if (isEnoughDistance) {
                [defaultCenter postNotificationName:@"LocationWillChange" object:self];
                self.location = lastlocation;
                [self setCurrentState:CBFGeofenceManagerLocationLocated];
                [defaultCenter postNotificationName:@"LocationDidChange" object:self];
            }
        } else {
            if (isEnoughDistance) {
                [self.locationManager requestLocation];
                [self setCurrentState:CBFGeofenceManagerLocationOutOfArea];
            }
            
        }
        
    }
    
}

@end

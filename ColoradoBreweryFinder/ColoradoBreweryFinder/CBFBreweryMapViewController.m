//
//  CBFBreweryMapViewController.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/20/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "CBFBreweryMapViewController.h"
#import "CBFGeofenceManager.h"

@interface CBFBreweryMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *breweryMapView;
@property (strong, nonatomic)CBFGeofenceManager *geofenceManager;
@property (strong, nonatomic)CLLocation *location;


@end

@implementation CBFBreweryMapViewController

- (void)viewDidLoad
{
    self.geofenceManager = [CBFGeofenceManager sharedManager];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(prepareForLocationUpdate:) name:@"LocationWillChange" object:self.geofenceManager];
    [defaultCenter addObserver:self selector:@selector(updateLocation:) name:@"LocationDidChange" object:self.geofenceManager];
    
    self.breweryMapView.showsUserLocation = YES;

    self.breweryMapView.delegate = self;
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
    
}


- (void)prepareForLocationUpdate:(NSNotification *)notification
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"==========================");
}

- (void)updateLocation:(NSNotification *)notification
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"==========================");
    //    NSArray *sortedBreweryArray = [self sortedBreweryArray];
    //    NSLog(@"Sorted Brewery Array: %@", sortedBreweryArray);
    NSDictionary *latLonDict = notification.userInfo;
    double latitude = [[latLonDict valueForKey:@"latitude"] doubleValue];
    double longitude = [[latLonDict valueForKey:@"longitude"] doubleValue];
    
    CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    self.location = currentLocation;
    
    
    
    
}

#pragma mark -MapViewDelegates

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    CLLocationCoordinate2D location = [userLocation.location coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 2000, 2000);
    [self.breweryMapView setRegion:region animated:YES];
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end

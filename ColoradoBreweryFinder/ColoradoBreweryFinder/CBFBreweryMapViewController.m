//
//  CBFBreweryMapViewController.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/20/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "CBFBreweryMapViewController.h"
#import "CBFGeofenceManager.h"
#import "CBFBrewery.h"
#import "CBFBreweryLocation.h"
#import "CBFBreweryDetailController.h"

static CLLocationDegrees const kCenterOfMapLattitude = 39.0000;
static CLLocationDegrees const kCenterOfMapLongitude = -105.782067;
static double const kDefaultMapWidth = 500000;
static double const kDefaultMapHieght = 500000;

@interface CBFBreweryMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *breweryMapView;
@property (strong, nonatomic)CBFGeofenceManager *geofenceManager;
@property (strong, nonatomic)CLLocation *location;
@property (strong, nonatomic)NSArray *breweries;
@property (nonatomic, assign) BOOL mapCenteredOnUser;



@end

@implementation CBFBreweryMapViewController

- (void)viewDidLoad
{
    self.geofenceManager = [CBFGeofenceManager sharedManager];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(prepareForLocationUpdate:) name:@"LocationWillChange" object:self.geofenceManager];
    [defaultCenter addObserver:self selector:@selector(updateLocation:) name:@"LocationDidChange" object:self.geofenceManager];
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(kCenterOfMapLattitude, kCenterOfMapLongitude);
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, kDefaultMapHieght, kDefaultMapWidth);
        [self.breweryMapView setRegion:region animated:YES];
        self.mapCenteredOnUser = YES;
    }
    
    self.breweryMapView.showsUserLocation = YES;

    self.breweryMapView.delegate = self;
    
    self.breweries = [self.coreDataController fetchBreweries];
    
    [self plotBreweryLocations:self.breweries];
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

- (void)plotBreweryLocations:(NSArray *)breweryArray;
{
    for (CBFBrewery *brewery in breweryArray) {
        NSNumber *latitude = brewery.lattitude;
        NSNumber *longitude = brewery.longitude;
        NSString *name = brewery.name;
        NSString *address = brewery.address;
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;
        CBFBreweryLocation *breweryAnnotation = [[CBFBreweryLocation alloc] initWithName:name address:address coordinate:coordinate];
        
        [self.breweryMapView addAnnotation:breweryAnnotation];
    }
}

- (void)showDetails:(id)sender
{
    [self performSegueWithIdentifier:@"ShowDetailsFromMapSegue" sender:self];
}

#pragma mark -MapViewDelegates

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (!self.mapCenteredOnUser) {
        
        // WHY DOESN"T THIS WORK? location.latitude returns a hex instead of the latitude.
        CLLocationCoordinate2D location = [userLocation.location coordinate];

        if (location.latitude > 41 || location.latitude < 37 || location.longitude < -108 || location.longitude > -102) {
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake(kCenterOfMapLattitude, kCenterOfMapLongitude);
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, kDefaultMapHieght, kDefaultMapWidth);
            [self.breweryMapView setRegion:region animated:YES];
            self.mapCenteredOnUser = YES;
        } else {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 4000, 4000);
        [self.breweryMapView setRegion:region animated:YES];
        self.mapCenteredOnUser = YES;
        }
    }

    
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"BreweryLocation";
    if ([annotation isKindOfClass:[CBFBreweryLocation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self.breweryMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            UIButton *rightCallout = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightCallout addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView = rightCallout;
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual:@"ShowDetailsFromMapSegue"]) {
    CBFBrewery *selectedBrewery;
    NSArray *selectedAnnotations = self.breweryMapView.selectedAnnotations;
    if (selectedAnnotations.count > 0) {
        CBFBreweryLocation *selectedLocation = selectedAnnotations[0];
        NSString *breweryname = [selectedLocation title];
        
        for (CBFBrewery *brewery in self.breweries) {
            if ([brewery.name isEqualToString:breweryname]){
                selectedBrewery = brewery;
            }
        }
    }
    
    CBFBreweryDetailController *detailVC = [segue destinationViewController];
    detailVC.breweryObjectId = selectedBrewery.objectID;
    detailVC.coreDataController = self.coreDataController;
    detailVC.serviceController = self.serviceController;
    detailVC.userdObjectId = self.userObjectId;
    }
    
}

@end

//
//  ViewController.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 11/19/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "ViewController.h"
#import "CBFBeer.h"
#import "CBFBrewery.h"
#import <CoreLocation/CoreLocation.h>



@interface ViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) NSArray *breweries;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.userNameLabel.text = self.user.userName;
    self.breweries = [self.coreDataController fetchBreweries];
    NSLog(@"Breweries for main VC:%@", self.breweries);
    [self setUpLocationManager];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Location Manager Delegate

- (void)setUpLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 20;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"Current Location: %@", [locations lastObject]);
    self.location = [locations lastObject];
    
    NSArray *sortedBreweries = [self sortedBreweryArray];
    NSLog(@"Sorted Brewery Array: %@", sortedBreweries);
}

- (NSArray *)sortedBreweryArray
{
    NSArray *sortedArray;
    sortedArray = [self.breweries sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CBFBrewery *breweryA = (CBFBrewery *)obj1;
        CBFBrewery *breweryB = (CBFBrewery *)obj2;
        
        double breweryALat = [breweryA.lattitude doubleValue];
        double breweryALon = [breweryA.longitude doubleValue];
        CLLocation *aLocation = [[CLLocation alloc] initWithLatitude:breweryALat longitude:breweryALon];
        
        double breweryBLat = [breweryB.lattitude doubleValue];
        double breweryBLon = [breweryB.longitude doubleValue];
        
        CLLocation *bLocation = [[CLLocation alloc] initWithLatitude:breweryBLat longitude:breweryBLon];
        
        double distanceA = [aLocation distanceFromLocation:self.location];
        
        double distanceB = [bLocation distanceFromLocation:self.location];
        
        return [@(distanceA) compare:@(distanceB)];
    }];
    
    return sortedArray;
}
@end

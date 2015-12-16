
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
#import "CBFGeofenceManager.h"
#import "CBFBreweryCell.h"
#import "CBFBreweryDetailController.h"



@interface ViewController () <CLLocationManagerDelegate, NSFetchedResultsControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *breweries;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) CBFGeofenceManager *geofenceManager;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSMutableDictionary *cachedImages;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.breweries = [self.coreDataController fetchBreweries];
    NSLog(@"Breweries for main VC:%@", self.breweries);
    self.geofenceManager = [CBFGeofenceManager sharedManager];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(prepareForLocationUpdate:) name:@"LocationWillChange" object:self.geofenceManager];
    [defaultCenter addObserver:self selector:@selector(updateLocation:) name:@"LocationDidChange" object:self.geofenceManager];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.cachedImages = [[NSMutableDictionary alloc] init];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSArray *sortedArray = [self sortedBreweryArray];
    
    NSLog(@"sortedArray: %@", sortedArray);
    [self.collectionView reloadData];
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

- (NSString *)getDistanceToBreweyFromCurrentLocation:(CLLocation *)breweryLocation
{
    double distance =  [breweryLocation distanceFromLocation:self.location];
    double distanceInMiles = distance * 0.00062137;
    
    NSString *distanceString = [NSString stringWithFormat:@"%.1f", distanceInMiles];
    return distanceString;
    
}



# pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.breweries.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CBFBreweryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"breweryCell" forIndexPath:indexPath];
    NSArray *sortedArray = [self sortedBreweryArray];
    CBFBrewery *brewery = sortedArray[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.cornerRadius = 10.0;
    cell.layer.masksToBounds = YES;
    cell.breweryName.text = brewery.name;
    
    NSString *distance = [self getDistanceToBreweyFromCurrentLocation:brewery.location];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%@ miles", distance];
    
    NSString *identifier = [NSString stringWithFormat:@"Cell%d", indexPath.row];
    
    if ([self.cachedImages objectForKey:identifier] != nil) {
        cell.logoImageView.image = [self.cachedImages objectForKey:identifier];
    } else {
        
        //    UIImage *logoImage = [UIImage imageWithData:brewery.logo];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSString *urlString = brewery.logoURL;
            NSURL *photoURL = [NSURL URLWithString:urlString];
            NSData *data = [NSData dataWithContentsOfURL:photoURL];
            UIImage *image = [[UIImage alloc] initWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.logoImageView.image = image;
                    [self.cachedImages setValue:image forKey:identifier];
                    [cell setNeedsLayout];
                });
            }
            
        });
        
    }
    //    cell.logoImageView.image = logoImage;
    
    
    
    return cell;
    
}




#pragma mark - Segue Preperations


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showBreweryDetailView"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        
        CBFBreweryDetailController *detailVC = [segue destinationViewController];
        NSArray *sortedArray = [self sortedBreweryArray];
        CBFBrewery *brewery = sortedArray[indexPath.row];
        // TODO:  detailVC.breweryObjectId is comming back as an unrecognized selector
        detailVC.brewery = brewery;
        detailVC.user = self.user;
        detailVC.coreDataController = self.coreDataController;
        
        
    }
    
    
    
}


@end

//
//  CBFBreweryDetailController.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/15/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "CBFBreweryDetailController.h"
#import "CBFBreweryHeaderCell.h"
#import "CBFBeerCell.h"
#import "CBFBeer.h"
#import "CBFBeerDetailViewController.h"
#import "CBFBrewery.h"
#import "CBFBreweryRating.h"


@interface CBFBreweryDetailController ()


@property (strong, nonatomic) CBFBrewery *brewery;
@property (strong, nonatomic) CBFUser *user;
@property (strong, nonatomic) NSArray *beers;

@end

@implementation CBFBreweryDetailController
- (void)viewDidLoad
{
    self.brewery = [self.coreDataController fetchBreweryWithNSManagedObjectId:self.breweryObjectId];
    self.user = [self.coreDataController fetchUserWithId:self.userdObjectId];
    self.beers = [self.brewery.beers allObjects];
    [self.tableView reloadData];
    
    [self becomeFirstResponder];
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return self.beers.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ( indexPath.section == 0) {
        CBFBreweryHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"breweryHeaderCell"];
        cell.breweryNameLabel.text = self.brewery.name;
        cell.address = self.brewery.address;
        cell.phoneNumber = self.brewery.phoneNumber;
        cell.websiteURL = self.brewery.websiteURL;
        cell.rateBreweryView.hidden = true;
        cell.serviceController = self.serviceController;
        //needs to be managedObjectId
        cell.brewery = self.brewery;
        double longintude = [self.brewery.longitude doubleValue];
        cell.longitude = longintude;
        double lattitude = [self.brewery.lattitude doubleValue];
        cell.lattitude = lattitude;
        cell.user = self.user;
        cell.coreDataController = self.coreDataController;
        if (self.brewery.ratings.count > 0) {
            float averageRating = [self.brewery calculateAverageRating];
            NSString *averageRatingString = [NSString stringWithFormat:@"%0.0f", averageRating];
            cell.averageRatingLabel.text = averageRatingString;
        } else {
            cell.averageRatingLabel.text = @"NR";
        }
        
        if (!self.logoImage) {
            
            UIImage *image = [self.serviceController getImageWithURL:self.brewery.logoURL completion:^(UIImage *image) {
                cell.logoImageView.image = image;
                self.logoImage = image;
                [self.tableView reloadData];
            }];
            cell.logoImageView.image = image;
            
            
            
        } else {
            cell.logoImageView.image = self.logoImage;
        }
        return cell;
    }
    
    if (indexPath.section == 1) {
        CBFBeerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"beerCell"];
        CBFBeer *beer = self.beers[indexPath.row];
        cell.beerNameLabel.text = beer.name;
        cell.beerStyleLabel.text = beer.style;
        cell.beerABVLabel.text = [NSString stringWithFormat:@"ABV: %@%%", beer.abv];
        cell.beerIBULabel.text = [NSString stringWithFormat:@"IBUs: %@", beer.ibus];
        float averageRating = [beer calculateAverageRating];
        
        if (beer.ratings.count > 0) {
            NSString *averageRatingString = [NSString stringWithFormat:@"%0.0f", averageRating];
            cell.ratingLabel.text = averageRatingString;
        } else {
            cell.ratingLabel.text = @"NR";
        }
        
        return cell;
    } else {
        return nil;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 312;
    } else {
        return 80;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 1){
        CGFloat width = self.view.frame.size.width;
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 80)];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width - 20, 40)];
        headerLabel.text = [NSString stringWithFormat:@"%@'s Beers", self.brewery.name];
        headerLabel.font = [UIFont boldSystemFontOfSize:15];
        headerLabel.backgroundColor = [UIColor lightGrayColor];
        [headerLabel setTextAlignment:NSTextAlignmentCenter];
        [containerView addSubview:headerLabel];
        
        return containerView;
    } else {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    } else {
        return 80;
    }
}

- (void)refreshTable;
{
    [self.tableView reloadData];
}

- (void) rateBrewery:(NSNumber *) rating {
    NSManagedObjectID *breweryId = self.brewery.objectID;
    
    __block CBFBreweryRating *existingRating = nil;
    [self.user.breweryRatings enumerateObjectsUsingBlock:^(CBFBreweryRating *breweryRating, BOOL * _Nonnull stop) {
        if([[[breweryRating brewery] objectID] isEqual:breweryId]) {
            existingRating = breweryRating;
            *stop = YES;
        }
    }];
    if (existingRating) {
        [self.serviceController updateBreweryRating:existingRating.objectID withValue:[rating integerValue] completion:^(NSError *error) {
            [self refreshTable];
        }];
        
    } else {
        [self.serviceController createBreweryRating:[rating integerValue] breweryId:breweryId completion:^(NSManagedObjectID *ratingObjectID, NSError *error) {
            [self refreshTable];
        }];
        
    }
}


# pragma mark - segue preperations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showBeerDetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CBFBeerDetailViewController *destinationVC = [segue destinationViewController];
        CBFBeer *selectedBeer = self.beers[indexPath.row];
        destinationVC.userObjectId = self.userdObjectId;
        destinationVC.beerObjectId = selectedBeer.objectID;
        destinationVC.coreDataController = self.coreDataController;
        destinationVC.serviceController = self.serviceController;
    }
}


@end

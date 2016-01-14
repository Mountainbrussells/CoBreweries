//
//  CBFBeerDetailViewController.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/31/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "CBFBeerDetailViewController.h"
#import "CBFBeer.h"
#import "CBFUser.h"
#import "CBFBeerRating.h"
#import "CBFBeerHeaderCell.h"
#import "CBFBeerReviewCell.h"
#import "CBFBeerRating.h"
#import "CBFBeerRatingViewController.h"
#import "CBFBeerReviewDetailViewController.h"

@interface CBFBeerDetailViewController ()

@property (strong, nonatomic) CBFBeer *beer;
@property (strong, nonatomic) CBFUser *user;
@property (strong, nonatomic) NSArray *beerReviewsArray;

@end

@implementation CBFBeerDetailViewController

- (void)viewDidLoad
{
    self.beer = [self.coreDataController fetchBeerWithManagedObjectId:self.beerObjectId];
    self.user = [self.coreDataController fetchUserWithId:self.userObjectId];
    self.beerReviewsArray = [self.coreDataController fetchBeerReviewsForBeer:self.beer];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(refreshTableView:) name:@"newReviewAdded" object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.beerReviewsArray = [self.beer.ratings allObjects];
        [self.tableView reloadData];
    });
}

- (void)refreshTableView:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.beerReviewsArray = [self.beer.ratings allObjects];
        [self.tableView reloadData];
    });
    
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
        return self.beerReviewsArray.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ( indexPath.section == 0) {
        CBFBeerHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"beerHeaderCell"];
        float averageRating = [self.beer calculateAverageRating];
        if (averageRating == 0) {
            cell.averageRatingLabel.text = @"No Ratings Yet";
        } else {
            NSString *avgRatingString = [NSString stringWithFormat:@"Average Rating: %0.0f", averageRating];
            cell.averageRatingLabel.text = avgRatingString;
        }
        cell.beerNameLabel.text = self.beer.name;
       
        return cell;
    }
    
    if (indexPath.section == 1) {
        CBFBeerReviewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"beerReviewCell"];
        CBFBeerRating *rating = self.beerReviewsArray[indexPath.row];
        
        cell.userNameLabel.text = rating.username;
        float ratingValue = [rating.rating floatValue];
        NSString *ratingValueString = [NSString stringWithFormat:@"Rating: %0.0f", ratingValue];
        cell.ratingLabel.text = ratingValueString;
        cell.notesTextView.text = rating.review;
        return cell;
        
    } else {
        return nil;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 150;
    } else {
        return 100;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 1){
        CGFloat width = self.view.frame.size.width;
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 80)];
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, width - 20, 40)];
        headerLabel.text = [NSString stringWithFormat:@"%@'s Reviews", self.beer.name];
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

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showRateBeerVC"]) {
        
        CBFBeerRatingViewController *destinationVC = [segue destinationViewController];
        destinationVC.userManagedObjectId = self.user.objectID;
        destinationVC.beerManagedObjectId = self.beer.objectID;
        destinationVC.serviceController = self.serviceController;
        destinationVC.coredataController = self.coreDataController;
    }
    
    if ([segue.identifier isEqualToString:@"showBeerReviewDetailVC"]) {
        CBFBeerReviewDetailViewController *destinationVC = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CBFBeerRating *rating = self.beerReviewsArray[indexPath.row];
        destinationVC.beerReviewManagedObjectId = rating.objectID;
        destinationVC.coredataController = self.coreDataController;
    }
}

-(IBAction)prepareForUnwindFromBeerRating:(UIStoryboardSegue *)segue {
}
@end

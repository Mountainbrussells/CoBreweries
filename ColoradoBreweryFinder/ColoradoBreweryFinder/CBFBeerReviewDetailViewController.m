//
//  CBFBeerReviewDetailViewController.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 1/6/16.
//  Copyright © 2016 Ben Russell. All rights reserved.
//

#import "CBFBeerReviewDetailViewController.h"

@interface CBFBeerReviewDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *beerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UITextView *reviewTextView;

@end

@implementation CBFBeerReviewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CBFBeerRating *rating = [self.coredataController fetchBeerRatingWithNSManagedObjectId:self.beerReviewManagedObjectId];
    self.beerNameLabel.text = rating.beer.name;
    self.ratingLabel.text = [NSString stringWithFormat:@"%@", rating.rating];
    self.reviewTextView.text = rating.review;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

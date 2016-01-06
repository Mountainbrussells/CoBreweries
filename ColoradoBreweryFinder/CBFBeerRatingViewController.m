//
//  CBFBeerRatingViewController.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 1/6/16.
//  Copyright © 2016 Ben Russell. All rights reserved.
//

#import "CBFBeerRatingViewController.h"
#import "CBFUser.h"
#import "CBFBeer.h"

@interface CBFBeerRatingViewController ()

@property (strong, nonatomic) CBFUser *user;
@property (strong, nonatomic)CBFBeer *beer;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;

@end

@implementation CBFBeerRatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.beer = [self.coredataController fetchBeerWithManagedObjectId:self.beerManagedObjectId];
    self.user = [self.coredataController fetchUserWithId:self.userManagedObjectId];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveButton:(id)sender {
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

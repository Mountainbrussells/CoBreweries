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
#import "CBFBeerRating.h"

@interface CBFBeerRatingViewController ()<UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) CBFUser *user;
@property (strong, nonatomic) CBFBeer *beer;
@property (strong, nonatomic) CBFBeerRating *rating;
@property (assign) BOOL alreadyRatedBeer;
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
    self.noteTextView.delegate = self;
    
    self.rating = [self.coredataController fetchBeerRatingForBeer:self.beer andUser:self.user];
    if (self.rating) {
        self.noteTextView.text = self.rating.review;
        self.alreadyRatedBeer = true;
    } else {
        self.noteTextView.text = @"Make notes here";
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveButton:(id)sender {
    if (self.alreadyRatedBeer) {
        [self.serviceController updateBeerRating:self.rating withValue:1 andNote:self.noteTextView.text completion:nil];
    } else {
        [self.serviceController createBeerRating:@"1" withNote:self.noteTextView.text beerId:self.beer.uid completion:nil];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.noteTextView endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
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

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
@property (strong, nonatomic) NSArray *ratingButtonsArray;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (strong, nonatomic) NSString *ratingString;

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
        if ([self.noteTextView.text isEqualToString:@""]) {
            self.noteTextView.text = @"Add note here";
            self.noteTextView.editable = YES;
            self.noteTextView.textColor = [UIColor lightGrayColor];
        }
    }
    
    self.ratingButtonsArray = [NSArray arrayWithObjects:self.buttonOne, self.buttonTwo, self.buttonThree, self.buttonFour, nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveButton:(id)sender {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    if (self.alreadyRatedBeer) {
        NSInteger ratingInt = [self.ratingString integerValue];
        [self.serviceController updateBeerRating:self.rating withValue:ratingInt andNote:self.noteTextView.text completion:^(NSError *error) {
            [notificationCenter postNotificationName:@"newReviewAdded" object:nil];
        }];
    } else {
        [self.serviceController createBeerRating:self.ratingString withNote:self.noteTextView.text beerId:self.beer.uid completion:^(NSManagedObjectID *ratingObjectID, NSError *error) {
            NSLog(@"===New Rating: %@", [self.coredataController fetchBeerRatingWithNSManagedObjectId:ratingObjectID]);
            [notificationCenter postNotificationName:@"newReviewAdded" object:nil];
        }];
    }
    
}

- (IBAction)buttonOne:(id)sender {
    self.buttonOne.backgroundColor = [UIColor lightGrayColor];
    self.buttonTwo.backgroundColor = [UIColor clearColor];
    self.buttonThree.backgroundColor = [UIColor clearColor];
    self.buttonFour.backgroundColor = [UIColor clearColor];
    self.ratingString = @"1";
    
}
- (IBAction)buttonTwo:(id)sender {
    self.buttonOne.backgroundColor = [UIColor clearColor];
    self.buttonTwo.backgroundColor = [UIColor lightGrayColor];
    self.buttonThree.backgroundColor = [UIColor clearColor];
    self.buttonFour.backgroundColor = [UIColor clearColor];
    self.ratingString = @"2";
}

- (IBAction)buttonThree:(id)sender {
    self.buttonOne.backgroundColor = [UIColor clearColor];
    self.buttonTwo.backgroundColor = [UIColor clearColor];
    self.buttonThree.backgroundColor = [UIColor lightGrayColor];
    self.buttonFour.backgroundColor = [UIColor clearColor];
    self.ratingString = @"3";
}
- (IBAction)buttonFour:(id)sender {
    self.buttonOne.backgroundColor = [UIColor clearColor];
    self.buttonTwo.backgroundColor = [UIColor clearColor];
    self.buttonThree.backgroundColor = [UIColor clearColor];
    self.buttonFour.backgroundColor = [UIColor lightGrayColor];
    self.ratingString = @"4";
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.noteTextView endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - Text View Delegates

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.noteTextView.text isEqualToString:@"Add note here"]) {
        self.noteTextView.text = @"";
        self.noteTextView.textColor = [UIColor blackColor];
    }
    [self.noteTextView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.noteTextView.text isEqualToString:@""]) {
        self.noteTextView.text = @"Add note here";
        self.noteTextView.textColor = [UIColor lightGrayColor];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
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

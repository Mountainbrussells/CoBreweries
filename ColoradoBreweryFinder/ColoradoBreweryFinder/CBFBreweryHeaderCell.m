//
//  CBFBreweryHeaderCell.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/15/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "CBFBreweryHeaderCell.h"
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import "CBFBreweryCell.h"
#import "CBFBreweryRating.h"

@interface CBFBreweryHeaderCell ()
@property (weak, nonatomic) IBOutlet UILabel *rateBreweryViewHeaderLabel;
@property (weak, nonatomic) IBOutlet UIButton *rateButtonOne;
@property (weak, nonatomic) IBOutlet UIButton *rateButtonTwo;
@property (weak, nonatomic) IBOutlet UIButton *rateButtonThree;
@property (weak, nonatomic) IBOutlet UIButton *rateButtonFour;

@end

@implementation CBFBreweryHeaderCell



- (IBAction)rateBrewery:(id)sender {
    NSLog(@"==============================");
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"==============================");
//    NSArray *ratingsArray = [self.coreDataController fetchBreweryRatingsForBrewery:self.brewery];
//    for (CBFBreweryRating *rating in ratingsArray) {
//        if (rating.user == self.user) {
//            
//            self.rateBreweryViewHeaderLabel.text = @"Rate Brewery Again";
//        }
//    }
    
    if ([self alreadyRated]) {
        self.rateBreweryViewHeaderLabel.text = @"Rate Brewery Again";
    }
    
    self.rateBreweryView.hidden = false;
}
- (IBAction)cancelRating:(id)sender {
    self.rateBreweryView.hidden = true;
}

- (IBAction)directionsButton:(id)sender {
    NSLog(@"==============================");
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"==============================");
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [[self mapItem] openInMapsWithLaunchOptions:launchOptions];
}

- (IBAction)phonebutton:(id)sender {
    NSLog(@"==============================");
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"==============================");
    
    NSString *url = @"telprompt://";
    NSString *phoneUrlString = [url stringByAppendingString:self.phoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneUrlString];
    
    [[UIApplication sharedApplication] openURL:phoneURL];
}

- (IBAction)websiteButton:(id)sender {
    NSLog(@"==============================");
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"==============================");
    NSString *url = @"http://";
    NSString *websiteURLString = [url stringByAppendingString:self.websiteURL];
    NSURL *websiteURL = [NSURL URLWithString:websiteURLString];
    [[UIApplication sharedApplication] openURL:websiteURL];
}



- (IBAction)rateBreweryWithRating:(id)sender {
    
    NSNumber *rating = nil;
    UIButton *sendingButton = (UIButton *)sender;
    NSString *senderNumber = sendingButton.titleLabel.text;
    NSNumberFormatter *formattedNumber = [[NSNumberFormatter alloc] init];
    rating = [formattedNumber numberFromString:senderNumber];
    
    [[UIApplication sharedApplication] sendAction:@selector(rateBrewery:) to:nil from:rating forEvent:nil];
    self.rateBreweryView.hidden = true;
 
}



- (MKMapItem*)mapItem {
    // TODO: Refactor kABPersonAddressStreetKey
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.lattitude;
    coordinate.longitude = self.longitude;
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.breweryNameLabel.text;
    
    return mapItem;
}

- (CBFBreweryRating *)alreadyRated
{
    NSArray *ratingsArray = [self.coreDataController fetchBreweryRatingsForBrewery:self.brewery];
    for (CBFBreweryRating *rating in ratingsArray) {
        if (rating.user == self.user) {
            
            return rating;
        }
    }
    return nil;
}

@end

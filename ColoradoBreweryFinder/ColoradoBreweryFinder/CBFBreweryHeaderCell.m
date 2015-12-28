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

@implementation CBFBreweryHeaderCell
- (IBAction)rateBrewery:(id)sender {
    NSLog(@"==============================");
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"==============================");
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

@end

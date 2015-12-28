//
//  CBFBreweryDetailController.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/15/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "CBFBreweryDetailController.h"
#import "CBFBreweryHeaderCell.h"




@interface CBFBreweryDetailController ()

@property (strong, nonatomic) NSArray *beersArray;
@property (strong, nonatomic) CBFBrewery *brewery;
@property (strong, nonatomic) CBFUser *user;

@end

@implementation CBFBreweryDetailController
- (void)viewDidLoad
{
    self.brewery = [self.coreDataController fetchBreweryWithNSManagedObjectId:self.breweryObjectId];
    self.user = [self.coreDataController fetchUserWithId:self.userdObjectId];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section == 0) {
        return 1;
    } else if (section == 2) {
        return self.beersArray.count;
    } else {
        return 4;
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
        double longintude = [self.brewery.longitude doubleValue];
        cell.longitude = longintude;
        double lattitude = [self.brewery.lattitude doubleValue];
        cell.lattitude = lattitude;
        
        if (!self.logoImage) {
            
            // TODO: Dispatch Asynch
            NSString *urlString = self.brewery.logoURL;
            NSURL *photoURL = [NSURL URLWithString:urlString];
            NSData *data = [NSData dataWithContentsOfURL:photoURL];
            UIImage *image = [[UIImage alloc] initWithData:data];
            cell.logoImageView.image = image;
            

            
        } else {
            cell.logoImageView.image = self.logoImage;
        }
        return cell;
    }
    
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.textLabel.text = @"Beer";
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

@end

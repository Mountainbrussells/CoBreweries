//
//  CBFBreweryHeaderCell.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/15/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBFBreweryHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *breweryNameLabel;
@property (weak, nonatomic) IBOutlet UIView *logoImageView;
@property (weak, nonatomic) IBOutlet UIView *distancelabel;

@property (strong, nonatomic)NSString *address;
@property (strong, nonatomic)NSString *phoneNumber;
@property (strong, nonatomic)NSString *websiteURL;

@end

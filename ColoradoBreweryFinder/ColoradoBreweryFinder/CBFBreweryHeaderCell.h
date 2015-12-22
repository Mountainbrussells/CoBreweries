//
//  CBFBreweryHeaderCell.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/15/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBFBreweryHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *breweryNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (strong, nonatomic)NSString *address;
@property (strong, nonatomic)NSString *phoneNumber;
@property (strong, nonatomic)NSString *websiteURL;
@property (assign, nonatomic)double lattitude;
@property (assign, nonatomic)double longitude;

@end

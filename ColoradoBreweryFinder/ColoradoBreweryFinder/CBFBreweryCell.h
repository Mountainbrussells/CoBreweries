//
//  CBFBreweryCell.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/11/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBFBrewery;

@interface CBFBreweryCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *breweryName;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@property (strong, nonatomic) CBFBrewery *brewery;

@end

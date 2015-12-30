//
//  CBFBeerCell.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/30/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBFBeerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *beerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *beerStyleLabel;
@property (weak, nonatomic) IBOutlet UILabel *beerABVLabel;
@property (weak, nonatomic) IBOutlet UILabel *beerIBULabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@end

//
//  CBFBeerReviewCell.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 1/4/16.
//  Copyright © 2016 Ben Russell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBFBeerReviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;

@property (weak, nonatomic) IBOutlet UITextView *notesTextView;


@end

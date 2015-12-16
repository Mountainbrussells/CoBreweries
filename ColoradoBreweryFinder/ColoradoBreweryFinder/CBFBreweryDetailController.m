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

@end

@implementation CBFBreweryDetailController

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
        return 0;
    }
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

@end

//
//  ViewController.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 11/19/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "ViewController.h"
#import "CBFBeer.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (strong, nonatomic) NSArray *breweries;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.userNameLabel.text = self.user.userName;
    self.breweries = [self.coreDataController fetchBreweries];
    NSLog(@"Breweries for main VC:%@", self.breweries);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

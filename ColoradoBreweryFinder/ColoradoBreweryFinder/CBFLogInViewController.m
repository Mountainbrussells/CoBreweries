//
//  CBFLogInViewController.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/2/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "CBFLogInViewController.h"
#import "CBFUser.h"
#import "CBFServiceController.h"


@interface CBFLogInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) CBFUser *user;




@end

@implementation CBFLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logInPressed:(id)sender {
    
    if (self.userNameTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        NSString *userName = self.userNameTextField.text;
        NSString *passWord = self.passwordTextField.text;
        NSManagedObjectContext *moc = self.persistenceController.managedObjectContext;
        self.user = [self.serviceController logInUserWithName:userName
                                                  andPassword:passWord
                                       inManagedObjectContext:moc];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"UserLoggedIn"];
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

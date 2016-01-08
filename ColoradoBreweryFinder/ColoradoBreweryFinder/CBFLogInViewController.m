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
#import "ViewController.h"
#import "CBFSignUpViewController.h"
#import "STKeychain.h"





@interface CBFLogInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) CBFUser *user;
@property (strong, nonatomic) NSString *sessionToken;





@end

@implementation CBFLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // TODO:Check if user login is stored
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"StoredUserName"] != nil) {
        NSString *username = [defaults objectForKey:@"StoredUserName"];
        NSError *error;
        NSString *password = [STKeychain getPasswordForUsername:username andServiceName:@"ColoradoBreweryFinder" error:&error];
        if (!password) {
            // Need to have them re-login
        } else {
            //alloc init it  in the viewdidload
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [spinner setFrame:CGRectMake(0, 0, 100, 100)];
            spinner.transform = CGAffineTransformMakeScale(2, 2);
            [spinner setColor:[UIColor darkGrayColor]];
            [self.view addSubview:spinner];
            [spinner setCenter:CGPointMake(self.view.center.x, 150)];
            [self.view bringSubviewToFront:spinner];
            [spinner startAnimating];
            // Login with Parse
            __weak typeof(self) weakSelf = self;
            [self.serviceController logInUserWithName:username
                                          andPassword:password
                                           completion:^(NSManagedObjectID *objectId, NSString *sessionToken, NSError *error) {
                                               __strong typeof(weakSelf) strongSelf = weakSelf;
                                               if (objectId) {
                                                   strongSelf.user =[strongSelf.coreDataController fetchUserWithId:objectId];
                                                   
                                                   
                                                   [spinner stopAnimating];
                                                   if (strongSelf.user) {
                                                       [self.serviceController updateBreweriesWithCompletion:^(NSError *error) {
                                                           [strongSelf.serviceController updateBreweryRatingsWithCompletion:nil];
                                                       }];
                                                       // Need to persist User between launches
                                                       NSError *keychainError;
                                                       if (![STKeychain storeUsername:strongSelf.user.userName andPassword:strongSelf.user.password forServiceName:@"ColoradoBreweryFinder" updateExisting:YES error:&keychainError]) {
                                                           NSLog(@"Username and password not saved for relaunch, error: %@", keychainError);
                                                       }
                                                       [[NSUserDefaults standardUserDefaults] setValue:strongSelf.user.userName forKey:@"StoredUserName"];
                                                       if (sessionToken) {
                                                           strongSelf.sessionToken = sessionToken;
                                                           //What Happens if no sessionToken?
                                                       }
                                                       [strongSelf performSegueWithIdentifier:@"LogInSuccessful" sender:self];
                                                   } else {
                                                       NSLog(@"self.user returned nil");
                                                       [spinner stopAnimating];
                                                       [strongSelf presentLogInFailedAlertWithMessage:@"Please Re-enter User Name and Password or Create a New User"];
                                                   }
                                               }
                                               
                                               
                                               if (error) {
                                                   NSLog(@"Login error: %@", error);
                                                   [spinner stopAnimating];
                                                   [strongSelf presentLogInFailedAlertWithMessage:@"Please Re-enter User Name and Password or Create a New User"];
                                               }
                                               
                                           }];
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logInPressed:(id)sender {
    
    
    
    
    
    if (self.userNameTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner setFrame:CGRectMake(0, 0, 100, 100)];
        spinner.transform = CGAffineTransformMakeScale(2, 2);
        [spinner setColor:[UIColor darkGrayColor]];
        [self.view addSubview:spinner];
        [spinner setCenter:CGPointMake(self.view.center.x, 150)];
        [self.view bringSubviewToFront:spinner];
        
        NSString *userName = self.userNameTextField.text;
        NSString *passWord = self.passwordTextField.text;
        
        [spinner startAnimating];
        
        // Login with Parse
        __weak typeof(self) weakSelf = self;
        [self.serviceController logInUserWithName:userName
                                      andPassword:passWord
                                       completion:^(NSManagedObjectID *objectId, NSString *sessionToken, NSError *error) {
                                           __strong typeof(weakSelf) strongSelf = weakSelf;
                                           if (objectId) {
                                               
                                               strongSelf.user =[strongSelf.coreDataController fetchUserWithId:objectId];
                                               if ([[NSUserDefaults standardUserDefaults] valueForKey:@"BreweryRatingsLoaded"] == NO) {
                                                   [strongSelf.serviceController requestBreweryRatingsWithCompletion:nil];
                                                   [strongSelf.serviceController requestBeersWithCompletion:^(NSError *error) {
                                                       [strongSelf.serviceController requestBeerReviewsWithCompletion:nil];
                                                   }];
                                                   
                                                   [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BreweryRatingsLoaded"];
                                               }
                                               
                                               
                                               [spinner stopAnimating];
                                               if (strongSelf.user) {
                                                   

                                                   // Need to persist User between launches
                                                   NSError *keychainError;
                                                   NSString *user = strongSelf.user.userName;
                                                   NSString *password = strongSelf.user.password;
                                                   if (![STKeychain storeUsername:user andPassword:password forServiceName:@"ColoradoBreweryFinder" updateExisting:YES error:&keychainError]) {
                                                       NSLog(@"Username and password not saved for relaunch, error: %@", keychainError);
                                                   }
                                                   [[NSUserDefaults standardUserDefaults] setValue:strongSelf.user.userName forKey:@"StoredUserName"];
                                                   [self performSegueWithIdentifier:@"LogInSuccessful" sender:strongSelf];
                                               } else {
                                                   NSLog(@"self.user returned nil");
                                                   [spinner stopAnimating];
                                                   [strongSelf presentLogInFailedAlertWithMessage:@"Please Re-enter User Name and Password or Create a New User"];
                                               }
                                           }
                                           
                                           if (sessionToken) {
                                               strongSelf.sessionToken = sessionToken;
                                               //What Happens if no sessionToken?
                                           }
                                           
                                           if (error) {
                                               NSLog(@"Login error: %@", error);
                                               [spinner stopAnimating];
                                               [strongSelf presentLogInFailedAlertWithMessage:@"Please Re-enter User Name and Password or Create a New User"];
                                           }
                                           
                                    }];

    } else {
        [self presentLogInFailedAlertWithMessage:@"Please Enter User Name and Password"];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LogInSuccessful"]) {
        
        UINavigationController *navController = segue.destinationViewController;
        ViewController *mainView = navController.viewControllers[0];
        mainView.user = self.user;
        mainView.persistenceController = self.persistenceController;
        mainView.serviceController = self.serviceController;
        mainView.coreDataController = self.coreDataController;
        mainView.sessionToken = self.sessionToken;
    }
    
    if ([segue.identifier isEqualToString:@"SingUpSegue"]) {
        CBFSignUpViewController *signupView = segue.destinationViewController;
        signupView.persistenceController = self.persistenceController;
        signupView.serviceController = self.serviceController;
        signupView.coreDataController = self.coreDataController;
    }
    
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"LogInSuccessful" ]) {
        
        return NO;
        
    }
    
    return YES;
    
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

- (void)presentLogInFailedAlertWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log In Failed" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                         {
                             self.userNameTextField.text = @"";
                             self.passwordTextField.text = @"";
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                             
                         }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


@end

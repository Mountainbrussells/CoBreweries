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
        if (error) {
            // Need to have them re-login
        } else {
            //set ivar in your view controller
            UIActivityIndicatorView * spinner;
            
            //alloc init it  in the viewdidload
            spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [self.view addSubview:spinner];
            [spinner setFrame:CGRectMake(0, 0, 100, 100)];
            [spinner setCenter:CGPointMake(self.view.center.x, 150)];
            spinner.transform = CGAffineTransformMakeScale(2, 2);
            [spinner setColor:[UIColor darkGrayColor]];
            
            [self.view bringSubviewToFront:spinner];
            [spinner startAnimating];
            // Login with Parse
            [self.serviceController logInUserWithName:username
                                          andPassword:password
                                           completion:^(NSManagedObjectID *objectId, NSString *sessionToken, NSError *error) {
                                               
                                               if (objectId) {
                                                   self.user =[self.coreDataController fetchUserWithId:objectId];
                                                   
                                                   
                                                   [spinner stopAnimating];
                                                   if (self.user) {
                                                       // Need to persist User between launches
                                                       NSError *keychainError;
                                                       if (![STKeychain storeUsername:self.user.userName andPassword:self.user.password forServiceName:@"ColoradoBreweryFinder" updateExisting:YES error:&keychainError]) {
                                                           NSLog(@"Username and password not saved for relaunch, error: %@", keychainError);
                                                       }
                                                       [[NSUserDefaults standardUserDefaults] setValue:self.user.userName forKey:@"StoredUserName"];
                                                       if (sessionToken) {
                                                           self.sessionToken = sessionToken;
                                                           //What Happens if no sessionToken?
                                                       }
                                                       [self performSegueWithIdentifier:@"LogInSuccessful" sender:self];
                                                   } else {
                                                       NSLog(@"self.user returned nil");
                                                       [spinner stopAnimating];
                                                       UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log In Failed" message:@"Please Re-enter User Name and Password or Create a New User" preferredStyle:UIAlertControllerStyleAlert];
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
                                               }
                                               
                                               
                                               if (error) {
                                                   NSLog(@"Login error: %@", error);
                                                   [spinner stopAnimating];
                                                   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log In Failed" message:@"Please Re-enter User Name and Password or Create a New User" preferredStyle:UIAlertControllerStyleAlert];
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
        
        //set ivar in your view controller
        UIActivityIndicatorView * spinner;
        
        //alloc init it  in the viewdidload
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.view addSubview:spinner];
        [spinner setFrame:CGRectMake(0, 0, 100, 100)];
        [spinner setCenter:CGPointMake(self.view.center.x, 150)];
        spinner.transform = CGAffineTransformMakeScale(2, 2);
        [spinner setColor:[UIColor darkGrayColor]];
        
        NSString *userName = self.userNameTextField.text;
        NSString *passWord = self.passwordTextField.text;
        
        [self.view bringSubviewToFront:spinner];
        [spinner startAnimating];
        
        // Login with Parse
        [self.serviceController logInUserWithName:userName
                                      andPassword:passWord
                                       completion:^(NSManagedObjectID *objectId, NSString *sessionToken, NSError *error) {
                                           
                                           if (objectId) {
                                               self.user =[self.coreDataController fetchUserWithId:objectId];
                                               
                                               
                                               [spinner stopAnimating];
                                               if (self.user) {
                                                   // Need to persist User between launches
                                                   NSError *keychainError;
                                                   if (![STKeychain storeUsername:self.user.userName andPassword:self.user.password forServiceName:@"ColoradoBreweryFinder" updateExisting:YES error:&keychainError]) {
                                                       NSLog(@"Username and password not saved for relaunch, error: %@", keychainError);
                                                   }
                                                   [[NSUserDefaults standardUserDefaults] setValue:self.user.userName forKey:@"StoredUserName"];
                                                   [self performSegueWithIdentifier:@"LogInSuccessful" sender:self];
                                               } else {
                                                   NSLog(@"self.user returned nil");
                                                   [spinner stopAnimating];
                                                   UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log In Failed" message:@"Please Re-enter User Name and Password or Create a New User" preferredStyle:UIAlertControllerStyleAlert];
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
                                           }
                                           
                                           if (sessionToken) {
                                               self.sessionToken = sessionToken;
                                               //What Happens if no sessionToken?
                                           }
                                           
                                           if (error) {
                                               NSLog(@"Login error: %@", error);
                                               [spinner stopAnimating];
                                               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log In Failed" message:@"Please Re-enter User Name and Password or Create a New User" preferredStyle:UIAlertControllerStyleAlert];
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
                                           
                                           
                                           
                                       }];
        
        
        
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log In Failed" message:@"Please Enter User Name and Password" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
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
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LogInSuccessful"]) {
        
        ViewController *mainView = segue.destinationViewController;
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


@end

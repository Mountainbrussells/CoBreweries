//
//  CBFSignUpViewController.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/3/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "CBFSignUpViewController.h"
#import "STKeychain.h"
#import "STKeychain.h"
#import "ViewController.h"

@interface CBFSignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *checkPasswordTextField;

@property (strong, nonatomic) CBFUser *user;
@property (strong, nonatomic) NSString *sessionToken;

@end

@implementation CBFSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpPressed:(id)sender {
    
    
    if (self.passwordTextField.text.length > 0 && [self.passwordTextField.text isEqualToString:self.checkPasswordTextField.text]) {
        if (self.userNameTextField.text.length > 0 && self.emailTextField.text.length > 0) {
            
            NSString *username = self.userNameTextField.text;
            NSString *password = self.passwordTextField.text;
            NSString *email = self.emailTextField.text;
            
            UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [spinner setFrame:CGRectMake(0, 0, 100, 100)];
            spinner.transform = CGAffineTransformMakeScale(2, 2);
            [spinner setColor:[UIColor darkGrayColor]];
            [self.view addSubview:spinner];
            [spinner setCenter:CGPointMake(self.view.center.x, 150)];
            [self.view bringSubviewToFront:spinner];
            [spinner startAnimating];
            
            
            __weak typeof(self) weakSelf = self;
            [self.serviceController createUserWithUserName:username password:password email:email completion:^(NSManagedObjectID *objectId, NSString *sessionToken, NSError *error) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (objectId) {
                    NSLog(@"objectId: %@", objectId);
                    strongSelf.user = [strongSelf.coreDataController fetchUserWithId:objectId];
                    
                    [spinner stopAnimating];
                    if (strongSelf.user) {
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
                        [strongSelf performSegueWithIdentifier:@"SingUpCompleteSeque" sender:self];
                    } else {
                        NSLog(@"self.user returned nil");
                        [spinner stopAnimating];
                        [strongSelf presentLogInFailedAlertWithMessage:@"User creation failed, please try again"];
                    }
                }
                
                
                if (error) {
                    NSLog(@"createUserError: %@", error);
                    [spinner stopAnimating];
                    NSDictionary *userInfoDictionary = error.userInfo;
                    NSString *errorMessage = [userInfoDictionary valueForKey:@"error"];
                    [strongSelf presentLogInFailedAlertWithMessage:errorMessage];
                    
                }
            }];
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SingUpCompleteSeque"]) {
        
        ViewController *mainView = segue.destinationViewController;
        mainView.user = self.user;
        mainView.persistenceController = self.persistenceController;
        mainView.serviceController = self.serviceController;
        mainView.coreDataController = self.coreDataController;
        mainView.sessionToken = self.sessionToken;
    }
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"SingUpCompleteSeque" ]) {
        
        return NO;
        
    }
    
    return YES;
    
}

- (void)presentLogInFailedAlertWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Log In Failed" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                         {
                             self.userNameTextField.text = @"";
                             self.emailTextField.text = @"";
                             self.passwordTextField.text = @"";
                             self.checkPasswordTextField.text = @"";
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                             
                         }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end

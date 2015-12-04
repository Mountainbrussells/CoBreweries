//
//  CBFServiceController.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/3/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "CBFServiceController.h"
#import "CBFUser.h"
#import "NSString+NSString_EscapedString.h"

static NSString *const kBaseParseAPIURL = @"https://api.parse.com";
static NSString *const kParseUserVenue = @"/1/users";
static NSString *const kParseLoginVenue = @"/1/login";
static NSString *const kPARSE_APPLICATION_ID = @"Ly0UjZGre3fILHVIHX9Hk19lb9v5Dev2nUSOynkF";
static NSString *const kREST_API_KEY = @"fsJHCngQ3lfeZQSCm8Yz8Xe6hDVdOCWoBaNkAVLo";

@interface CBFServiceController ()

@property (strong, nonatomic) CBFUser *user;

@end


@implementation CBFServiceController

- (void)createUserWithUserName:(NSString *)name password:(NSString *)password email:(NSString *)email managedObjectContext:(NSManagedObjectContext *)moc completion:(void (^)(NSString *userId, NSError *error))completion
{
    
    
    NSString *urlString = kBaseParseAPIURL;
    urlString = [urlString stringByAppendingString:kParseLoginVenue];
    
    NSURL *parseURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:parseURL];
    [parseRequest setHTTPMethod:@"POST"];
    [parseRequest setValue:kPARSE_APPLICATION_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:kREST_API_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [parseRequest setValue:@"1" forHTTPHeaderField:@"X-Parse-Revocable-Session"];
    [parseRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    
    
    NSDictionary *postDictionary = @{@"username": name, @"password": password, @"email": email};
    
    NSError *error;
    NSData *postBody = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    [parseRequest setHTTPBody:postBody];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
   
    
    
    
    NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (response) {
            NSLog(@"Request Response:%@", response);
        }
        
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"Data: %@", responseDictionary);
            NSString *objectID = [responseDictionary valueForKey:@"objectId"];
            
            CBFUser *user = [CBFUser insertInManagedObjectContext:moc];
            user.userName = name;
            user.password = password;
            user.email = email;
            user.uid = objectID;
            NSError *error;
            [moc save:&error];
            
            if (completion) {
                completion(objectID, nil);
            }
            
            
        }
        
        
        if (error) {
            NSLog(@"RequestError:%@", error);
            
            if (completion) {
                completion(nil, error);
            }
            
        }
        
        
    }];
    
    [task resume];
    
}

- (CBFUser *)logInUserWithName:(NSString *)name andPassword:(NSString *)password inManagedObjectContext:(NSManagedObjectContext *)moc
{
    
    NSString * userLoginString = [NSString stringWithFormat:@"?username=%@&password=%@", [name CBF_URLEscapedString], [password CBF_URLEscapedString]];
    
    NSString *urlString = kBaseParseAPIURL;
    urlString = [urlString stringByAppendingString:kParseLoginVenue];
    urlString = [urlString stringByAppendingString:userLoginString];
    
    NSURL *parseURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:parseURL];
    [parseRequest setHTTPMethod:@"GET"];
    [parseRequest setValue:kPARSE_APPLICATION_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:kREST_API_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [parseRequest setValue:@"1" forHTTPHeaderField:@"X-Parse-Revocable-Session"];
    
    
    
    
//    NSDictionary *postDictionary = @{@"username": name, @"password": password};
//    
//    NSError *error;
//    NSData *postBody = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONWritingPrettyPrinted error:&error];
//    
//    [parseRequest setHTTPBody:postBody];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Create  and enter task group to prevent return before end of asynchronous operation
    dispatch_group_t taskGroup = dispatch_group_create();
    dispatch_group_enter(taskGroup);
    
    
    
    NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (response) {
            NSLog(@"Request Response:%@", response);
        }
        
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"Data: %@", responseDictionary);
            NSString *objectID = [responseDictionary valueForKey:@"objectId"];
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc];
            [fetchRequest setEntity:entity];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", objectID];
            fetchRequest.predicate = predicate;
            NSError *error;
            NSArray *fetchedUser = [moc executeFetchRequest:fetchRequest error:&error];
            
            if (fetchedUser.count > 0 && fetchedUser.count < 2) {
                self.user = fetchedUser[0];
            }
            
            
        }
        
        
        if (error) {
            NSLog(@"RequestError:%@", error);
            // Need to do something with this error.  Should I throw an NSAlertViewcController here?
            
        }
        // Leave task group
        dispatch_group_leave(taskGroup);
        
    }];
    
    [task resume];
    
    // Waiting for task group to end
    dispatch_group_wait(taskGroup, DISPATCH_TIME_FOREVER);
    
    
    return self.user;

}



@end

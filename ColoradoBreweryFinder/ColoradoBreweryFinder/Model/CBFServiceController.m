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

@property (strong, readwrite) CBFUser *user;
@property (strong, nonatomic) BRPersistenceController *persistencController;

@end


@implementation CBFServiceController

- (id)initWithPersistenceController:(BRPersistenceController *)persistenceController
{
    self = [super init];
    self.persistencController = persistenceController;
    return self;
}

- (void)createUserWithUserName:(NSString *)name password:(NSString *)password email:(NSString *)email completion:(void (^)(NSManagedObjectID *, NSString *, NSError *))completion
{
    
    // Create Parse POST request
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
    
    NSManagedObjectContext *moc = self.persistencController.managedObjectContext;
    
    
    // task creates parse user
    NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (response) {
            NSLog(@"Request Response:%@", response);
        }
        
        NSManagedObjectID *managedObjectId;
        
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"Data: %@", responseDictionary);
            NSString *objectIDNumber = [responseDictionary valueForKey:@"objectId"];
            NSString *sessionToken = [responseDictionary valueForKey:@"sessionToken"];
            
            if (objectIDNumber) {
                // if task is successful create CD user object
                CBFUser *user = [CBFUser insertInManagedObjectContext:moc];
                user.userName = name;
                user.password = password;
                user.email = email;
                user.uid = objectIDNumber;
                NSArray *userArray = [[NSArray alloc] initWithObjects:user, nil];
                NSError *objectIdError;
                [moc obtainPermanentIDsForObjects:userArray error:&objectIdError];
                self.user = user;
                
                managedObjectId = self.user.objectID;
                
                
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // pass back managedObjectId and sessionToken
                        completion(managedObjectId, sessionToken, nil);
                    });
                }
            } else {
                
                // Deal with invalid login error from parse
                
                NSInteger code = [[responseDictionary valueForKey:@"code"] integerValue];
                NSError *error = [NSError errorWithDomain:@"ParseLoginError" code:code userInfo:responseDictionary];
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, nil, error);
                    });
                }
            }
            
            
        }
        
        
        if (error) {
            NSLog(@"RequestError:%@", error);
            
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, nil, error);
                });
            }
            
        }
        
        
    }];
    
    [task resume];
    
}

- (void)logInUserWithName:(NSString *)name andPassword:(NSString *)password completion:(void (^)(NSManagedObjectID *, NSString *, NSError *))completion
{
    
    // First Log in to Parse
    
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
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    
    
    
    NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (response) {
            NSLog(@"Request Response:%@", response);
        }
        
        if (data) {
            
            // If user exist, get objectID and session Token
            
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSManagedObjectContext *moc = self.persistencController.managedObjectContext;
            NSLog(@"Data: %@", responseDictionary);
            NSString *objectID = [responseDictionary valueForKey:@"objectId"];
            NSString *sessionToken = [responseDictionary valueForKey:@"sessionToken"];
            
            
            
            
            NSManagedObjectID *managedObjectId = nil;
            
            // Need to check if it actually returned a User, as invalid login comes back as data
            
            if (objectID) {
                
                
                [moc performBlockAndWait:^ {
                    
                    
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc];
                    [fetchRequest setEntity:entity];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", objectID];
                    fetchRequest.predicate = predicate;
                    NSError *error;
                    NSArray *fetchedUser = [moc executeFetchRequest:fetchRequest error:&error];
                    NSError *idError;
                    [moc obtainPermanentIDsForObjects:fetchedUser error:&idError];
                    
                    if (fetchedUser.count > 0 && fetchedUser.count < 2) {
                        
                        //  User exists on this device: fetch was successful
                        self.user = fetchedUser[0];
                        
                    } else if (fetchedUser.count == 0) {
                        
                        // User exists but not on this device: create user
                        CBFUser *user = [CBFUser insertInManagedObjectContext:moc];
                        user.userName = name;
                        user.password = password;
                        user.uid = objectID;
                        self.user = user;
                        
                    } else if (idError) {
                        
                        // There was an error in the core data fetch
                        if (completion) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(nil, nil, idError);
                            });
                        }
                        
                    } else if (error) {
                        if (completion) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(nil, nil, error);
                            });
                        }
                    } 
                    
                    
                    
                    
                }];
                
                managedObjectId = self.user.objectID;
                
                if (completion) {
                    
                    // Do what needs to be done after user validated and Return NSmanagedObjectID
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(managedObjectId, sessionToken, nil);
                    });
                }
            } else {
                
                // Deal with invalid login error from parse
                
                NSInteger code = [[responseDictionary valueForKey:@"code"] integerValue];
                NSError *error = [NSError errorWithDomain:@"ParseLoginError" code:code userInfo:responseDictionary];
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(nil, nil, error);
                    });
                }
            }
            
        }
        
        
        if (error) {
            // Login with Parse Failed
            NSLog(@"RequestError:%@", error);
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, nil, error);
                });
            }
            
        }
        
        
    }];
    
    [task resume];
    
    
    
    
    
    
}



@end

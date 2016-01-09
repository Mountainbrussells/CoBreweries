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
#import "NSString+MD5String.h"
#import "CBFBrewery.h"
#import "CBFBreweryRating.h"
#import "CBFBeer.h"
#import "CBFBeerRating.h"
#import <CoreLocation/CoreLocation.h>




static NSString *const kBaseParseAPIURL = @"https://api.parse.com";
static NSString *const kParseUserVenue = @"/1/users";
static NSString *const kParseLoginVenue = @"/1/login";
static NSString *const kParseBreweryClassVenue = @"/1/classes/Brewery";
static NSString *const kPArseBreweryRatingVenue = @"/1/classes/BreweryRating";
static NSString *const kParseBeerClassVenue = @"/1/classes/Beer";
static NSString *const kParseBeerRatingClassVenue = @"/1/classes/BeerRating";
static NSString *const kPARSE_APPLICATION_ID = @"Ly0UjZGre3fILHVIHX9Hk19lb9v5Dev2nUSOynkF";
static NSString *const kREST_API_KEY = @"fsJHCngQ3lfeZQSCm8Yz8Xe6hDVdOCWoBaNkAVLo";

static NSString *authSessionToken = @"";

@interface CBFServiceController ()

@property (strong, readwrite) CBFUser *user;
@property (strong, nonatomic) NSManagedObjectID *userManagedObjectId;
@property (strong, nonatomic) BRPersistenceController *persistencController;
@property (strong, nonatomic) NSCache *photoCache;
@property (strong, nonatomic) NSCache *userNameCache;
@property (strong, nonatomic) NSManagedObjectContext *writeMOC;


@end


@implementation CBFServiceController

- (id)initWithPersistenceController:(BRPersistenceController *)persistenceController
{
    self = [super init];
    self.persistencController = persistenceController;
    self.writeMOC = self.persistencController.dataContext;
    self.photoCache = [[NSCache alloc] init];
    
    return self;
}


#pragma mark - User Calls
- (void)createUserWithUserName:(NSString *)name password:(NSString *)password email:(NSString *)email completion:(void (^)(NSManagedObjectID *, NSString *, NSError *))completion
{
    
    // Create Parse POST request
    NSString *urlString = kBaseParseAPIURL;
    urlString = [urlString stringByAppendingString:kParseUserVenue];
    
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
    
    // task creates parse user
    NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (response) {
            NSLog(@"Request Response:%@", response);
        }
        
        __block NSManagedObjectID *managedObjectId;
        [self.writeMOC performBlockAndWait:^{
            if (data) {
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"Data: %@", responseDictionary);
                NSString *objectIDNumber = [responseDictionary valueForKey:@"objectId"];
                NSString *sessionToken = [responseDictionary valueForKey:@"sessionToken"];
                authSessionToken = sessionToken;
                if (objectIDNumber) {
                    // if task is successful create CD user object
                    CBFUser *user = [CBFUser insertInManagedObjectContext:self.writeMOC];
                    user.userName = name;
                    user.password = password;
                    user.email = email;
                    user.uid = objectIDNumber;
                    NSArray *userArray = [[NSArray alloc] initWithObjects:user, nil];
                    NSError *objectIdError;
                    [self.writeMOC obtainPermanentIDsForObjects:userArray error:&objectIdError];
                    
                    self.user = user;
                    self.userManagedObjectId = self.user.objectID;
                    
                    managedObjectId = self.user.objectID;
                    
                    
                    
                    NSError *error = nil;
                    if (![self.writeMOC save:&error]) {
                        NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                        abort();
                    }
                    
                    
                    
                    
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
        }];
        
        
        
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
            NSLog(@"Data: %@", responseDictionary);
            NSString *objectID = [responseDictionary valueForKey:@"objectId"];
            NSString *sessionToken = [responseDictionary valueForKey:@"sessionToken"];
            authSessionToken = sessionToken;
            
            
            
            NSManagedObjectID *managedObjectId = nil;
            
            // Need to check if it actually returned a User, as invalid login comes back as data
            
            if (objectID) {
                
                
                [self.writeMOC performBlockAndWait:^ {
                    
                    
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.writeMOC];
                    [fetchRequest setEntity:entity];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", objectID];
                    fetchRequest.predicate = predicate;
                    NSError *error;
                    NSArray *fetchedUser = [self.writeMOC executeFetchRequest:fetchRequest error:&error];
                    NSError *idError;
                    [self.writeMOC obtainPermanentIDsForObjects:fetchedUser error:&idError];
                    
                    if (fetchedUser.count > 0 && fetchedUser.count < 2) {
                        
                        //  User exists on this device: fetch was successful
                        self.user = fetchedUser[0];
                        
                    } else if (fetchedUser.count == 0) {
                        
                        // User exists but not on this device: create user
                        CBFUser *user = [CBFUser insertInManagedObjectContext:self.writeMOC];
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
                self.userManagedObjectId = self.user.objectID;
                
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

#pragma mark - Brewery Calls

- (void)requestBreweriesWithCompletion:(void (^)(NSError *error))completion
{
    NSString *urlString = kBaseParseAPIURL;
    urlString = [urlString stringByAppendingString:kParseBreweryClassVenue];
    
    NSURL *parseURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:parseURL];
    [parseRequest setHTTPMethod:@"GET"];
    [parseRequest setValue:kPARSE_APPLICATION_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:kREST_API_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSError *dataError;
            NSDictionary *breweryData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&dataError];
            
            NSArray *breweries = [breweryData valueForKey:@"results"];
            
            [self.writeMOC performBlockAndWait:^{
                for (id brewery in breweries) {
                    CBFBrewery *mocBrewery = [CBFBrewery insertInManagedObjectContext:self.writeMOC];
                    mocBrewery.name = [brewery objectForKey:@"name"];
                    mocBrewery.address = [brewery objectForKey:@"address"];
                    NSDictionary *geolocation = [brewery objectForKey:@"geolocation"];
                    mocBrewery.lattitude = [geolocation objectForKey:@"latitude"];
                    mocBrewery.longitude = [geolocation objectForKey:@"longitude"];
                    mocBrewery.uid = [brewery objectForKey:@"objectId"];
                    
                    CLLocation *location = [[CLLocation alloc] initWithLatitude:[mocBrewery.lattitude doubleValue] longitude:[mocBrewery.longitude doubleValue]];
                    mocBrewery.location = location;
                    
                    
                    mocBrewery.phoneNumber = [brewery objectForKey:@"phoneNumber"];
                    mocBrewery.websiteURL = [brewery objectForKey:@"websiteURL"];
                    NSDictionary *photoDictionary = [brewery objectForKey:@"logo"];
                    NSString *urlString = [photoDictionary objectForKey:@"url"];
                    mocBrewery.logoURL = urlString;
                    //                NSURL *photoURL = [NSURL URLWithString:urlString];
                    //                NSData *data = [NSData dataWithContentsOfURL:photoURL];
                    //                mocBrewery.logo = data;
                    
                    NSError *error = nil;
                    if (![self.writeMOC save:&error]) {
                        NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                        abort();
                    }
                    
                }
            }];
            
            
            if (completion) {
                completion(nil);
            }
        }
        
        if (response) {
            NSLog(@"Request Response:%@", response);
        }
        
        if (error) {
            NSLog(@"RequestError:%@", error);
        }
    }];
    
    [task resume];
}

- (void) updateBreweriesWithCompletion:(void (^)(NSError *error))completion
{
    
    NSString *urlString = kBaseParseAPIURL;
    urlString = [urlString stringByAppendingString:kParseBreweryClassVenue];
    
    NSURL *parseURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:parseURL];
    [parseRequest setHTTPMethod:@"GET"];
    [parseRequest setValue:kPARSE_APPLICATION_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:kREST_API_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSError *dataError;
            NSDictionary *breweryData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&dataError];
            
            NSArray *breweries = [breweryData valueForKey:@"results"];
            
            __block NSMutableArray *mocBreweryArray = [NSMutableArray arrayWithArray:[self.coreDataController fetchBreweries]];
            [self.writeMOC performBlockAndWait:^{
                for (id brewery in breweries) {
                    
                    NSString *breweryUID = [brewery objectForKey:@"objectId"];
                    CBFBrewery *existingBrewery = [self.coreDataController fetchBreweryWithUID:breweryUID moc:self.writeMOC];
                    if (existingBrewery) {
                        
                        existingBrewery.name = [brewery objectForKey:@"name"];
                        existingBrewery.address = [brewery objectForKey:@"address"];
                        NSDictionary *geolocation = [brewery objectForKey:@"geolocation"];
                        existingBrewery.lattitude = [geolocation objectForKey:@"latitude"];
                        existingBrewery.longitude = [geolocation objectForKey:@"longitude"];
                        existingBrewery.uid = [brewery objectForKey:@"objectId"];
                        
                        CLLocation *location = [[CLLocation alloc] initWithLatitude:[existingBrewery.lattitude doubleValue] longitude:[existingBrewery.longitude doubleValue]];
                        existingBrewery.location = location;
                        
                        
                        existingBrewery.phoneNumber = [brewery objectForKey:@"phoneNumber"];
                        existingBrewery.websiteURL = [brewery objectForKey:@"websiteURL"];
                        NSDictionary *photoDictionary = [brewery objectForKey:@"logo"];
                        NSString *urlString = [photoDictionary objectForKey:@"url"];
                        existingBrewery.logoURL = urlString;
                        //                NSURL *photoURL = [NSURL URLWithString:urlString];
                        //                NSData *data = [NSData dataWithContentsOfURL:photoURL];
                        //                mocBrewery.logo = data;
                        
                        NSError *mocError;
                        [self.writeMOC save:&mocError];
                        [mocBreweryArray removeObject:existingBrewery];
                    } else  {
                        
                        CBFBrewery *mocBrewery = [CBFBrewery insertInManagedObjectContext:self.writeMOC];
                        mocBrewery.name = [brewery objectForKey:@"name"];
                        mocBrewery.address = [brewery objectForKey:@"address"];
                        NSDictionary *geolocation = [brewery objectForKey:@"geolocation"];
                        mocBrewery.lattitude = [geolocation objectForKey:@"latitude"];
                        mocBrewery.longitude = [geolocation objectForKey:@"longitude"];
                        mocBrewery.uid = [brewery objectForKey:@"objectId"];
                        
                        CLLocation *location = [[CLLocation alloc] initWithLatitude:[mocBrewery.lattitude doubleValue] longitude:[mocBrewery.longitude doubleValue]];
                        mocBrewery.location = location;
                        
                        
                        mocBrewery.phoneNumber = [brewery objectForKey:@"phoneNumber"];
                        mocBrewery.websiteURL = [brewery objectForKey:@"websiteURL"];
                        NSDictionary *photoDictionary = [brewery objectForKey:@"logo"];
                        NSString *urlString = [photoDictionary objectForKey:@"url"];
                        mocBrewery.logoURL = urlString;
                        //                NSURL *photoURL = [NSURL URLWithString:urlString];
                        //                NSData *data = [NSData dataWithContentsOfURL:photoURL];
                        //                mocBrewery.logo = data;
                        
                        NSError *mocError;
                        [self.writeMOC save:&mocError];
                    }
                    
                    
                    
                }
                
                if (mocBreweryArray.count > 0) {
                    for (CBFBrewery *brewery in mocBreweryArray) {
                        [self.writeMOC deleteObject:brewery];
                    }
                }
            }];
            
            
            
            
            
            
            if (completion) {
                completion(nil);
            }
        }
        
        if (response) {
            NSLog(@"Request Response:%@", response);
        }
        
        if (error) {
            NSLog(@"RequestError:%@", error);
        }
    }];
    
    [task resume];
}

- (void)getImageForBrewery:(CBFBrewery *)brewery completion:(void (^)(UIImage *, NSError *))completion
{
    __block UIImage *returnImage;
    
    NSString *breweryLogoURL = [NSString stringWithFormat:@"%@", brewery.logoURL];
    
    NSString *identifier = [NSString CBF_MD5:breweryLogoURL];
    
    if (!self.photoCache) {
        self.photoCache = [[NSCache alloc] init];
    }
    
    if ([self.photoCache objectForKey:identifier] != nil) {
        returnImage = [self.photoCache objectForKey:identifier];
        if (completion) {
            completion(returnImage, nil);
        }
    } else {
        
        //    UIImage *logoImage = [UIImage imageWithData:brewery.logo];
        
        NSString *urlString = brewery.logoURL;
        
        NSURL *photoURL = [NSURL URLWithString:urlString];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLRequest *logoRequest = [NSURLRequest requestWithURL:photoURL];
        NSURLSessionTask *task = [session dataTaskWithRequest:logoRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            UIImage *image = [[UIImage alloc] initWithData:data];
            [self.photoCache setObject:image forKey:identifier];
            __weak typeof(self) weakSelf = self;
            if (image) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    returnImage = [strongSelf.photoCache objectForKey:identifier];
                    if (completion) {
                        completion(returnImage, nil);
                    }
                });
            } else {
                NSError *error = [NSError errorWithDomain:@"Logo Download Error" code:50 userInfo:NULL];
                if (completion) {
                    completion(nil, error);
                }
            }
        }];
        
        [task resume];
        
    }
    
}

- (UIImage *)getImageWithURL:(NSString *)imageURLString completion:(void (^)(UIImage *)) completion
{
    UIImage *returnImage = nil;
    
    NSString *breweryLogoURL = imageURLString;
    
    NSString *identifier;
    
    if (breweryLogoURL) {
        identifier = [NSString CBF_MD5:breweryLogoURL];
    }
    
    //    NSString *identifier = [NSString CBF_MD5:breweryLogoURL];
    //    NSString *identifier = breweryLogoURL;
    if (identifier) {
        returnImage = [self.photoCache objectForKey:identifier];
        if (!returnImage) {
            NSString *urlString = breweryLogoURL;
            
            NSURL *photoURL = [NSURL URLWithString:urlString];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLRequest *logoRequest = [NSURLRequest requestWithURL:photoURL];
            
            __weak typeof(self) weakSelf = self;
            NSURLSessionTask *task = [session dataTaskWithRequest:logoRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                UIImage *image = [[UIImage alloc] initWithData:data];
                [weakSelf.photoCache setObject:image forKey:identifier];
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(image);
                    });
                }
            }];
            
            [task resume];
        }
        
        return returnImage;
    }
    return nil;
}

#pragma mark - BreweryRating calls

- (void)createBreweryRating:(NSInteger)rating breweryId:(NSString *)breweryId completion:(void (^)(NSManagedObjectID *, NSError *))completion
{
    CBFUser *user = self.user;
    CBFBrewery *brewery = [self.coreDataController fetchBreweryWithUID:breweryId moc:self.writeMOC];
    NSNumber *breweryRating = [NSNumber numberWithInteger:rating];
    
    NSString *urlString = kBaseParseAPIURL;
    urlString = [urlString stringByAppendingString:kPArseBreweryRatingVenue];
    
    NSURL *parseURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:parseURL];
    [parseRequest setHTTPMethod:@"POST"];
    [parseRequest setValue:kPARSE_APPLICATION_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:kREST_API_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [parseRequest setValue:@"1" forHTTPHeaderField:@"X-Parse-Revocable-Session"];
    [parseRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *breweryDict = @{@"__type": @"Pointer", @"className": @"Brewery", @"objectId": breweryId};
    NSDictionary *userDict = @{@"__type": @"Pointer", @"className": @"_User", @"objectId": user.uid};
    
    NSDictionary *postDictionary = @{@"rating": breweryRating, @"brewery": breweryDict, @"user": userDict};
    
    NSError *error;
    NSData *postBody = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    [parseRequest setHTTPBody:postBody];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    // task creates parse BreweryRating
    NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (response) {
            NSLog(@"Request Response:%@", response);
        }
        
        __block NSManagedObjectID *managedObjectId;
        [self.writeMOC performBlockAndWait:^{
            if (data) {
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"Data: %@", responseDictionary);
                NSString *objectIDNumber = [responseDictionary valueForKey:@"objectId"];
                
                if (objectIDNumber) {
                    // if task is successful create CD user object
                    CBFBreweryRating *rating = [CBFBreweryRating insertInManagedObjectContext:self.writeMOC];
                    
                    rating.brewery = brewery;
                    rating.user = user;
                    rating.uid = objectIDNumber;
                    
                    NSArray *userArray = [[NSArray alloc] initWithObjects:rating, nil];
                    NSError *objectIdError;
                    [self.writeMOC obtainPermanentIDsForObjects:userArray error:&objectIdError];
                    
                    managedObjectId = rating.objectID;
                    
                    NSError *error = nil;
                    if (![self.writeMOC save:&error]) {
                        NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                        abort();
                    }
                    
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // pass back managedObjectId and sessionToken
                            completion(managedObjectId, nil);
                        });
                    }
                } else {
                    NSInteger code = [[responseDictionary valueForKey:@"code"] integerValue];
                    NSError *error = [NSError errorWithDomain:@"ParseRequestError" code:code userInfo:responseDictionary];
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(nil, error);
                        });
                    }
                }
            }
            
        }];
        
        if (error) {
            NSLog(@"RequestError:%@", error);
            
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, error);
                });
            }
        }
    }];
    
    [task resume];
    
}

- (void)updateBreweryRating:(CBFBreweryRating *)rating withValue:(NSInteger)newRating completion:(void (^)(NSError *error))completion
{
    NSNumber *breweryRating = [NSNumber numberWithInteger:newRating];
    
    NSString *urlString = kBaseParseAPIURL;
    urlString = [urlString stringByAppendingString:kPArseBreweryRatingVenue];
    NSString *ratingIdString = [NSString stringWithFormat:@"/%@",rating.uid];
    urlString = [urlString stringByAppendingString:ratingIdString];
    
    
    NSURL *parseURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:parseURL];
    [parseRequest setHTTPMethod:@"PUT"];
    [parseRequest setValue:kPARSE_APPLICATION_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:kREST_API_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [parseRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *postDictionary = @{@"rating": @(newRating)};
    
    NSError *error;
    NSData *postBody = [NSJSONSerialization dataWithJSONObject:postDictionary options:0 error:&error];
    if (postBody != nil) {
        [parseRequest setHTTPBody:postBody];
    }
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (response) {
            NSLog(@"Request Response:%@", response);
            rating.rating = breweryRating;
            [self.persistencController save];
            [self.writeMOC save:nil];
            
        }
        
        
        
        if (data) {
            
        }
        
        if (error) {
            NSLog(@"RequestError:%@", error);
            
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(error);
                });
            }
        }
        
    }];
    
    [task resume];
}


- (void)requestBreweryRatingsWithCompletion:(void (^)(NSError *))completion
{
    NSString *urlString = kBaseParseAPIURL;
    urlString = [urlString stringByAppendingString:kPArseBreweryRatingVenue];
    
    NSURL *parseURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:parseURL];
    [parseRequest setHTTPMethod:@"GET"];
    [parseRequest setValue:kPARSE_APPLICATION_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:kREST_API_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self.writeMOC performBlockAndWait:^{
            if (data) {
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"responseDicionary:%@", responseDictionary);
                NSError *dataError;
                NSDictionary *breweryRatingData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&dataError];
                
                NSArray *breweryRatings = [breweryRatingData valueForKey:@"results"];
                
                for (id rating in breweryRatings) {
                    
                    
                    CBFBreweryRating *mocBreweryRating = [CBFBreweryRating insertInManagedObjectContext:self.writeMOC];
                    mocBreweryRating.rating = [rating objectForKey:@"rating"];
                    mocBreweryRating.uid = [rating objectForKey:@"objectId"];
                    
                    NSDictionary *breweryDict = [rating objectForKey:@"brewery"];
                    NSString *breweryUID = [breweryDict objectForKey:@"objectId"];
                    CBFBrewery *brewery = [self.coreDataController fetchBreweryWithUID:breweryUID moc:self.writeMOC];
                    mocBreweryRating.brewery = brewery;
                    
                    NSDictionary *userDict = [rating objectForKey:@"user"];
                    NSString *userUID = [userDict objectForKey:@"objectId"];
                    CBFUser *user = [self.coreDataController fetchUserWithUID:userUID moc:self.writeMOC];
                    
                    CBFUser *mainUser = [self.coreDataController fetchUserWithId:self.userManagedObjectId inContext:self.writeMOC];
                    
                    if ([user.uid isEqualToString:mainUser.uid]) {
                        mocBreweryRating.user = user;
                    } else {
                        mocBreweryRating.user = nil;
                    }
                    
                    NSError *error = nil;
                    if (![self.writeMOC save:&error]) {
                        NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                        abort();
                    }
                    
                }
                
                if (completion) {
                    completion(nil);
                }
            }
        }];
        
        
        if (response) {
            NSLog(@"Request Response:%@", response);
        }
        
        if (error) {
            NSLog(@"RequestError:%@", error);
        }
    }];
    
    [task resume];
}

- (void) updateBreweryRatingsWithCompletion:(void (^)(NSError *error))completion
{
   
    
    NSString *urlString = kBaseParseAPIURL;
    urlString = [urlString stringByAppendingString:kPArseBreweryRatingVenue];
    
    NSURL *parseURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:parseURL];
    [parseRequest setHTTPMethod:@"GET"];
    [parseRequest setValue:kPARSE_APPLICATION_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:kREST_API_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"responseDicionary:%@", responseDictionary);
            NSError *dataError;
            NSDictionary *breweryRatingData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&dataError];
            
            NSArray *breweryRatings = [breweryRatingData valueForKey:@"results"];
            
            NSMutableArray *mocBreweryRatingsArray = [NSMutableArray arrayWithArray:[self.coreDataController fetchBreweryRatings]];
            [self.writeMOC performBlockAndWait:^{
                for (id rating in breweryRatings) {
                    
                    NSString *breweryRatingId = [rating objectForKey:@"objectId"];
                    CBFBreweryRating *existingBreweryRating = [self.coreDataController fetchBreweryRatingWithUID:breweryRatingId moc:self.writeMOC];
                    if (existingBreweryRating) {
                        existingBreweryRating.rating = [rating objectForKey:@"rating"];
                        existingBreweryRating.uid = [rating objectForKey:@"objectId"];
                        
                        NSDictionary *breweryDict = [rating objectForKey:@"brewery"];
                        NSString *breweryUID = [breweryDict objectForKey:@"objectId"];
                        CBFBrewery *brewery = [self.coreDataController fetchBreweryWithUID:breweryUID];
                        existingBreweryRating.brewery = brewery;
                        
                        NSDictionary *userDict = [rating objectForKey:@"user"];
                        NSString *userUID = [userDict objectForKey:@"objectId"];
                        CBFUser *user = [self.coreDataController fetchUserWithUID:userUID];
                        
                        if ([user.uid isEqualToString:self.user.uid]) {
                            existingBreweryRating.user = user;
                        } else {
                            existingBreweryRating.user = nil;
                        }
                        
                        NSError *mocError;
                        [self.writeMOC save:&mocError];
                        [mocBreweryRatingsArray removeObject:existingBreweryRating];
                        
                    } else {
                        CBFBreweryRating *mocBreweryRating = [CBFBreweryRating insertInManagedObjectContext:self.writeMOC];
                        mocBreweryRating.rating = [rating objectForKey:@"rating"];
                        mocBreweryRating.uid = [rating objectForKey:@"objectId"];
                        
                        NSDictionary *breweryDict = [rating objectForKey:@"brewery"];
                        NSString *breweryUID = [breweryDict objectForKey:@"objectId"];
                        CBFBrewery *brewery = [self.coreDataController fetchBreweryWithUID:breweryUID];
                        mocBreweryRating.brewery = brewery;
                        
                        NSDictionary *userDict = [rating objectForKey:@"user"];
                        NSString *userUID = [userDict objectForKey:@"objectId"];
                        CBFUser *user = [self.coreDataController fetchUserWithUID:userUID];
                        
                        if ([user.uid isEqualToString:self.user.uid]) {
                            mocBreweryRating.user = user;
                        } else {
                            mocBreweryRating.user = nil;
                        }
                        
                        NSError *error = nil;
                        if (![self.writeMOC save:&error]) {
                            NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                            abort();
                        }
                        
                    }
                    
                    
                    
                    
                }
                
                if (mocBreweryRatingsArray.count > 0) {
                    for (CBFBreweryRating *rating in mocBreweryRatingsArray) {
                        [self.writeMOC deleteObject:rating];
                    }
                }

            }];
            
            
            if (completion) {
                completion(nil);
            }
        }
        
        if (response) {
            NSLog(@"Request Response:%@", response);
        }
        
        if (error) {
            NSLog(@"RequestError:%@", error);
        }
    }];
    
    [task resume];
    
}



#pragma mark - Beer Calls

- (void)requestBeersWithCompletion:(void (^)(NSError *))completion
{
    
    NSString *urlString = kBaseParseAPIURL;
    urlString = [urlString stringByAppendingString:kParseBeerClassVenue];
    
    NSURL *parseURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:parseURL];
    [parseRequest setHTTPMethod:@"GET"];
    [parseRequest setValue:kPARSE_APPLICATION_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:kREST_API_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"responseDicionary:%@", responseDictionary);
            NSError *dataError;
            NSDictionary *beersData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&dataError];
            
            NSArray *beers = [beersData valueForKey:@"results"];
            [self.writeMOC performBlockAndWait:^{
                for (id beer in beers) {
                    
                    
                    CBFBeer *mocBeer = [CBFBeer insertInManagedObjectContext:self.writeMOC];
                    mocBeer.name = [beer objectForKey:@"name"];
                    mocBeer.style = [beer objectForKey:@"style"];
                    mocBeer.abv = [beer objectForKey:@"abv"];
                    mocBeer.ibus = [beer objectForKey:@"ibus"];
                    mocBeer.uid = [beer objectForKey:@"objectId"];
                    
                    NSDictionary *breweryDict = [beer objectForKey:@"brewery"];
                    NSString *breweryUID = [breweryDict objectForKey:@"objectId"];
                    CBFBrewery *brewery = [self.coreDataController fetchBreweryWithUID:breweryUID moc:self.writeMOC];
                    mocBeer.brewery = brewery;
                    
                    NSDictionary *userDict = [beer objectForKey:@"user"];
                    NSString *userUID = [userDict objectForKey:@"objectId"];
                    CBFUser *user = [self.coreDataController fetchUserWithUID:userUID moc:self.writeMOC];
                    
                    if ([user.uid isEqualToString:self.user.uid]) {
                        mocBeer.user = user;
                        
                    } else {
                        mocBeer.user = nil;
                    }
                    
                    NSError *mocError;
                    [self.writeMOC save:&mocError];
                    
                }
                
                if (completion) {
                    completion(nil);
                }
            }];
            
        }
        
        if (response) {
            NSLog(@"Request Response:%@", response);
        }
        
        if (error) {
            NSLog(@"RequestError:%@", error);
        }
    }];
    
    [task resume];
    
}

- (void) updateBeersWtihCompletion:(void (^)(NSError *error))completion
{
    
    NSString *urlString = kBaseParseAPIURL;
    urlString = [urlString stringByAppendingString:kParseBeerClassVenue];
    
    NSURL *parseURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:parseURL];
    [parseRequest setHTTPMethod:@"GET"];
    [parseRequest setValue:kPARSE_APPLICATION_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:kREST_API_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"responseDicionary:%@", responseDictionary);
            NSError *dataError;
            NSDictionary *beersData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&dataError];
            
            NSArray *beers = [beersData valueForKey:@"results"];
            
            NSMutableArray *mocBeerArray = [NSMutableArray arrayWithArray:[self.coreDataController fetchBeers]];
            
            [self.writeMOC performBlockAndWait:^{
                for (id beer in beers) {
                    
                    NSString *beerId = [beer objectForKey:@"objectId"];
                    CBFBeer *existingBeer = [self.coreDataController fetchBeerWithUID:beerId moc:self.writeMOC];
                    if (existingBeer) {
                        existingBeer.name = [beer objectForKey:@"name"];
                        existingBeer.style = [beer objectForKey:@"style"];
                        existingBeer.abv = [beer objectForKey:@"abv"];
                        existingBeer.ibus = [beer objectForKey:@"ibus"];
                        existingBeer.uid = [beer objectForKey:@"objectId"];
                        
                        NSDictionary *breweryDict = [beer objectForKey:@"brewery"];
                        NSString *breweryUID = [breweryDict objectForKey:@"objectId"];
                        CBFBrewery *brewery = [self.coreDataController fetchBreweryWithUID:breweryUID moc:self.writeMOC];
                        existingBeer.brewery = brewery;
                        
                        NSDictionary *userDict = [beer objectForKey:@"user"];
                        NSString *userUID = [userDict objectForKey:@"objectId"];
                        CBFUser *user = [self.coreDataController fetchUserWithUID:userUID moc:self.writeMOC];
                        
                        if ([user.uid isEqualToString:self.user.uid]) {
                            existingBeer.user = user;
                            
                        } else {
                            existingBeer.user = nil;
                        }
                        
                        NSError *mocError;
                        [self.writeMOC save:&mocError];
                        
                    } else {
                        
                        
                        CBFBeer *mocBeer = [CBFBeer insertInManagedObjectContext:self.writeMOC];
                        mocBeer.name = [beer objectForKey:@"name"];
                        mocBeer.style = [beer objectForKey:@"style"];
                        mocBeer.abv = [beer objectForKey:@"abv"];
                        mocBeer.ibus = [beer objectForKey:@"ibus"];
                        mocBeer.uid = [beer objectForKey:@"objectId"];
                        
                        NSDictionary *breweryDict = [beer objectForKey:@"brewery"];
                        NSString *breweryUID = [breweryDict objectForKey:@"objectId"];
                        CBFBrewery *brewery = [self.coreDataController fetchBreweryWithUID:breweryUID moc:self.writeMOC];
                        mocBeer.brewery = brewery;
                        
                        NSDictionary *userDict = [beer objectForKey:@"user"];
                        NSString *userUID = [userDict objectForKey:@"objectId"];
                        CBFUser *user = [self.coreDataController fetchUserWithUID:userUID moc:self.writeMOC];
                        
                        if ([user.uid isEqualToString:self.user.uid]) {
                            mocBeer.user = user;
                            
                        } else {
                            mocBeer.user = nil;
                        }
                        
                        NSError *mocError;
                        [self.writeMOC save:&mocError];
                    }
                    
                    
                    
                }
                
                if (mocBeerArray.count > 0) {
                    for (CBFBeer *beer in mocBeerArray) {
                        [self.writeMOC deleteObject:beer];
                    }
                }
            }];
            
            
            if (completion) {
                completion(nil);
            }
        }
        
        if (response) {
            NSLog(@"Request Response:%@", response);
        }
        
        if (error) {
            NSLog(@"RequestError:%@", error);
        }
    }];
    
    [task resume];
}

#pragma mark - Beer Review Calls

- (void)requestBeerReviewsWithCompletion:(void (^)(NSError *error))completion
{
    
    NSString *urlString = kBaseParseAPIURL;
    urlString = [urlString stringByAppendingString:kParseBeerRatingClassVenue];
    
    NSURL *parseURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:parseURL];
    [parseRequest setHTTPMethod:@"GET"];
    [parseRequest setValue:kPARSE_APPLICATION_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:kREST_API_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"responseDicionary:%@", responseDictionary);
            NSError *dataError;
            NSDictionary *beerRatingData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&dataError];
            
            NSArray *beerRatings = [beerRatingData valueForKey:@"results"];
            [self.writeMOC performBlockAndWait:^{
                for (id rating in beerRatings) {
                    
                    
                    CBFBeerRating *mocBeerRating = [CBFBeerRating insertInManagedObjectContext:self.writeMOC];
                    mocBeerRating.rating = [rating objectForKey:@"rating"];
                    mocBeerRating.uid = [rating objectForKey:@"objectId"];
                    mocBeerRating.review =[rating objectForKey:@"review"];
                    mocBeerRating.username = [rating objectForKey:@"username"];
                    
                    NSDictionary *beerDict = [rating objectForKey:@"beer"];
                    NSString *beerUID = [beerDict objectForKey:@"objectId"];
                    CBFBeer *beer = [self.coreDataController fetchBeerWithUID:beerUID moc:self.writeMOC];
                    mocBeerRating.beer = beer;
                    
                    NSDictionary *userDict = [rating objectForKey:@"user"];
                    NSString *userUID = [userDict objectForKey:@"objectId"];
                    CBFUser *user = [self.coreDataController fetchUserWithUID:userUID moc:self.writeMOC];
                    mocBeerRating.userUID = userUID;
                    
                    
                    if ([user.uid isEqualToString:self.user.uid]) {
                        mocBeerRating.user = user;
                    } else {
                        mocBeerRating.user = nil;
                    }
                    
                    NSError *mocError;
                    [self.writeMOC save:&mocError];
                    
                }
                
                if (completion) {
                    completion(nil);
                }
            }];
           
        }
        
        if (response) {
            NSLog(@"Request Response:%@", response);
        }
        
        if (error) {
            NSLog(@"RequestError:%@", error);
        }
    }];
    
    [task resume];
    
}

- (void) updateBeerReviewsWithCompletion:(void (^)(NSError *error))completion
{
    
    NSString *urlString = kBaseParseAPIURL;
    urlString = [urlString stringByAppendingString:kParseBeerRatingClassVenue];
    
    NSURL *parseURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:parseURL];
    [parseRequest setHTTPMethod:@"GET"];
    [parseRequest setValue:kPARSE_APPLICATION_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:kREST_API_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"responseDicionary:%@", responseDictionary);
            NSError *dataError;
            NSDictionary *beerRatingData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&dataError];
            
            NSArray *beerRatings = [beerRatingData valueForKey:@"results"];
            
            NSMutableArray *mocBeerReviewArray = [NSMutableArray arrayWithArray:[self.coreDataController fetchBeerReviews]];
            [self.writeMOC performBlockAndWait:^{
                for (id rating in beerRatings) {
                    
                    NSString *ratingId = [rating objectForKey:@"objectId"];
                    CBFBeerRating *existingRating = [self.coreDataController fetchBeerRatingWithUID:ratingId moc:self.writeMOC];
                    if (existingRating) {
                        existingRating.rating = [rating objectForKey:@"rating"];
                        existingRating.uid = [rating objectForKey:@"objectId"];
                        existingRating.review =[rating objectForKey:@"review"];
                        existingRating.username = [rating objectForKey:@"username"];
                        
                        NSDictionary *beerDict = [rating objectForKey:@"beer"];
                        NSString *beerUID = [beerDict objectForKey:@"objectId"];
                        CBFBeer *beer = [self.coreDataController fetchBeerWithUID:beerUID moc:self.writeMOC];
                        existingRating.beer = beer;
                        
                        NSDictionary *userDict = [rating objectForKey:@"user"];
                        NSString *userUID = [userDict objectForKey:@"objectId"];
                        CBFUser *user = [self.coreDataController fetchUserWithUID:userUID moc:self.writeMOC];
                        existingRating.userUID = userUID;
                        
                        
                        if ([user.uid isEqualToString:self.user.uid]) {
                            existingRating.user = user;
                        } else {
                            existingRating.user = nil;
                        }
                        
                        NSError *mocError;
                        [self.writeMOC save:&mocError];
                        
                    } else {
                        
                        
                        CBFBeerRating *mocBeerRating = [CBFBeerRating insertInManagedObjectContext:self.writeMOC];
                        mocBeerRating.rating = [rating objectForKey:@"rating"];
                        mocBeerRating.uid = [rating objectForKey:@"objectId"];
                        mocBeerRating.review =[rating objectForKey:@"review"];
                        mocBeerRating.username = [rating objectForKey:@"username"];
                        
                        NSDictionary *beerDict = [rating objectForKey:@"beer"];
                        NSString *beerUID = [beerDict objectForKey:@"objectId"];
                        CBFBeer *beer = [self.coreDataController fetchBeerWithUID:beerUID moc:self.writeMOC];
                        mocBeerRating.beer = beer;
                        
                        NSDictionary *userDict = [rating objectForKey:@"user"];
                        NSString *userUID = [userDict objectForKey:@"objectId"];
                        CBFUser *user = [self.coreDataController fetchUserWithUID:userUID moc:self.writeMOC];
                        mocBeerRating.userUID = userUID;
                        
                        
                        if ([user.uid isEqualToString:self.user.uid]) {
                            mocBeerRating.user = user;
                        } else {
                            mocBeerRating.user = nil;
                        }
                        
                        NSError *mocError;
                        [self.writeMOC save:&mocError];
                    }
                    
                }
                
                if (mocBeerReviewArray.count > 0) {
                    for (CBFBeerRating *rating in mocBeerReviewArray) {
                        [self.writeMOC deleteObject:rating];
                    }
                }
                
                if (completion) {
                    completion(nil);
                }
            }];
            
        }
        
        if (response) {
            NSLog(@"Request Response:%@", response);
        }
        
        if (error) {
            NSLog(@"RequestError:%@", error);
        }
    }];
    
    [task resume];
}


- (NSString *)getUserNameWithUID:(NSString *)uid completion:(void (^)(NSString *userName))completion
{
    NSString *returnString = nil;
    
    NSString *userUIDString = uid;
    
    NSString *identifier = userUIDString;
    
    returnString = [self.userNameCache objectForKey:identifier];
    if (!returnString) {
        NSString *urlString = kBaseParseAPIURL;
        urlString = [urlString stringByAppendingString:kParseUserVenue];
        NSString *userUIDString = [NSString stringWithFormat:@"/%@", uid];
        urlString = [urlString stringByAppendingString:userUIDString];
        NSURL *parseURL = [NSURL URLWithString:urlString];
        NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:parseURL];
        [parseRequest setHTTPMethod:@"GET"];
        [parseRequest setValue:kPARSE_APPLICATION_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
        [parseRequest setValue:kREST_API_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];
        NSURLSession *session = [NSURLSession sharedSession];
        
        __weak typeof(self) weakSelf = self;
        NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                NSError *dataError;
                NSDictionary *userDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&dataError];
                NSString *userName = [userDict objectForKey:@"username"];
                [weakSelf.userNameCache setObject:userName forKey:identifier];
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(userName);
                    });
                }
                
            }
            
            if (response) {
                NSLog(@"Request Response:%@", response);
            }
            
            if (error) {
                NSLog(@"RequestError:%@", error);
            }
        }];
        [task resume];
    }
    
    return returnString;
}

- (void) createBeerRating:(NSString *)rating withNote:(NSString *)note beerId:(NSString *)beerId completion:(void (^)(NSManagedObjectID *ratingObjectID, NSError *error))completion
{
    // TODO:  Cross context call to fix.
    
    CBFUser *user = [self.coreDataController fetchUserWithId:self.userManagedObjectId inContext:self.writeMOC];
    CBFBeer *beer = [self.coreDataController fetchBeerWithUID:beerId moc:self.writeMOC];
    long intRating = [rating longLongValue];
    NSNumber *beerRating = [NSNumber numberWithLong:intRating];
    
    NSString *urlString = kBaseParseAPIURL;
    urlString = [urlString stringByAppendingString:kParseBeerRatingClassVenue];
    
    NSURL *parseURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:parseURL];
    [parseRequest setHTTPMethod:@"POST"];
    [parseRequest setValue:kPARSE_APPLICATION_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:kREST_API_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [parseRequest setValue:@"1" forHTTPHeaderField:@"X-Parse-Revocable-Session"];
    [parseRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [parseRequest setValue:authSessionToken forHTTPHeaderField:@"X-Parse-Session-Token"];
    
    NSDictionary *beerdict = @{@"__type": @"Pointer", @"className": @"Beer", @"objectId": beerId};
    NSDictionary *userDict = @{@"__type": @"Pointer", @"className": @"_User", @"objectId": user.uid};
    
    NSDictionary *postDictionary = @{@"rating": beerRating, @"beer": beerdict, @"user": userDict, @"review": note};
    
    NSError *error;
    NSData *postBody = [NSJSONSerialization dataWithJSONObject:postDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    [parseRequest setHTTPBody:postBody];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    
    // task creates parse BreweryRating
    NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (response) {
            NSLog(@"Request Response:%@", response);
        }
        
        __block NSManagedObjectID *managedObjectId;
        [self.writeMOC performBlock:^{
            if (data) {
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSLog(@"Data: %@", responseDictionary);
                NSString *objectIDNumber = [responseDictionary valueForKey:@"objectId"];
                
                if (objectIDNumber) {
                    // if task is successful create CD user object
                    CBFBeerRating *rating = [CBFBeerRating insertInManagedObjectContext:self.writeMOC];
                    
                    rating.beer = beer;
                    rating.user = user;
                    rating.rating = beerRating;
                    rating.review = note;
                    rating.uid = objectIDNumber;
                    rating.username = self.user.userName;
                    
                    NSArray *userArray = [[NSArray alloc] initWithObjects:rating, nil];
                    NSError *objectIdError;
                    [self.writeMOC obtainPermanentIDsForObjects:userArray error:&objectIdError];
                    NSError *mocError;
                    [self.writeMOC save:&mocError];
                    managedObjectId = rating.objectID;
                    [self.persistencController save];
                    
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // pass back managedObjectId and sessionToken
                            completion(managedObjectId, nil);
                        });
                    }
                } else {
                    
                    NSInteger code = [[responseDictionary valueForKey:@"code"] integerValue];
                    NSError *error = [NSError errorWithDomain:@"ParseLoginError" code:code userInfo:responseDictionary];
                    if (completion) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(nil, error);
                        });
                    }
                }
            }
        }];
        
        if (error) {
            NSLog(@"RequestError:%@", error);
            
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(nil, error);
                });
            }
        }
    }];
    
    [task resume];
    
}

- (void)updateBeerRating:(CBFBeerRating *)rating withValue:(NSInteger)newRating andNote:(NSString *)note completion:(void (^)(NSError *error))completion
{
    NSNumber *beerRating = [NSNumber numberWithInteger:newRating];
    
    NSString *urlString = kBaseParseAPIURL;
    urlString = [urlString stringByAppendingString:kParseBeerRatingClassVenue];
    NSString *ratingIdString = [NSString stringWithFormat:@"/%@",rating.uid];
    urlString = [urlString stringByAppendingString:ratingIdString];
    
    
    NSURL *parseURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:parseURL];
    [parseRequest setHTTPMethod:@"PUT"];
    [parseRequest setValue:kPARSE_APPLICATION_ID forHTTPHeaderField:@"X-Parse-Application-Id"];
    [parseRequest setValue:kREST_API_KEY forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    [parseRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [parseRequest setValue:authSessionToken forHTTPHeaderField:@"X-Parse-Session-Token"];
    
    NSDictionary *postDictionary = @{@"rating": @(newRating), @"review": note};
    
    NSError *error;
    NSData *postBody = [NSJSONSerialization dataWithJSONObject:postDictionary options:0 error:&error];
    if (postBody != nil) {
        [parseRequest setHTTPBody:postBody];
    }
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSManagedObjectContext *moc = self.persistencController.managedObjectContext;
    
    NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (response) {
            NSLog(@"Request Response:%@", response);
            rating.rating = beerRating;
            rating.review = note;
            [moc save:nil];
            [self.persistencController save];
            
        }
        
        
        
        if (data) {
            
        }
        
        if (error) {
            NSLog(@"RequestError:%@", error);
            
            if (completion) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(error);
                });
            }
        }
        
    }];
    
    [task resume];
}

@end

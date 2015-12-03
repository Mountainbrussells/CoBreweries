//
//  CBFBeerTests.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 11/23/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CBFBeer.h"
#import "CBFUser.h"
#import "CBFBeerRating.h"

@interface CBFBeerTests : XCTestCase

@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) CBFBeer *beer;

@end

@implementation CBFBeerTests

- (void)setUp {
    [super setUp];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ColoradoBreweryFinder" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    XCTAssertTrue([psc addPersistentStoreWithType:NSInMemoryStoreType
                                    configuration:nil
                                              URL:nil
                                          options:nil
                                            error:NULL] ? YES : NO, @"Should be able to add in-memory store");
    self.moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.moc.persistentStoreCoordinator = psc;
    
    NSManagedObjectContext *moc = self.moc;
    
    CBFUser *user = [CBFUser insertInManagedObjectContext:moc];
    user.userName = @"Smith123";
    
    
    self.beer = [CBFBeer insertInManagedObjectContext:moc createdByUser:user];
    
    CBFBeerRating *rating1 = [CBFBeerRating insertInManagedObjectContext:moc];
    rating1.rating = [NSNumber numberWithInteger:4];
    rating1.beer = self.beer;
    
    
    CBFBeerRating *rating2 = [CBFBeerRating insertInManagedObjectContext:moc];
    rating2.rating = [NSNumber numberWithInteger:1];
    rating2.beer = self.beer;
    
    CBFBeerRating *rating3 = [CBFBeerRating insertInManagedObjectContext:moc];
    rating3.rating = [NSNumber numberWithInteger:4];
    rating3.beer = self.beer;
    
    CBFBeerRating *rating4 = [CBFBeerRating insertInManagedObjectContext:moc];
    rating4.rating = [NSNumber numberWithInteger:2];
    rating4.beer = self.beer;
    
    NSError *error;
    [self.moc save:&error];
    
}

- (void)tearDown {
    [super tearDown];
}


- (void)testDateModified {
    
    
    [self.beer setName:@"Budwiser"];
    NSDate *date = [NSDate date];
    NSError *error;
    [self.moc save:&error];
    [self.moc obtainPermanentIDsForObjects:@[self.beer] error:nil];
    XCTAssertTrue([date compare:self.beer.dateUpdated] == NSOrderedAscending, @"%f Should be less then %f", [date timeIntervalSinceReferenceDate], [self.beer.dateUpdated timeIntervalSinceReferenceDate]);
    
    XCTAssertTrue([self.beer.dateCreated compare:self.beer.dateUpdated] == NSOrderedAscending, @"%f Should be less then %f", [self.beer.dateCreated timeIntervalSinceReferenceDate], [self.beer.dateUpdated timeIntervalSinceReferenceDate]);

}

- (void)testDateCreated
{
    XCTAssertTrue(self.beer.dateCreated != nil, @"Self.beer should have a date created not: %@", self.beer.dateCreated);
}

- (void)testUser
{
    XCTAssertTrue(self.beer.user != nil, @"Self.beer.user should not be nil");
}

- (void)testAverageRating
{
    
    XCTAssertTrue([self.beer calculateAverageRating] == 3.0, @"%f should be equal to 3", [self.beer calculateAverageRating]);
}


@end

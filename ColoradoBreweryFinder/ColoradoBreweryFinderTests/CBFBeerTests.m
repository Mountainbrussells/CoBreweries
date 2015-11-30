//
//  CBFBeerTests.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 11/23/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CBFBeer.h"
#import "BRPersistenceController.h"

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
    
    
    
}

- (void)tearDown {
    [super tearDown];
}


- (void)testExample {
    NSManagedObjectContext *moc = self.moc;
    
    self.beer = [CBFBeer insertInManagedObjectContext:moc];
    
    [self.beer setName:@"Budwiser"];
    NSDate *date = [NSDate date];
    NSError *error;
    [self.moc save:&error];
    [self.moc obtainPermanentIDsForObjects:@[self.beer] error:nil];
    XCTAssertTrue([date compare:self.beer.dateUpdated] == NSOrderedAscending, @"%f Should be equal to %f", [date timeIntervalSinceReferenceDate], [self.beer.dateUpdated timeIntervalSinceReferenceDate]);
    
//    XCTAssertTrue([self.beer isInserted], @"Self.beer has not been inserted");
}



@end

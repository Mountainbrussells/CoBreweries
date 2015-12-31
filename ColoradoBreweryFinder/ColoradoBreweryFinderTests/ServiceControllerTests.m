//
//  ServiceControllerTests.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/3/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import "CBFServiceController.h"
#import "CBFUser.h"

@interface ServiceControllerTests : XCTestCase

@property (strong, nonatomic) NSManagedObjectContext *moc;
@property (strong, nonatomic) CBFServiceController *serviceController;

@end

@implementation ServiceControllerTests

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
    
    self.serviceController = [[CBFServiceController alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



@end

#import "CBFBeer.h"

@interface CBFBeer ()

// Private interface goes here.

@end

@implementation CBFBeer

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ createdByUser:(CBFUser *)user {
    NSParameterAssert(moc_);
//    CBFBeer *beer = [NSEntityDescription insertNewObjectForEntityForName:@"Beer" inManagedObjectContext:moc_];
//    beer.createdBy = user;
    return [NSEntityDescription insertNewObjectForEntityForName:@"Beer" inManagedObjectContext:moc_];
    
    
}


- (void)willSave
{
    [super willSave];
    if (![self isDeleted] && self.changedValues[@"dateUpdated"] == nil) {
        self.dateUpdated = [NSDate date];
    }
    
}

- (void) awakeFromInsert
{
    if (!self.dateCreated) {
        self.dateCreated = [NSDate date];
        
    }
}



@end

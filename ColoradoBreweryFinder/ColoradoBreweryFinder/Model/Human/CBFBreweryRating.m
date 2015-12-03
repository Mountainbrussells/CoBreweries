#import "CBFBreweryRating.h"

@interface CBFBreweryRating ()

// Private interface goes here.

@end

@implementation CBFBreweryRating

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc fromUser:(CBFUser *)user withRating:(NSNumber *)number;
{
    NSParameterAssert(moc);
    CBFBreweryRating *breweryRating = [CBFBreweryRating insertInManagedObjectContext:moc];
    if (user) {
        breweryRating.user = user;
    }
    
    if (number) {
        breweryRating.rating = number;
    }
    
    return breweryRating;
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

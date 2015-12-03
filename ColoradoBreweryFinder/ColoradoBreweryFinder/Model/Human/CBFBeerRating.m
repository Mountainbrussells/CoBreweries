#import "CBFBeerRating.h"

@interface CBFBeerRating ()

// Private interface goes here.

@end

@implementation CBFBeerRating

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc fromUser:(CBFUser *)user withRating:(NSNumber *)number
{
    NSParameterAssert(moc);
    CBFBeerRating *rating = [CBFBeerRating insertInManagedObjectContext:moc];
    if (user) {
        rating.user = user;
    }
    
    if (number) {
        rating.rating = number;
    }
    
    return rating;
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

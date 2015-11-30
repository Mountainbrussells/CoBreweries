#import "CBFBeerRating.h"

@interface CBFBeerRating ()

// Private interface goes here.

@end

@implementation CBFBeerRating

- (id)init
{
    self = [super init];
    if (self) {
        
        [self setDateCreated:[NSDate date]];
        // Not sure how to access the User of the class that is creating the Beer entity in order to automatically set it.
        
    }
    
    return self;
}

- (void)willSave
{
    [super willSave];
    if (![self isDeleted] && self.changedValues[@"dateUpdated"] == nil) {
        self.dateUpdated = [NSDate date];
    }
}

@end

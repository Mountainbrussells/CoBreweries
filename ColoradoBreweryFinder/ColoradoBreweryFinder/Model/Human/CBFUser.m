#import "CBFUser.h"

@interface CBFUser ()

// Private interface goes here.

@end

@implementation CBFUser



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

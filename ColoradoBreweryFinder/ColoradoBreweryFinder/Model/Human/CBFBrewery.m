#import "CBFBrewery.h"
#import "CBFBreweryRating.h"

@interface CBFBrewery ()

// Private interface goes here.

@end

@implementation CBFBrewery



- (void)willSave
{
    [super willSave];
    if (![self isDeleted] && self.changedValues[@"dateUpdated"] == nil) {
        self.dateUpdated = [NSDate date];
    }
}

- (float)calculateAverageRating
{
    NSNumber *average;
    NSNumber *ratingsSum = 0;
    // Iterate through ratings to get the sum
    for (CBFBreweryRating *breweryRating in self.ratings) {
        ratingsSum = [NSNumber numberWithInteger:([ratingsSum integerValue]+ [breweryRating.rating integerValue])];
    }
    
    NSNumber *ratingsCount = [NSNumber numberWithLong:self.ratings.count];
    
    
    // Add 0.5 in order to round the int up
    average = [NSNumber numberWithInt:([ratingsSum floatValue]/[ratingsCount floatValue] + 0.5)];
    
    float floatAverage = [average floatValue];
    
    //  Possible KVC situation as an easier way to get the average.  Need to play with it.
    //    float floatAverage = [[self.ratings valueForKeyPath:@"@avg.rating.rating"] floatValue];
    
    return floatAverage;
    
}
@end

#import "CBFBeer.h"
#import "CBFBeerRating.h"

@interface CBFBeer ()

// Private interface goes here.

@end

@implementation CBFBeer

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc createdByUser:(CBFUser *)user {
    NSParameterAssert(moc);
    CBFBeer *beer = [NSEntityDescription insertNewObjectForEntityForName:@"Beer" inManagedObjectContext:moc];
    if (user) {
        beer.user = user;
    }
    
    return beer;
    
    
}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc createdByUser:(CBFUser *)user forBrewery:(CBFBrewery *)brewery withName:(NSString *)name
{
    NSParameterAssert(moc);
    CBFBeer *beer = [NSEntityDescription insertNewObjectForEntityForName:@"Beer" inManagedObjectContext:moc];
    if (user) {
        beer.user = user;
    }
    
    if (brewery) {
        beer.brewery = brewery;
    }
    
    if (name) {
        beer.name = name;
    }
    
    return beer;
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

- (float)calculateAverageRating
{
    NSNumber *average;
    NSNumber *ratingsSum = 0;
    // Iterate through ratings to get the sum
    for (CBFBeerRating *beerRating in self.ratings) {
        ratingsSum = [NSNumber numberWithInteger:([ratingsSum integerValue]+ [beerRating.rating integerValue])];
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

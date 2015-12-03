#import "_CBFBreweryRating.h"
#import "CBFUser.h"

@interface CBFBreweryRating : _CBFBreweryRating {}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc fromUser:(CBFUser *)user withRating:(NSNumber *)number;

@end

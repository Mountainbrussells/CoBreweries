#import "_CBFBeerRating.h"
#import "CBFUser.h"

@interface CBFBeerRating : _CBFBeerRating {}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc fromUser:(CBFUser *)user withRating:(NSNumber *)number;

@end

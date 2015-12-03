#import "_CBFBeer.h"
#import "CBFUser.h"
#import "CBFBrewery.h"

@interface CBFBeer : _CBFBeer {}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc createdByUser:(CBFUser *)user;

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc createdByUser:(CBFUser *)user forBrewery:(CBFBrewery *)brewery withName:(NSString *)name;

- (float)calculateAverageRating;

@end

#import "_CBFBeer.h"
#import "CBFUser.h"
#import "CBFBrewery.h"

@interface CBFBeer : _CBFBeer {}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ createdByUser:(CBFUser *)user;

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ createdByUser:(CBFUser *)user forBrewery:(CBFBrewery *)brewery withName:(NSString *)name;

- (void)calculateAndSetAverageRating;

@end

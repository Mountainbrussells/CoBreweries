#import "_CBFBeer.h"
#import "CBFUser.h"

@interface CBFBeer : _CBFBeer {}

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ createdByUser:(CBFUser *)user;



@end

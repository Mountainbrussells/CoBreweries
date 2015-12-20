//
//  CBFGeofenceManager.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/10/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString *const CBFLocationWillChangeNotification;
extern NSString *const CBFLocationDidChangeNotification;
extern NSString *const CBFLocationDidChangeNotificationLatitudeKey;
extern NSString *const CBFLocationDidChangeNotificationLongitudekey;



@interface CBFGeofenceManager : NSObject

+ (id)sharedManager;

@property NS_ENUM(NSUInteger, CBFGeofenceManagerLocationResultsChangeType) {
CBFGeofenceManagerLocationLocating = 1,
CBFGeofenceManagerLocationLocated = 2,
CBFGeofenceManagerLocationOutOfArea = 3,
};

@property enum CBFGeofenceManagerLocationResultsChangeType currentState;
@property (strong, readonly) CLLocation *location;

@end

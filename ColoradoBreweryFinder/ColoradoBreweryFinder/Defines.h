//
//  Defines.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 1/13/16.
//  Copyright © 2016 Ben Russell. All rights reserved.
//

#ifndef Defines_h
#define Defines_h

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...) do { } while(0)
#endif

#endif /* Defines_h */

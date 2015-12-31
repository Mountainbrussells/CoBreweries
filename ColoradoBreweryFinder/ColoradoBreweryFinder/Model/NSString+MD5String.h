//
//  NSString+MD5String.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/28/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5String)

+ (NSString *)CBF_MD5:(NSString *) input;

@end

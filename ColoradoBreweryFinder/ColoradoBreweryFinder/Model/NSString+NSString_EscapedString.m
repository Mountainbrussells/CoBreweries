//
//  NSString+NSString_EscapedString.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/3/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "NSString+NSString_EscapedString.h"

@implementation NSString (NSString_EscapedString)

- (NSString *) CBF_URLEscapedString {
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                    NULL,
                                                                                                    (__bridge CFStringRef) self,
                                                                                                    NULL,
                                                                                                    CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                                                    kCFStringEncodingUTF8));
    
    return escapedString;
}

@end

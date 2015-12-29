//
//  NSString+MD5String.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 12/28/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "NSString+MD5String.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5String)

+ (NSString *)CBF_MD5:(NSString *) input;
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

@end

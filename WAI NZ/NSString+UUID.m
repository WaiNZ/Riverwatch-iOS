//
//  NSString+UUID.m
//  WAI NZ
//
//  Created by Melby Ruarus on 10/10/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "NSString+UUID.h"

@implementation NSString (UUID)

+ (NSString *)uuid {
    NSString *uuidString = nil;
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid) {
        uuidString = (__bridge NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    return uuidString;
}

@end

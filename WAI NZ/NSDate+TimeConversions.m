//
//  NSDate+TimeConversions.m
//  WAI NZ
//
//  Created by Melby Ruarus on 19/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "NSDate+TimeConversions.h"

@implementation NSDate (TimeConversions)

- (time_t)UNIXTimestamp {
	return [self timeIntervalSince1970];
}

@end

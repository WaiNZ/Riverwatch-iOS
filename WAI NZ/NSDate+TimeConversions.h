//
//  NSDate+TimeConversions.h
//  WAI NZ
//
//  Created by Melby Ruarus on 19/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Additions to NSDate to aid with converting date formats
 */
@interface NSDate (TimeConversions)

/**
 Get the UNIX time represented by this date.
 
 UNIX time is the number of seconds since 00:00 1st January 1970.
 
 @return the UNIX time represented by this date
 */
- (time_t)UNIXTimestamp;

@end

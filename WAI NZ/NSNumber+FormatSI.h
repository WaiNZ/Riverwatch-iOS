//
//  NSNumber+FormatKibi.h
//  WAI NZ
//
//  Created by Melby Ruarus on 31/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Additions to NSNumber for SI prefix formatting
 */
@interface NSNumber (FormatSI)

/**
 Format a number with a SI suffix.
 
 The string returned will be suffix with a space and then
 the SI suffix.
 */
- (NSString *)formatSI;

@end

//
//  NSNumber+FormatKibi.m
//  WAI NZ
//
//  Created by Melby Ruarus on 31/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "NSNumber+FormatSI.h"

@implementation NSNumber (FormatSI)

- (NSString *)formatSI {
	double value = [self doubleValue];
	static const char suffixes[] = {0, 'k', 'M', 'G', 'T', 'P', 'E'};
	int suffix = 0;
	
	while(value >= 1000) {
		value /= 1000.0;
		++suffix;
		
		if(suffix >= sizeof(suffixes)) {
			return @">999.9 E";
		}
	}
	
	if(value < 10) {
		return [NSString stringWithFormat:@"%0.1f %c", value, suffixes[suffix]];
	}
	else {
		return [NSString stringWithFormat:@"%i %c", (int)value, suffixes[suffix]];
	}
}

@end

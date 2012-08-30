//
//  WAGeolocation.m
//  WAI NZ
//
//  Created by Melby Ruarus on 29/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WAGeolocation.h"

#import <RestKit/RestKit.h>

@interface WAGeolocation ()
@property (nonatomic, assign) NSNumber *_rk_latitude;
@property (nonatomic, assign) NSNumber *_rk_longitude;
@property (nonatomic, assign) NSString *_rk_source;
@end

@implementation WAGeolocation

+ (RKObjectMapping *)objectMapping {
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[WAGeolocation class]];
	[mapping mapKeyPath:@"lat" toAttribute:@"_rk_latitude"];
	[mapping mapKeyPath:@"lng" toAttribute:@"_rk_longitude"];
	[mapping mapKeyPath:@"source" toAttribute:@"_rk_source"];
	
	return mapping;
}

#pragma mark - Init/Dealloc

+ (id)geolocationWithCLLocation:(CLLocation *)location {
	return [[self alloc] initWithCLLocation:location];
}

- (id)initWithCLLocation:(CLLocation *)location {
	self = [self init];
	if(self) {
		latitude = location.coordinate.latitude;
		longitude = location.coordinate.longitude;
	}
	return self;
}

#pragma mark - Getters/Setters

- (NSNumber *)_rk_latitude {
	return @(latitude);
}

- (void)set_rk_latitude:(NSNumber *)_latitude {
	latitude = _latitude.doubleValue;
}

- (NSNumber *)_rk_longitude {
	return @(longitude);
}

- (void)set_rk_longitude:(NSNumber *)_longitude {
	longitude = _longitude.doubleValue;
}

- (NSString *)_rk_source {
	switch(source) {
		case kWAGeolocationSourceDevice:
			return @"GPS";
			break;
		case kWAGeolocationSourceHuman:
			return @"USER";
			break;
		case kWAGeolocationSourceUnknown:
			return nil;
			break;
	}
}

- (void)set_rk_source:(NSString *)_source {
	if([_source isEqualToString:@"GPS"]) {
		source = kWAGeolocationSourceDevice;
	}
	else if([_source isEqualToString:@"USER"]) {
		source = kWAGeolocationSourceHuman;
	}
	else {
		source = kWAGeolocationSourceUnknown;
	}
}

@synthesize latitude;
@synthesize longitude;
@synthesize source;
@end

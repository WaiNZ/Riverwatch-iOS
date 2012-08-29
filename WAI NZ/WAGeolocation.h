//
//  WAGeolocation.h
//  WAI NZ
//
//  Created by Melby Ruarus on 29/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class RKObjectMapping;

typedef enum {
	kWAGeolocationSourceUnknown = 0,
	kWAGeolocationSourceHuman = 1,
	kWAGeolocationSourceDevice = 2
} WAGeolocationSource;

@interface WAGeolocation : NSObject {
	CLLocationDegrees latitude;
	CLLocationDegrees longitude;
	
	WAGeolocationSource source;
}

+ (RKObjectMapping *)objectMapping;

+ (id)geolocationWithCLLocation:(CLLocation *)location;

- (id)initWithCLLocation:(CLLocation *)location;

@property (nonatomic, assign) CLLocationDegrees latitude;
@property (nonatomic, assign) CLLocationDegrees longitude;
@property (nonatomic, assign) WAGeolocationSource source;
@end

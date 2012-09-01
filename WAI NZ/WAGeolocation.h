//
//  WAGeolocation.h
//  WAI NZ
//
//  Created by Melby Ruarus on 29/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class RKObjectMapping;

typedef enum {
	kWAGeolocationSourceUnknown = 0,
	kWAGeolocationSourceHuman = 1,
	kWAGeolocationSourceDevice = 2
} WAGeolocationSource;

/**
 A class to store geolocation information.
 
 This class has latitude and longitude variables that indicate a
 location on the surface of the planet. Along with this is a flag
 to detail the source of the location information, be it user entered
 of from the device using GPS or WiFi triangulation see source.
 */
@interface WAGeolocation : NSObject <MKAnnotation> {
	CLLocationDegrees latitude;
	CLLocationDegrees longitude;
	
	WAGeolocationSource source;
}

/**
 The RKObjectMapping that can be used to serialize/deserialize
 this class using RestKit.
 */
+ (RKObjectMapping *)objectMapping;

/**
 A convenience method to create a WAGeolocation from a CLLocation
 
 @param location the location object to use for lat/lng information
 */
+ (id)geolocationWithCLLocation:(CLLocation *)location;

/**
 Initilize a WAGeolocation using a CLLocation
 
 @param location the location object to use for lat/lng information
 */
- (id)initWithCLLocation:(CLLocation *)location;

/** The latitude of this location */
@property (nonatomic, assign) CLLocationDegrees latitude;
/** The longitude of this location */
@property (nonatomic, assign) CLLocationDegrees longitude;
/**
 The source of this location information.
 
 This property can be:
 
 - kWAGeolocationSourceUnknown
 - kWAGeolocationSourceHuman
 - kWAGeolocationSourceDevice
 */
@property (nonatomic, assign) WAGeolocationSource source;
@end

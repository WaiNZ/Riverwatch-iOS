//
//  WASubmissionPhoto.h
//  WAI NZ
//
//  Created by Tom Greenwood-Thessman on 8/15/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WAGeolocation.h"

@class RKObjectMapping;

/**
 A photo data object that encapsulates the image data, timestamp,
 and location if available for a submission
 */
@interface WASubmissionPhoto : NSObject 
{
    UIImage *image;
    NSNumber *timestamp;
    WAGeolocation *location;
}

/**
 The RKObjectMapping that can be used to serialize/deserialize
 this class using RestKit.
 */
+ (RKObjectMapping *)objectMapping;

/**
 A convenience method for creating a WASubmissionPhoto from
 the result data of a UIImagePickerController.
 
 This method is asynchronous and returns immediately due to use of
 AssetsLibrary for accessing location/timestamp information of photos
 selected from the devices camera roll.
 
 If the photo selected is located on the camera roll then
 on iOS 6 and above the user will be prompted to allow the
 application access to the camera roll. On iOS 5 and below
 the user will be prompted to allow the application access to
 location services. If the user denys these or location services
 is not enabled on iOS 5 and below this method will fail.
 
 **NOTE:** Only images are supported.
 
 **NOTE:** iOS 6: requires access to photo library for photos from camera roll
 
 **NOTE:** iOS 5 and below: for photos from camera roll requires access
 to location services, and location services must be enabled
 
 @param dict the dictionary returned by a UIImagePickerController
 @param resultBlock the block called whith the WASubmissionPhoto when successfull
 @param failureBlock called when a failure occurs
 */
+ (void)photoWithMediaPickingInfo:(NSDictionary *)dict
					  resultBlock:(void (^)(WASubmissionPhoto *photo))resultBlock
					 failureBlock:(void (^)(NSError *error))failureBlock;

/**
 Initilize a WASubmissionPhoto with the specified parameters
 
 @param image the image
 @param timestamp the UNIX time at which the photo was taken
 @param location the location the the photo was taken at - optional.
 */
- (id)initWithPhoto:(UIImage *)image timestamp:(time_t)timestamp location:(WAGeolocation *)location;

/** The location this photo was taken at, may be nil */
@property (atomic, readonly) WAGeolocation *location;
/** The UNIX time the photo was taken at */
@property (atomic, readonly) NSNumber *timestamp;
/** The image data for this photo */
@property (atomic, readonly) UIImage *image;
@end

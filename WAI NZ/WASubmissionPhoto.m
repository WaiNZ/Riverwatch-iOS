//
//  WASubmissionPhoto.m
//  WAI NZ
//
//  Created by Tom Greenwood-Thessman on 8/15/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WASubmissionPhoto.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import "NSDate+TimeConversions.h"

@implementation WASubmissionPhoto

- (id)initWithPhoto:(UIImage *)photo timestamp:(time_t)time location:(CLLocation *)loc {
    self = [super init];
    if (self) {
        image = photo;
        timestamp = time;
        location = loc;
    }
    return self;
}

+ (void)photoWithMediaPickingInfo:(NSDictionary *)dict
					  resultBlock:(void (^)(WASubmissionPhoto *photo))resultBlock
					 failureBlock:(void (^)(NSError *error))failureBlock {
	// TODO: test dates work on all version of iOS
	
	// Extract the image object
	UIImage *_image = [dict objectForKey:UIImagePickerControllerOriginalImage];
	// Declare variables to hold date/location information
	// These are prefixed with __block so that they can be modified asynchronously by the callbacks from ALAssetsLibrary
	__block NSDate *date = nil;
	__block CLLocation *location = nil;
	
	// Delcare a helper block to avoide having to type this code multiple times
	void (^success)(void) = ^{
		if(resultBlock) {
			resultBlock([[WASubmissionPhoto alloc] initWithPhoto:_image timestamp:[date UNIXTimestamp] location:location]);
		}
	};
	
	NSDictionary *metadata;
	if((metadata = [dict objectForKey:@"UIImagePickerControllerMediaMetadata"])) { // TODO: check 4.0 support
		// If the dictionary contains metadata info - i.e. user took a photo
		
		NSString *dateString;
		
		// Get the date from the Exif dictionary
		NSDictionary *exif = [metadata objectForKey:@"{Exif}"];
		dateString = [exif objectForKey:@"DateTimeOriginal"];
		
		if(!dateString) {
			// If the date wasn't in the Exif
			
			// Get the date from the TIFF dictionary
			NSDictionary *tiff = [metadata objectForKey:@"{TIFF}"];
			dateString = [tiff objectForKey:@"DateTime"];
			
			// TODO: no date!!! error
		}
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];
		date = [dateFormatter dateFromString:dateString];
		
		// All good
		success();
	}
	else {
		// If this isn't a photo with metadata - i.e. selected from camera roll
		
		NSURL *assetsURL;
		if((assetsURL = [dict objectForKey:@"UIImagePickerControllerReferenceURL"])) { // TODO: check 4.0 support
			// If it has an assets url that we can look up metadata with
			
			// Get a link to the assets library
			ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
			// Load this asset
			[library assetForURL:assetsURL
					 resultBlock:^(ALAsset *asset) {
						 // Asset was loaded
						 
						 // Get the date
						 id tmpDate = [asset valueForProperty:ALAssetPropertyDate];
						 if(tmpDate != ALErrorInvalidProperty) {
							 date = tmpDate;
						 }
						 else {
							 // TODO: Error??
						 }
						 
						 // Get the optional location
						 id tmpLocation = [asset valueForProperty:ALAssetPropertyLocation];
						 if(tmpLocation != ALErrorInvalidProperty) {
							 location = tmpLocation;
						 }
						 
						 // All good
						 success();
					 }
					failureBlock:^(NSError *error) {
						// Error looking up the asset
						// TODO: error!!!!!
					}];
		}
		else {
			// Unrecognized image selection!
			
			// TODO: error!!!!!
			
#if TARGET_IPHONE_SIMULATOR
			date = [NSDate date];
			success();
#endif
		}
	}
}

@synthesize location;
@synthesize timestamp;
@synthesize image;
@end

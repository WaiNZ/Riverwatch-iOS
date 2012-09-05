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
#import <RestKit/RestKit.h>
#import <RestKit/NSData+Base64.h>
#import "UIImage+Resize.h"
#import "WAAppDelegate.h"
#import <dispatch/dispatch.h>

#define WAIT_FOR_DISK_SAVE [saveToDiskLock lockWhenCondition:kSaveToDiskLockOk]; [saveToDiskLock unlock];

static const NSInteger kSaveToDiskLockLocked = 0;
static const NSInteger kSaveToDiskLockOk = 1;

@implementation WASubmissionPhoto

+ (RKObjectMapping *)objectMapping {
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[WASubmissionPhoto class]];
	[mapping mapKeyPath:@"timestamp" toAttribute:@"timestamp"];
	[mapping mapKeyPath:@"data" toAttribute:@"base64String"];
	[mapping mapKeyPath:@"geolocation" toRelationship:@"location" withMapping:[WAGeolocation objectMapping]];
	
	return mapping;
}

- (id)initWithPhoto:(UIImage *)photo timestamp:(time_t)time location:(WAGeolocation *)loc {
    self = [super init];
    if (self) {
        
        //image = photo;
		if(time != 0) {
			timestamp = @(time);
		}
        filename = [NSString stringWithFormat:@"%p",self];
        location = loc;
		size = photo.size;
		saveToDiskLock = [[NSConditionLock alloc] initWithCondition:kSaveToDiskLockLocked];
		thumbImage = [photo thumbnailImage:(90*((WAAppDelegate *)[UIApplication sharedApplication].delegate).window.screen.scale) transparentBorder:0 cornerRadius:0 interpolationQuality:kCGInterpolationDefault];
		
		// Save to disk in background thread
        dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		dispatch_async(globalQueue, ^{
			[saveToDiskLock lock];
			
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *pathToDocuments=[paths objectAtIndex:0];
			NSString *savedImagePath = [pathToDocuments stringByAppendingPathComponent:filename];
			NSData *photoData = UIImageJPEGRepresentation(photo, 0.9f);
			[photoData writeToFile:savedImagePath atomically:YES];
			
			NSLog(@"Finished writing photo to disk");
			
			[saveToDiskLock unlockWithCondition:kSaveToDiskLockOk];
		});
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
	__block WAGeolocation *location = nil;
	
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
						 if(tmpLocation && tmpLocation != ALErrorInvalidProperty) {
							 location = [WAGeolocation geolocationWithCLLocation:tmpLocation];
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

#pragma mark - Utilities

- (UIImage *) retrieveFullsizeImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:filename];
    UIImage *img = [UIImage imageWithContentsOfFile:getImagePath];
    return img;
}

-(void) removePhotoFromDisk{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathToDocuments=[paths objectAtIndex:0];
    NSString *savedImagePath = [pathToDocuments stringByAppendingPathComponent:filename];
    NSError *error = nil;
    [fileManager removeItemAtPath:savedImagePath error:&error];
}

#pragma mark - Getters/Setters

- (CGSize)estimatedImageSize:(WASubmissionPhotoSize)photoScale {
	CGSize scaledSize;
	switch(photoScale) {
		case kWASubmissionPhotoSizeActual:
			scaledSize = self.fullsizeImage.size;
			break;
		case kWASubmissionPhotoSizeSmall:
			scaledSize = CGSizeMake(1024, 1024);
			break;
		case kWASubmissionPhotoSizeMedium:
			scaledSize = CGSizeMake(1536, 1536);
			break;
		case kWASubmissionPhotoSizeLarge:
			scaledSize = CGSizeMake(2048, 2048);
			break;
	}
	return scaledSize;
}

- (size_t)estimatedFileSize:(WASubmissionPhotoSize)photoScale {
	return 0.25 * [self estimatedImageSize:photoScale].width * [self estimatedImageSize:photoScale].height;
}

- (UIImage *) fullsizeImage{
	WAIT_FOR_DISK_SAVE;
	
	@synchronized(self) {
		if(fullsizeImage==NULL){
			fullsizeImage=[self retrieveFullsizeImage];
		}
	}
		
	return fullsizeImage;
}

- (UIImage *)thumbImage {
	return thumbImage;
}

- (NSString *)base64String {
	UIImage *scaledImage = self.fullsizeImage;
	if(photoScaleSize != kWASubmissionPhotoSizeActual) {
		scaledImage = [self.fullsizeImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit
															   bounds:[self estimatedImageSize:photoScaleSize]
												 interpolationQuality:kCGInterpolationDefault];
	}
	
	// TODO: just return data on disk? faster?
	return [UIImageJPEGRepresentation(scaledImage, kJPEGCompressionQuality) base64EncodedString];
}

#pragma mark - Properties

@synthesize location;
@synthesize timestamp;
@synthesize thumbImage;
@synthesize photoScaleSize;
@synthesize size;
@synthesize filename;
@end

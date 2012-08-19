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
	UIImage *_image = [dict objectForKey:UIImagePickerControllerOriginalImage];
	__block NSDate *date = nil;
	__block CLLocation *location = nil;
	
	void (^success)(void) = ^{
		if(resultBlock) {
			resultBlock([[WASubmissionPhoto alloc] initWithPhoto:_image timestamp:[date UNIXTimestamp] location:location]);
		}
	};
	
	NSDictionary *metadata;
	if((metadata = [dict objectForKey:@"UIImagePickerControllerMediaMetadata"])) { // TODO: check 4.0 support
		NSDictionary *exif = [metadata objectForKey:@"{Exif}"];
		date = [exif objectForKey:@"DateTimeOriginal"];
		
		if(!date) {
			NSDictionary *tiff = [metadata objectForKey:@"{TIFF}"];
			date = [tiff objectForKey:@"DateTime"];
		}
		
		success();
	}
	else {
		NSURL *assetsURL;
		if((assetsURL = [dict objectForKey:@"UIImagePickerControllerReferenceURL"])) { // TODO: check 4.0 support
			ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
			[library assetForURL:assetsURL
					 resultBlock:^(ALAsset *asset) {
						 id tmpDate = [asset valueForProperty:ALAssetPropertyDate];
						 if(tmpDate != ALErrorInvalidProperty) {
							 date = tmpDate;
						 }
						 
						 id tmpLocation = [asset valueForProperty:ALAssetPropertyLocation];
						 if(tmpLocation != ALErrorInvalidProperty) {
							 location = tmpLocation;
						 }
						 
						 success();
					 }
					failureBlock:^(NSError *error) {
						// TODO: error!!!!!
					}];
		}
		else {
			// TODO: error!!!!!
		}
	}
}

@end

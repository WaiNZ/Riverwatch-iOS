//
//  WASubmission.m
//  WAI NZ
//
//  Created by Tom Greenwood-Thessman on 8/15/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WASubmission.h"

#import "UIAlertView+Blocks.h"
#import <RestKit/RestKit.h>

#define POST_UPDATE_NOTIFICATION [[NSNotificationCenter defaultCenter] postNotificationName:kWASubmissionUpdatedNotification object:self]

NSString *const kWASubmissionUpdatedNotification = @"kWASubmissionUpdatedNotification";

@interface WASubmission ()
@property (nonatomic, assign) NSNumber *_rk_timestamp;
@property (nonatomic, assign) NSDictionary *_rk_councilSubmission;
@end

@implementation WASubmission

+ (RKObjectMapping *)objectMapping {
	RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[WASubmission class]];
	[mapping mapKeyPath:@"timestamp" toAttribute:@"_rk_timestamp"];
	[mapping mapKeyPath:@"user_description" toAttribute:@"descriptionText"];
	[mapping mapKeyPath:@"tags" toAttribute:@"tags"];
	[mapping mapKeyPath:@"udid" toAttribute:@"udid"];
	[mapping mapKeyPath:@"photo_data" toRelationship:@"photos" withMapping:[WASubmissionPhoto objectMapping]];
	[mapping mapKeyPath:@"geolocation" toRelationship:@"location" withMapping:[WAGeolocation objectMapping]];
	[mapping mapKeyPath:@"council_submission" toAttribute:@"_rk_councilSubmission"];
	
	return mapping;
}

- (id)init {
    self = [super init];
    if (self) {
        photos = [[NSMutableArray alloc] init];
        tags = [[NSMutableArray alloc] init];
        descriptionText = @"";
        email = @"";
        anonymous = NO;
        location = nil;
        time(&timestamp);
		udid = @"";
    }
    return self;
}

#pragma mark - Getters/Setters

- (void)addSubmissionPhoto:(WASubmissionPhoto *)photo {
    [photos addObject:photo];
	POST_UPDATE_NOTIFICATION;
}

- (void)removeSubmissionPhoto:(int)index {
	if(photos.count > 1) {
		[photos removeObjectAtIndex:index];
		POST_UPDATE_NOTIFICATION;
	}
	else {
		// TODO: assert, exception, warning...?
	}
}

- (void)removeSubmissionPhotoAtIndex:(int)index withConfirmation:(void (^)(int index))callback{
	// TODO: Bit icky having this code in a model object, MVC all the way. Maybe categoryize it?
	if(index>=0 &&index<photos.count){
		if(photos.count>1){
			UIAlertView *confirmDelete = [[UIAlertView alloc] initWithTitle:@"Confirm deletion"
																	message:@"Are you sure you wish to delete this image? This can't be undone."
															  okButtonTitle:@"Delete"
														  cancelButtonTitle:@"Cancel"
															dismissCallback:^(NSInteger buttonIndex) {
																if(buttonIndex == 0) {
																	// Dont care
																}
																if(buttonIndex == 1) {
																	[self removeSubmissionPhoto:index];
																	if(callback) {
																		callback(index);
																	}
																}
															}];
			
			[confirmDelete show];
		}
		else {
			UIAlertView *cantDeleteLastPhoto = [[UIAlertView alloc] initWithTitle:@"Can't delete last photo"
																		  message:@"Every submission to WAI NZ must include at least one photo, you are attempting to delete the last one."
																		 delegate:nil
																cancelButtonTitle:@"Ok"
																otherButtonTitles:nil];
			
			[cantDeleteLastPhoto show];
		}
	}
}


- (WASubmissionPhoto *)submissionPhotoAtIndex:(int)index {
    return [photos objectAtIndex:index];
}

- (int)numberOfSubmissionPhotos {
    return [photos count];
}

- (void)addTag:(NSString *)tag {
    [tags addObject:tag];
	POST_UPDATE_NOTIFICATION;
}

- (void)removeTag:(int)index {
    [tags removeObjectAtIndex:index];
	POST_UPDATE_NOTIFICATION;
}

- (NSString *)tagAtIndex:(int)index {
    return [tags objectAtIndex:index];
}

- (int)numberOfTags {
    return [tags count];
}

- (void)setDescriptionText:(NSString *)_descriptionText {
	descriptionText = _descriptionText;
	POST_UPDATE_NOTIFICATION;
}

- (void)setEmail:(NSString *)_email {
	email = _email;
	POST_UPDATE_NOTIFICATION;
}

- (void)setAnonymous:(BOOL)_anonymous {
	anonymous = _anonymous;
	POST_UPDATE_NOTIFICATION;
}

- (void)setLocation:(WAGeolocation *)_location {
	location = _location;
	POST_UPDATE_NOTIFICATION;
}

- (void)setTimestamp:(time_t)_timestamp {
	timestamp = _timestamp;
	POST_UPDATE_NOTIFICATION;
}

- (void)setPhotoScaleSize:(WASubmissionPhotoSize)photoScaleSize {
	for(WASubmissionPhoto *photo in photos) {
		photo.photoScaleSize = photoScaleSize;
	}
}

#pragma mark - Private Getters/Setters

- (NSNumber *)_rk_timestamp {
	return @(timestamp);
}

- (void)set_rk_timestamp:(NSNumber *)_timestamp {
	timestamp = _timestamp.longValue;
}

- (NSDictionary *)_rk_councilSubmission {
	if(anonymous) {
		return @{@"anonymous": @(anonymous)};
	}
	else {
		return @{
			@"anonymous": @(anonymous),
			@"email_address": email
		};
	}
}

- (void)set_rk_councilSubmission:(NSDictionary *)_rk_councilSubmission {
	anonymous = [[_rk_councilSubmission objectForKey:@"anonymous"] boolValue];
	email = [_rk_councilSubmission objectForKey:@"email_address"];
}

@synthesize descriptionText;
@synthesize email;
@synthesize anonymous;
@synthesize location;
@synthesize timestamp;
@synthesize udid;
@end

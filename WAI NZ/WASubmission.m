//
//  WASubmission.m
//  WAI NZ
//
//  Created by Tom Greenwood-Thessman on 8/15/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WASubmission.h"

#import "UIAlertView+Blocks.h"

#define POST_UPDATE_NOTIFICATION [[NSNotificationCenter defaultCenter] postNotificationName:kWASubmissionUpdatedNotification object:self]

NSString *const kWASubmissionUpdatedNotification = @"kWASubmissionUpdatedNotification";

@implementation WASubmission

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
        
    }
    return self;
}

- (void)addSubmissionPhoto:(WASubmissionPhoto *)photo {
    [photos addObject:photo];
	POST_UPDATE_NOTIFICATION;
}

- (void)removeSubmissionPhoto:(int)index {
    [photos removeObjectAtIndex:index];
	POST_UPDATE_NOTIFICATION;
}

- (void) removeSubmissionPhotoAtIndex:(int)index withConfirmation:(void (^)(int index))callback{
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


- (WASubmissionPhoto *)getSubmissionPhoto:(int)index {
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

- (NSString *)getTag:(int)index {
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

- (void)setLocation:(CLLocation *)_location {
	location = _location;
	POST_UPDATE_NOTIFICATION;
}

- (void)setTimestamp:(time_t)_timestamp {
	timestamp = _timestamp;
	POST_UPDATE_NOTIFICATION;
}

@synthesize descriptionText;
@synthesize email;
@synthesize anonymous;
@synthesize location;
@synthesize timestamp;
@synthesize udid;
@end

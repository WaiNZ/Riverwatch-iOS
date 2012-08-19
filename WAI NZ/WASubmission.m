//
//  WASubmission.m
//  WAI NZ
//
//  Created by Tom Greenwood-Thessman on 8/15/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WASubmission.h"

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

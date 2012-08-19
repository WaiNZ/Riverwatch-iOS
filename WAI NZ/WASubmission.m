//
//  WASubmission.m
//  WAI NZ
//
//  Created by Tom Greenwood-Thessman on 8/15/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WASubmission.h"

@implementation WASubmission

- (id)init {
    self = [super init];
    if (self) {
        photos = [[NSMutableArray alloc] init];
        tags = [[NSMutableArray alloc] init];
        descriptionText = [[NSString alloc] init];
        email = [[NSString alloc] init];
        anonymous = NO;
        location = nil;
        time(&timestamp);
        
    }
    return self;
}

- (void)addSubmissionPhoto:(WASubmissionPhoto *)photo {
    [photos addObject:photo];
}

- (void)removeSubmissionPhoto:(int)index {
    [photos removeObjectAtIndex:index];
}

- (WASubmissionPhoto *)getSubmissionPhoto:(int)index {
    return [photos objectAtIndex:index];
}

- (int)numberOfSubmissionPhotos {
    return [photos count];
}

- (void)addTag:(NSString *)tag {
    [tags addObject:tag];
}

- (void)removeTag:(int)index {
    [tags removeObjectAtIndex:index];
}

- (NSString *)getTag:(int)index {
    return [tags objectAtIndex:index];
}

- (int)numberOfTags {
    return [tags count];
}

@synthesize descriptionText;
@synthesize email;
@synthesize anonymous;
@synthesize location;
@synthesize timestamp;
@synthesize udid;
@end

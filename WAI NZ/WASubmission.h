//
//  WASubmission.h
//  WAI NZ
//
//  Created by Tom Greenwood-Thessman on 8/15/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "WASubmissionPhoto.h"

@interface WASubmission : NSObject
{
    NSMutableArray *photos;
    NSMutableArray *tags;
    NSString *descriptionText;
    NSString *email;
    BOOL isAnonymous;
    CLLocation *location;
    time_t timestamp;
    NSString *udid;
    
}

- (void)addSubmissionPhoto:(WASubmissionPhoto *)photo;

- (void)removeSubmissionPhoto:(int)index;

- (WASubmissionPhoto *)getSubmissionPhoto:(int)index;

- (int)numberOfSubmissionPhotos;

- (void)addTag:(NSString *)tag;

- (void)removeTag:(int)index;

- (NSString *)getTag:(int)index;

- (int)numberOfTags;



@property(strong) NSString *descriptionText;
@property(strong) NSString *email;
@property BOOL isAnonymous;
@property(strong) CLLocation *location;
@property time_t timestamp;
@property(strong) NSString *udid;
@end

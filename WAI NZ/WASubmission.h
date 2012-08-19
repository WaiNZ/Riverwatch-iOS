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
    BOOL anonymous;
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



@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, getter=isAnonymus) BOOL anonymous;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic) time_t timestamp;
@property (nonatomic, strong) NSString *udid;
@end

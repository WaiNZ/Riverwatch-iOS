//
//  WASubmission.h
//  WAI NZ
//
//  Created by Tom Greenwood-Thessman on 8/15/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WASubmissionPhoto.h"
#import "WAGeolocation.h"

@class RKObjectMapping;

extern NSString *const kWASubmissionUpdatedNotification;

@interface WASubmission : NSObject {
    NSMutableArray *photos;
    NSMutableArray *tags;
    NSString *descriptionText;
    NSString *email;
    BOOL anonymous;
    WAGeolocation *location;
	time_t timestamp;
    NSString *udid;
    
}

+ (RKObjectMapping *)objectMapping;

- (void)addSubmissionPhoto:(WASubmissionPhoto *)photo;
- (void)removeSubmissionPhoto:(int)index;
- (void)removeSubmissionPhotoAtIndex:(int)index withConfirmation:(void (^)(int index))callback;
- (WASubmissionPhoto *)submissionPhotoAtIndex:(int)index;
- (void)addTag:(NSString *)tag;
- (void)removeTag:(int)index;
- (NSString *)tagAtIndex:(int)index;



@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, getter=isAnonymous) BOOL anonymous;
@property (nonatomic, strong) WAGeolocation *location;
@property (nonatomic, readonly) time_t timestamp;
@property (nonatomic, readonly) NSString *udid;
@property (nonatomic, readonly) NSInteger numberOfSubmissionPhotos;
@property (nonatomic, readonly) NSInteger numberOfTags;
@end

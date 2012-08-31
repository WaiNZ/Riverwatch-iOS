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

/**
 The model object representing a submission to WAI NZ
 
  TODO: constraints, last photo eg. verification
 */
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

/**
 The RKObjectMapping that can be used to serialize/deserialize
 this class using RestKit.
 */
+ (RKObjectMapping *)objectMapping;

/**
 Add the specified WASubmissionPhoto to this submission
 
 @param photo the WASubmissionPhoto to add
 */
- (void)addSubmissionPhoto:(WASubmissionPhoto *)photo;
/**
 Remove the WASubmissionPhoto at the specified index
 
 @warning TODO: document what happens on out of bounds, or deleting last photo
 
 @param index the index of the photo to remove
 */
- (void)removeSubmissionPhoto:(int)index;
/**
 This method presents the applicable user interfaces to the user 
 before actually deleting the photo.
 
 This method wraps the checks for out of bounds, deleting last photo
 and provides a unified interface to the user for confirming deleting
 and dealing with errors.
 
 If the user confirms the deleting and the photo can be deleted then
 the callback block will be executed. The callback block will have the
 index of the photo deleted passed in as a parameter.
 
 @param index the index of the photo to delete
 @param callback the callback block to execute if the photo deletion has occured
 */
- (void)removeSubmissionPhotoAtIndex:(int)index withConfirmation:(void (^)(int index))callback;
/**
 Get the WASubmissionPhoto at the speicifed index
 
 @param index the index of the photo to retreive
 @return the WASubmissionPhoto at the specified index
 
 // TODO: exception, return nil...
 */
- (WASubmissionPhoto *)submissionPhotoAtIndex:(int)index;
/**
 Add a tag to this submission
 
 @param tag the tag to add
 */
- (void)addTag:(NSString *)tag;
/**
 Remove the tag at the specified index
 
 @param index the index of the tag to remove
 
 // TODO: exception
 */
- (void)removeTag:(NSString *) tag;
/**
 Get the tag at the specified index
 
 @param index the index of the tag to retreive
 @return the tag at the specified index
 
 // TODO: exception, return nil...
 */
- (NSString *)tagAtIndex:(int)index;

-(BOOL) containsTag:(NSString *)tag;

// TODO: -verify

/** The description the user has entered */
@property (nonatomic, strong) NSString *descriptionText;
/** The email address to be submitted to the council if the submission is not anonymous */
@property (nonatomic, strong) NSString *email;
/** Whether the submission should include the email address when sent to the council */
@property (nonatomic, getter=isAnonymous) BOOL anonymous;
/** The location this submission was observed at */
@property (nonatomic, strong) WAGeolocation *location;
/** The time at which this submission was observed */
@property (nonatomic, readonly) time_t timestamp;
/** The udid of the device the submission was made on */
@property (nonatomic, readonly) NSString *udid;
/** The number of photos attached to this submission */
@property (nonatomic, readonly) NSInteger numberOfSubmissionPhotos;
/** The number of tags on this submission */
@property (nonatomic, readonly) NSInteger numberOfTags;
@end

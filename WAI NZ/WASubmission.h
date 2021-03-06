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
#import <MapKit/MapKit.h>

@class RKObjectMapping;

extern NSString *const kWASubmissionUpdatedNotification;

/**
 The model object representing a submission to WAI NZ
 
  TODO: constraints, last photo eg. verification
 */
@interface WASubmission : NSObject <MKAnnotation> {
    NSMutableArray *photos;
    NSMutableArray *tags;
    NSString *descriptionText;
    NSString *email;
    BOOL anonymous;
    WAGeolocation *location;
    NSString *udid;
    
}

#pragma mark - Object Mapping
///-----------------------------------------------------------------------------
/// @name Object mapping
///-----------------------------------------------------------------------------

/**
 The RKObjectMapping that can be used to serialize/deserialize
 this class using RestKit.
 */
+ (RKObjectMapping *)objectMapping;

#pragma mark - Editing submissions
///-----------------------------------------------------------------------------
/// @name Editing submissions
///-----------------------------------------------------------------------------

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
 Add a tag to this submission
 
 @param tag the tag to add
 */
- (void)addTag:(NSString *)tag;
/**
 Remove the specified tag
 
 @param tag the tag to remove
 
 // TODO: exception
 */
- (void)removeTag:(NSString *)tag;
/**
 Set the submission photo size of all the photos in the submission
 
 @param photoScaleSize the scale size to set all the photos to
 */
- (void)setPhotoScaleSize:(WASubmissionPhotoSize)photoScaleSize;

#pragma mark - Attribtues
///-----------------------------------------------------------------------------
/// @name Attributes
///-----------------------------------------------------------------------------

/**
 Get the WASubmissionPhoto at the speicifed index
 
 @param index the index of the photo to retreive
 @return the WASubmissionPhoto at the specified index
 
 // TODO: exception, return nil...
 */
- (WASubmissionPhoto *)submissionPhotoAtIndex:(int)index;
/**
 Get the tag at the specified index
 
 @param index the index of the tag to retreive
 @return the tag at the specified index
 
 // TODO: exception, return nil...
 */
- (NSString *)tagAtIndex:(int)index;
/**
 Check to see if a tag is attached to the submission
 
 @param tag the tag to check for
 @return YES if the submission is tagged with the specified tag, NO otherwise
 */
- (BOOL)containsTag:(NSString *)tag;
/**
 This returns a string of the tags selected in the submission with ", " as the seperator
 
 @return NSString the string containing the tags of the submission
 */
- (NSString *)tagsAsString;
/**
 Gets the latest timestamp from the submission photos
 
 @return time_t the timestamp found to be the latest
 */
- (time_t)latestTimestamp;
/**
 Gets the earliest timestamp from the submission photos
 
 @return time_t the timestamp found to be the earliest
 */
- (time_t)timestamp;

/** The description the user has entered */
@property (nonatomic, strong) NSString *descriptionText;
/** The email address to be submitted to the council if the submission is not anonymous */
@property (nonatomic, strong) NSString *email;
/** Whether the submission should include the email address when sent to the council */
@property (nonatomic, getter=isAnonymous) BOOL anonymous;
/** The location this submission was observed at */
@property (nonatomic, copy) WAGeolocation *location;
/** The time at which this submission was observed */
@property (nonatomic, readonly) time_t timestamp;
/** The udid of the device the submission was made on */
@property (nonatomic, readonly) NSString *udid;
/** The number of photos attached to this submission */
@property (nonatomic, readonly) NSInteger numberOfSubmissionPhotos;
/** The number of tags on this submission */
@property (nonatomic, readonly) NSInteger numberOfTags;

#pragma mark - Caching
///-----------------------------------------------------------------------------
/// @name Caching
///-----------------------------------------------------------------------------

/**
 Clear the photo files form disk upon submission
*/
- (void)unloadPhotos;

#pragma mark - Verification
///-----------------------------------------------------------------------------
/// @name Verification
///-----------------------------------------------------------------------------

// TODO: category
/**
 This vefiries whether the information contained in the submission is valid including the email address(if provided) and the location of the submission
 
 @return UIAlertView returns an UIAlertView if there is an error in the submission details, else nil
 */
- (UIAlertView *)verify;
/**
 Checks whether the timestamp of the photo to be added will be within the 24 hour period of the submission
 
 @param photo the photo that is to be added to the submission
 @return UIAlertView returns an UIAlertView if the photo breaks the timestamp conditions, else nil
*/
- (UIAlertView *) verifyPhotoTimestamp:(WASubmissionPhoto *)photo;

@end

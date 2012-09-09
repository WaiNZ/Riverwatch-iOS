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
		udid = @"";
    }
    return self;
}

#pragma mark - MKAnnotation

- (CLLocationCoordinate2D)coordinate {
	if(location) {
		return location.coordinate;
	}
	else {
		return kNewZealandRegion.center;
	}
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
	if(!location) {
		location = [[WAGeolocation alloc] init];
	}
	
	location.coordinate = newCoordinate;
}

- (NSString *)title {
	return @"Drag me to specify the location";
}

#pragma mark - Actions

- (UIAlertView *)verify {
	if(!location) {
		return [[UIAlertView alloc] initWithTitle:@"No location specified"
										  message:@"Every submission to WAI NZ must include a location, please go back and specify where these photos were taken."
										 delegate:nil
								cancelButtonTitle:@"Ok"
								otherButtonTitles:nil];
	}
	NSLog(@"location lat: %f ", location.latitude );
    NSLog(@"NZRegion lat-span: %f", kNewZealandRegion.center.latitude - kNewZealandRegion.span.latitudeDelta);
    NSLog(@"NZRegion lat+span: %f", kNewZealandRegion.center.latitude + kNewZealandRegion.span.latitudeDelta);
    NSLog(@"location long: %f ", location.longitude );
    NSLog(@"NZRegion long-span: %f", kNewZealandRegion.center.longitude - kNewZealandRegion.span.longitudeDelta);
    NSLog(@"NZRegion long+span: %f", kNewZealandRegion.center.longitude + kNewZealandRegion.span.longitudeDelta);
    
	if((location.latitude < (kNewZealandRegion.center.latitude - kNewZealandRegion.span.latitudeDelta)) ||
	   (location.latitude > (kNewZealandRegion.center.latitude + kNewZealandRegion.span.latitudeDelta)) ||
	   (location.longitude < (kNewZealandRegion.center.longitude - kNewZealandRegion.span.longitudeDelta)) ||
	   (location.longitude > (kNewZealandRegion.center.longitude + kNewZealandRegion.span.longitudeDelta))) { // TODO: chattams?
		return [[UIAlertView alloc] initWithTitle:@"Submissions from NZ only"
										  message:@"WAI NZ only accepts submissions from New Zealand, sorry about that."
										 delegate:nil
								cancelButtonTitle:@"Ok"
								otherButtonTitles:nil];
	}
	
    if(!anonymous){
        if(! [self NSStringIsValidEmail:(email)]){
            return [[UIAlertView alloc] initWithTitle:@"Invalid email address"
                                              message:@"We didn't recognise your email address, please check it is correct and try again."
										 delegate:nil
								cancelButtonTitle:@"Ok"
								otherButtonTitles:nil];
        }
    }
	
	return nil;
}


-(BOOL) NSStringIsValidEmail:(NSString *)checkString{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


#pragma mark - Getters/Setters

- (void)addSubmissionPhoto:(WASubmissionPhoto *)photo {
    UIAlertView *result = [self verifyPhotoTimestamp:(photo)];
	if(result == Nil){
		[photos addObject:photo];
		POST_UPDATE_NOTIFICATION;
	}
	else{
		[result show];
	}
}

- (void)removeSubmissionPhoto:(int)index {
	if(photos.count > 1) {
        [[photos objectAtIndex:index] removePhotoFromDisk];
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

- (void) unloadPhotos {
    for(int i = 0;i<[photos count];i++){
        [[photos objectAtIndex:i] removePhotoFromDisk];
    }
}



- (void)addTag:(NSString *)tag {
    [tags addObject:tag];
	POST_UPDATE_NOTIFICATION;
}

- (void)removeTag: (NSString *)tag {
    for(int i = 0;i<[tags count];i++){
        if([[tags objectAtIndex:i] isEqualToString:tag]){
            [tags removeObjectAtIndex:i];
            break;
        }
    }

	POST_UPDATE_NOTIFICATION;
}

- (NSString *)tagAtIndex:(int)index {
    return [tags objectAtIndex:index];
}

- (int)numberOfTags {
    return [tags count];
}

-(BOOL) containsTag:(NSString *)tag{
    for(int i = 0;i<[tags count];i++){
        if([[tags objectAtIndex:i] isEqualToString:tag]){
            return TRUE;
        }
    }
    return FALSE;
    
   // return [tags containsObject:tag];
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

- (void)setPhotoScaleSize:(WASubmissionPhotoSize)photoScaleSize {
	for(WASubmissionPhoto *photo in photos) {
		photo.photoScaleSize = photoScaleSize;
	}
}

- (NSString *)tagsAsString {
	NSMutableString *parts = [[NSMutableString alloc] init];
	
	NSString *seperator = @"";
	for(NSString *string in tags){
        [parts appendFormat:@"%@%@", seperator, string];
		seperator = @", ";
    }
	
	return parts;
}

- (time_t)timestamp {
	time_t ret = LONG_MAX;
	for(WASubmissionPhoto *photo in photos) {
		if(photo.timestamp) {
			ret = MIN(ret, photo.timestamp.longValue);
		}
	}
	return ret;
}

- (time_t) latestTimestamp{
    time_t ret = LONG_MIN;
    for(WASubmissionPhoto *photo in photos) {
		if(photo.timestamp) {
			ret = MAX(ret, photo.timestamp.longValue);
		}
    }
    return ret;
}


- (UIAlertView *) verifyPhotoTimestamp:(WASubmissionPhoto *)photo{
    //The earliest timestamp
    time_t early = [self timestamp];
	//NSDebug(@"Current earliest photo time is %ld",early);
    //The latest timestamp
    time_t last = [self latestTimestamp];
	//NSDebug(@"Current last photo time is %ld",last);

	time_t photoTime = photo.timestamp.unsignedLongValue;
    //NSDebug(@"Verifying photo timestamp: %ld",photoTime);
    
    time_t max = MAX(photoTime, last);
	//NSDebug(@"Max time is %ld",max);

    time_t min = MIN(photoTime, early);
    //NSDebug(@"Min time is: %ld",min);
	
	//NSDebug(@"Difference is: %ld", max-min);
    
    /*(photoTime - early < 86400) ||
     (last - photoTime > 86400) ||
     (abs(photoTime - last) < 86400) ||
     (abs(early - photoTime) < 86400)*/
    //if the difference is greater than 24 hours
    if((max - min) > 86400){
        return [[UIAlertView alloc] initWithTitle:@"Photo times are too different"
										  message:@"The photos sent to WAI NZ must all have been taken within a 24 hour period, please submit this photo separately."
										 delegate:nil
								cancelButtonTitle:@"Ok"
								otherButtonTitles:nil];
    }

    return nil;
    
}

#pragma mark - Private Getters/Setters

- (NSNumber *)_rk_timestamp {
	return @(self.timestamp);
}

- (void)set_rk_timestamp:(NSNumber *)_timestamp {
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
@synthesize udid;
@end

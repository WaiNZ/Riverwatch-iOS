//
//  WASubmissionResponse.h
//  WAI NZ
//
//  Created by Melby Ruarus on 1/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectMapping;

/**
 A model object that represents a response from the WAI NZ API after a submission
 has been submitted.
 */
@interface WASubmissionResponse : NSObject {
	NSString *status;
	NSString *errorMessage;
	NSURL *url;
}

/**
 Get the object mapping for this class
 */
+ (RKObjectMapping *)objectMapping;

/** The status message, should be "OK" or "ERROR" */
@property (nonatomic, strong) NSString *status;
/** An optional error message to describe the error if it occurs */
@property (nonatomic, strong) NSString *errorMessage;
/** A url that points to a public web page where the submission can be viewd publically */
@property (nonatomic, strong) NSURL *url;
@end

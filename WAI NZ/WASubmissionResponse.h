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

///-----------------------------------------------------------------------------
/// @name Object mapping
///-----------------------------------------------------------------------------

/**
 Get the object mapping for this class
 */
+ (RKObjectMapping *)objectMapping;

/** The status of the response */
@property (nonatomic, strong) NSString *status;
/** The error message of the response */
@property (nonatomic, strong) NSString *errorMessage;
/** The url of the reponse */
@property (nonatomic, strong) NSURL *url;
@end

//
//  WASubmissionResponse.h
//  WAI NZ
//
//  Created by Melby Ruarus on 1/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectMapping;

@interface WASubmissionResponse : NSObject {
	NSString *status;
	NSString *errorMessage;
	NSURL *url;
}

+ (RKObjectMapping *)objectMapping;

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, strong) NSURL *url;
@end

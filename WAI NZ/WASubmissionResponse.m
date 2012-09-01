//
//  WASubmissionResponse.m
//  WAI NZ
//
//  Created by Melby Ruarus on 1/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WASubmissionResponse.h"

#import <RestKit/RestKit.h>

@implementation WASubmissionResponse

+ (RKObjectMapping *)objectMapping {
	RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[WASubmissionResponse class]];
	[objectMapping mapKeyPath:@"status" toAttribute:@"status"];
	[objectMapping mapKeyPath:@"error_message" toAttribute:@"errorMessage"];
	[objectMapping mapKeyPath:@"url" toAttribute:@"url"];
	
	return objectMapping;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ (Status: \"%@\", Message: \"%@\", URL: \"%@\")", [super description], status, errorMessage, url];
}

@synthesize status;
@synthesize errorMessage;
@synthesize url;
@end

//
//  WASubmissionEmailTests.m
//  WAI NZ
//
//  Created by Ashleigh Cains on 12/09/2012.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WASubmissionEmailTests.h"
#import "WASubmission.h"





@interface WASubmission (TestPrivate)
- (UIAlertView *) verify;
@end

@implementation WASubmissionEmailTests


- (void)setUp {
    [super setUp];
}

- (void)tearDown {
	[super tearDown];
}

- (void) testWithPhoto12HoursNewer {
    WASubmission *testSubmission = [WASubmission alloc];
    WASubmissionPhoto *firstPhoto = [[WASubmissionPhoto alloc] initWithPhoto:nil timestamp:100000 location:nil];
    WASubmissionPhoto *secondPhoto = [[WASubmissionPhoto alloc] initWithPhoto:nil timestamp:143200 location:nil];
    
    [testSubmission addSubmissionPhoto:firstPhoto];
    
    UIAlertView *result = [testSubmission verifyPhotoTimestamp:secondPhoto];
    
    STAssertTrue(result == nil, @"");
    
}


@end

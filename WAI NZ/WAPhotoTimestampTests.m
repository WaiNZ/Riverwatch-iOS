//
//  WAPhotoTimestampTests.m
//  WAI NZ
//
//  Created by Tom Greenwood-Thessman on 9/9/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WAPhotoTimestampTests.h"
#import "WASubmission.h"
#import "WASubmissionPhoto.h"

@interface WASubmission (TestPrivate)
- (UIAlertView *) verifyPhotoTimestamp:(WASubmissionPhoto *)photo;
@end


@implementation WAPhotoTimestampTests


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

- (void) testWithPhotoOver24HoursNewer {
    WASubmission *testSubmission = [[WASubmission alloc] init];
    WASubmissionPhoto *firstPhoto = [[WASubmissionPhoto alloc] initWithPhoto:nil timestamp:100000 location:nil];
    WASubmissionPhoto *secondPhoto = [[WASubmissionPhoto alloc] initWithPhoto:nil timestamp:186401 location:nil];
    
    [testSubmission addSubmissionPhoto:firstPhoto];
    
    UIAlertView *result = [testSubmission verifyPhotoTimestamp:secondPhoto];
    
    STAssertFalse(result == nil, @"");
    
}

- (void) testWithPhotoUnder24HoursNewer {
    WASubmission *testSubmission = [[WASubmission alloc] init];
    WASubmissionPhoto *firstPhoto = [[WASubmissionPhoto alloc] initWithPhoto:nil timestamp:100000 location:nil];
    WASubmissionPhoto *secondPhoto = [[WASubmissionPhoto alloc] initWithPhoto:nil timestamp:186399 location:nil];
    
    [testSubmission addSubmissionPhoto:firstPhoto];
    
    UIAlertView *result = [testSubmission verifyPhotoTimestamp:secondPhoto];
    
    STAssertTrue(result == nil, @"");
    
}

- (void) testWithPhotoOver24HoursOlder {
    WASubmission *testSubmission = [[WASubmission alloc] init];
    WASubmissionPhoto *firstPhoto = [[WASubmissionPhoto alloc] initWithPhoto:nil timestamp:100000 location:nil];
    WASubmissionPhoto *secondPhoto = [[WASubmissionPhoto alloc] initWithPhoto:nil timestamp:13599 location:nil];
    
    [testSubmission addSubmissionPhoto:firstPhoto];
    
    UIAlertView *result = [testSubmission verifyPhotoTimestamp:secondPhoto];
    
    STAssertFalse(result == nil, @"");
    
}

- (void) testWithPhotoUnder24HoursOlder {
    WASubmission *testSubmission = [[WASubmission alloc] init];
    WASubmissionPhoto *firstPhoto = [[WASubmissionPhoto alloc] initWithPhoto:nil timestamp:100000 location:nil];
    WASubmissionPhoto *secondPhoto = [[WASubmissionPhoto alloc] initWithPhoto:nil timestamp:13601 location:nil];
    
    [testSubmission addSubmissionPhoto:firstPhoto];
    
    UIAlertView *result = [testSubmission verifyPhotoTimestamp:secondPhoto];
    
    STAssertTrue(result == nil, @"");
    
}


@end

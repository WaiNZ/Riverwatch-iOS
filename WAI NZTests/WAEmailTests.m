//
//  WAEmailTests.m
//  WAI NZ
//
//  Created by Ashleigh Cains on 12/09/2012.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WAEmailTests.h"
#import "WASubmission.h"

@interface WASubmission (TestPrivate)
- (UIAlertView *) verify;
@end

@implementation WAEmailTests


- (void)setUp {
    [super setUp];
}

- (void)tearDown {
	[super tearDown];
}

- (void) testWithCorrectEmail {
    WASubmission *testSubmission = [WASubmission alloc];
    NSString *email = @"syzygy@dt.net.nz";
    
    //Test location to get over the first location checker in verify
    WAGeolocation *testLoc = [[WAGeolocation alloc] init];
    testLoc.latitude = -42.47566;
    testLoc.longitude = 173.515076;
    
    [testSubmission setAnonymous:NO];
    [testSubmission setEmail:email];
    [testSubmission setLocation:testLoc];
    
    UIAlertView *result = [testSubmission verify];
    
    STAssertTrue(result == nil, @"A correctly formatted email has been denied");
    
}


- (void) testWithIncorrectEmail {
    WASubmission *testSubmission = [WASubmission alloc];
    NSString *email = @"syzygydt.net.nz";
    
    //Test location to get over the first location checker in verify
    WAGeolocation *testLoc = [[WAGeolocation alloc] init];
    testLoc.latitude = -42.47566;
    testLoc.longitude = 173.515076;
    
    [testSubmission setAnonymous:NO];
    [testSubmission setEmail:email];
    [testSubmission setLocation:testLoc];
    
    UIAlertView *result = [testSubmission verify];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid email address"
                                                    message:@"We didn't recognise your email address, please check it is correct and try again."
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    
    STAssertFalse (result == nil, @"The incorrect email was allowed");
    STAssertTrue( [result.message isEqualToString:alert.message], @"The alert returned was not the correct email alertview");
    
}

@end

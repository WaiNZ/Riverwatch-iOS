//
//  WALocationTests.m
//  WAI NZ
//
//  Created by Tom Greenwood-Thessman on 9/9/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WALocationTests.h"
#import "WASubmission.h"


@interface WASubmission (TestPrivate)
-(BOOL) locationIsInNewZealand:(WAGeolocation *) loc;
@end

@implementation WALocationTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
	[super tearDown];
}

- (void) testWithLocationInPhillipIsland {
    WAGeolocation *testLoc = [WAGeolocation alloc];

    testLoc.latitude = -29.121124;
    testLoc.longitude = 167.950376;
    STAssertFalse([[WASubmission alloc] locationIsInNewZealand:testLoc], @"Phillip Island is showing as being in NZ");
}


@end

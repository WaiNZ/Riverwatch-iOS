//
//  WASubmitTests.m
//  WAI NZ
//
//  Created by Melby Ruarus on 7/09/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WASubmitTests.h"

#import "WASubmitViewController.h"
#import "WASubmission.h"
#import <OCMock/OCMock.h>
#import "WAAppDelegate.h"

@interface WASubmitViewController (TestPrivate)
- (void)sendSubmission;
- (void)setMessage:(NSString *)message;
- (void)setNavigationTitle:(NSString *)title;
@end

@interface WASubmission (TestPrivate)
- (NSString *)jsonString;
@end
@implementation WASubmission (TestPrivate)

NSString *const kBaseSubmissionString = @"{\"council_submission\":{\"anonymous\":@anonymous@},\"udid\":\"@udid@\",\"photo_data\":[],\"user_description\":\"\",\"tags\":[@tags@],\"timestamp\":@timestamp@}";
NSString *const kResponseBodyOk = @"{\"status\":\"OK\",\"error_message\":\"\",\"url\":\"http://google.com\"}";

- (NSString *)jsonString {
	return [self applyTokens:@{
			@"@anonymous@":self.anonymous?@"true":@"false",
			@"@udid@":@"",
			@"@tags@":@"\"Cow\"",
			@"@timestamp@":[NSString stringWithFormat:@"%li", self.timestamp]
		}];
}

- (NSString *)applyTokens:(NSDictionary *)tokens {
	NSString *string = kBaseSubmissionString;
	
	for(NSString *key in tokens) {
		string = [string stringByReplacingOccurrencesOfString:key withString:[tokens objectForKey:key]];
	}
	
	return string;
}

@end

@implementation WASubmitTests

static int portNumber = 1111;

- (void)setUp {
	[super setUp];
	
	server = [[SimpleHTTPResponder alloc] init];
	server.delegate = self;
	
	[server listen:portNumber];
	[server startListening];
	
	WAAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	[delegate configureRestKitWithBaseURL:[NSString stringWithFormat:@"http://localhost:%i", portNumber]];
	
	NSLog(@"Listening on port: %i", portNumber);
	portNumber++;
}

- (void)tearDown {
	[super tearDown];
}

- (void)testSimpleSubmitWithSuccess {
	WASubmission *submission = [[WASubmission alloc] init];
	submission.anonymous = YES;
	[submission addTag:@"Cow"];
	
	SimpleHTTPResponse *response = [[SimpleHTTPResponse alloc] init];
	[response setContentType:@"application/json"];
	[response setContentString:kResponseBodyOk];
	
	[self runTestOnWASubmitControllerWithSubmission:submission
										   response:response
								   shouldSetMessage:NO
									   withArgument:nil
						   shouldSetNavigationTitle:YES
									   withArgument:kWASubmitTitleSuccess];
}

#pragma mark - Utilities

/**
 Test that a WASubmitController behaves as expected given a submission and response
 from the server.
 
 if setMessage is nil then messageArg can be anything, same follows for setNavigationTitle
 
 @param submission the submission to submit
 @param response the response for the server to return
 @param setMessage whether the -[WASubmitController setMessage:] method should be called, if false the test will fail if it is
 @param messageArg the argument that should be expected to the -[WASubmitController setMessage:] method, to match any argument [OCMArg any] should be used
 @param setNavigationTitle whether the -[WASubmitController setNavigationTitle:navigationArg:] method should be called, if false the test will fail if it is
 @param navigationArg the argument that should be expected to the -[WASubmitController setNavigationTitle:] method, to match any argument [OCMArg any] should be used
 */
- (void)runTestOnWASubmitControllerWithSubmission:(WASubmission *)submission
										 response:(SimpleHTTPResponse *)response
								 shouldSetMessage:(BOOL)setMessage
									 withArgument:(id)messageArg
						 shouldSetNavigationTitle:(BOOL)setNavigationTitle
									 withArgument:(id)navigationArg {
	WASubmitViewController *controller = [[WASubmitViewController alloc] initWithSubmission:submission];
	OCMockObject *mock = [OCMockObject partialMockForObject:controller];
	
	
	id messageMock = setMessage?[mock expect]:[[mock stub] andThrow:DONT_CALL_EXCEPTION];
	id navigationMock = setNavigationTitle?[mock expect]:[[mock stub] andThrow:DONT_CALL_EXCEPTION];
	
	[messageMock setMessage:setMessage?messageArg:[OCMArg any]];
	[navigationMock setNavigationTitle:setNavigationTitle?navigationArg:[OCMArg any]];
	
	[self expectPostData:[submission jsonString] response:response exec:^{
		[controller sendSubmission];
	}];
	
	[mock verify];
}

- (void)expectPostData:(NSString *)string response:(SimpleHTTPResponse *)response exec:(void (^)(void))exec {
	__block BOOL awaitingResponse = YES;
	__block NSString *requestBody;
	NSDate *startDate = [NSDate date];
	
	currentPOSTExecuter = ^(SimpleHTTPRequest *request) {
		requestBody = [[NSString alloc] initWithData:[request body] encoding:NSUTF8StringEncoding];
		awaitingResponse = NO;
		return response;
	};
	
	exec();
	
	float timeout = 5;
	
	while(awaitingResponse) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        if([[NSDate date] timeIntervalSinceDate:startDate] > timeout) {
            [NSException raise:@"Test failed" format:@"*** Operation timed out after %f seconds...", timeout];
            awaitingResponse = NO;
        }
    }
	
	STAssertEqualObjects(requestBody, string, @"Data not what expected");
}

- (SimpleHTTPResponse *)processPOST:(SimpleHTTPRequest *)request {
	return currentPOSTExecuter(request);
}

- (SimpleHTTPResponse *)processGET:(SimpleHTTPRequest *)request {
	return nil;
}

@end

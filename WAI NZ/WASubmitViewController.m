//
//  WASubmitViewController.m
//  WAI NZ
//
//  Created by Melby Ruarus on 12/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WASubmitViewController.h"

#import "WASubmission.h"
#import "WASubmissionResponse.h"
#import "RKObjectManager+WAI.h"
#import "WAStyleHelper.h"
#import "DDProgressView.h"
#import <QuartzCore/QuartzCore.h>

NSString *const kWASubmitTitleFail = @"Oh dear...";
NSString *const kWASubmitTitleSuccess = @"Done";
NSString *const kWASubmitMessageUnexpectedResponse = @"The application received an unexpected response from the server, please try again";
NSString *const kWASubmitMessageInternet = @"The application was unable to connect to the server, please check your internet connection and try again";
NSString *const kWASubmitMessageTimeout = @"The connection timed out, please try again";
NSString *const kWASubmitMessageUnexpected = @"An unexpected error occured. Please try again";
NSString *const kWASubmitMessageUnexpectedServer = @"An unexpected server error occured, please try again";

static const CGFloat kSubmissionUpdateInterval = 0.033; // every 3%

@interface WASubmitViewController ()

@end

@implementation WASubmitViewController

#pragma mark - Init/Dealloc
///-----------------------------------------------------------------------------
/// @name Init/Dealloc
///-----------------------------------------------------------------------------

- (id)initWithSubmission:(WASubmission *)_submission {
	self = [self init];
	if(self) {
		submission = _submission;
	}
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Uploading...";
    }
    return self;
}

#pragma mark - View lifecycle
///-----------------------------------------------------------------------------
/// @name View lifecycle
///-----------------------------------------------------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	successfulStatusMessage.textColor=[WAStyleHelper tableViewHeaderTextColor];
	unsuccessfulStatusMessage.textColor=[WAStyleHelper tableViewHeaderTextColor];
	inProgressStatusMessage.textColor=[WAStyleHelper tableViewHeaderTextColor];
    self.navigationItem.hidesBackButton = YES;
    [progressBar setOuterColor:[UIColor clearColor]];
    [progressBar setInnerColor:[WAStyleHelper waiDarkBlueColor]];
    [progressBar setEmptyColor:[UIColor lightGrayColor]];
	progressBar.layer.shadowColor = [UIColor whiteColor].CGColor;
	progressBar.layer.shadowOffset = CGSizeMake(0, 1);
	progressBar.layer.shadowRadius = 0;
	progressBar.layer.shadowOpacity = 1;
}

- (void)viewDidAppear:(BOOL)animated {
    if(self.view == inProgressView) {
        [self sendSubmission];
    }
}

- (void)viewDidUnload {
    progressBar = nil;
    retryButton = nil;
    successfulStatusMessage = nil;
    inProgressStatusMessage = nil;
    unsuccessfulStatusMessage = nil;
    unsuccessfulView = nil;
    successfulView = nil;
    inProgressView = nil;
    doneButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Utilities
///-----------------------------------------------------------------------------
/// @name Utility methods
///-----------------------------------------------------------------------------

/**
 Post the submission to the WAI NZ API
 */
- (void)sendSubmission {
	submissionProgress = 0;
    
	// Post to the server!
	[[RKObjectManager sharedManager] postObjectWithResponse:submission
												 usingBlock:^(RKObjectLoader *loader) {
													 loader.delegate = self;
												 }];
}

/**
 Set the title of the navigation bar
 
 @param title the text to set the navigation title to
 */
- (void)setNavigationTitle:(NSString *)title {
	self.navigationItem.title = title;
}

/**
 Set the error message text
 
 @param message the text to set the unsuccessfulStatusMessage message to
 */
- (void)setMessage:(NSString *)message {
	unsuccessfulStatusMessage.text = message;
}

#pragma mark - Actions
///-----------------------------------------------------------------------------
/// @name Actions
///-----------------------------------------------------------------------------

/**
 The done button int he top-right navigation bar pressed
 
 @param sender the object that called this
 */
- (IBAction)doneButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 The retry button was pressed
 
 @param sender the object that called this method
 */
- (IBAction)retryButtonPressed:(id)sender {
    self.view = inProgressView;
    self.navigationItem.hidesBackButton = YES;
    [self sendSubmission];
}

#pragma mark - RKObjectLoaderDelegate
///-----------------------------------------------------------------------------
/// @name RKObjectLoaderDelegate
///-----------------------------------------------------------------------------

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
	// Update the progress
	submissionProgress = ((float)totalBytesWritten)/((float)totalBytesExpectedToWrite);
	if(submissionProgress > lastSubmissionProgress + kSubmissionUpdateInterval || submissionProgress >= 0.99999) {
		// Dont kill UI performance by updating too frequently
		lastSubmissionProgress = submissionProgress;
		progressBar.progress = submissionProgress;
	}
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
	LogDebug(@"Object loader did fail %@", error);
	
	self.view = unsuccessfulView;
	[self setNavigationTitle:kWASubmitTitleFail];
	
    if ([error.domain isEqualToString:@"org.restkit.RestKit.ErrorDomain"]) {
        switch (error.code) {
            case RKRequestUnexpectedResponseError:
                [self setMessage:kWASubmitMessageUnexpectedResponse];
                break;
            case RKObjectLoaderUnexpectedResponseError:
                [self setMessage:kWASubmitMessageUnexpectedResponse];
                break;
            case RKRequestConnectionTimeoutError:
                [self setMessage:kWASubmitMessageTimeout];
                break;
            case RKRequestBaseURLOfflineError:
                [self setMessage:kWASubmitMessageInternet];
                break;
            default:
                [self setMessage:kWASubmitMessageUnexpected];
        }
    }
	else {
		[self setMessage:kWASubmitMessageUnexpected];
	}
	
    [WAStyleHelper bottomAlignLabel:unsuccessfulStatusMessage];
	self.navigationItem.hidesBackButton = NO;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
	LogDebug(@"Object loader did load: %@", object);
	
	self.view = successfulView;
	self.navigationItem.rightBarButtonItem = doneButton;
    WASubmissionResponse *response = object;
    if ([response.status isEqualToString:@"OK"]) {
        self.view = successfulView;
        [self setNavigationTitle:kWASubmitTitleSuccess];
        self.navigationItem.rightBarButtonItem = doneButton;
    } else {
        self.view = unsuccessfulView;
        [self setNavigationTitle:kWASubmitTitleFail];
        self.navigationItem.hidesBackButton = NO;
        [self setMessage:kWASubmitMessageUnexpectedServer];
    }
    [submission unloadPhotos];
}

@end

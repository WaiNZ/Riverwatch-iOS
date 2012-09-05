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

static const CGFloat kSubmissionUpdateInterval = 0.033; // every 3%

@interface WASubmitViewController ()

@end

@implementation WASubmitViewController

#pragma mark - Init/Dealloc

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    inProgressStatusMessage.text = @"Uploading...";
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

- (void)sendSubmission {
	submissionProgress = 0;
    
	// Post to the server!
	[[RKObjectManager sharedManager] postObjectWithResponse:submission
												 usingBlock:^(RKObjectLoader *loader) {
													 loader.delegate = self;
												 }];
}

#pragma mark - Actions

- (IBAction)doneButtonPressed:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)retryButtonPressed:(id)sender {
    self.view = inProgressView;
    self.navigationItem.hidesBackButton = YES;
    [self sendSubmission];
}

#pragma mark - RKObjectLoaderDelegate

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
	self.view = unsuccessfulView;
	self.navigationItem.title = @"Oh dear...";
	self.navigationItem.hidesBackButton = NO;
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObject:(id)object {
	NSLog(@"%@", object);
	self.view = successfulView;
	self.navigationItem.title = @"Done";
	self.navigationItem.rightBarButtonItem = doneButton;
    [submission unloadPhotos];
}

@end

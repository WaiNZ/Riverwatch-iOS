//
//  WASubmissionPhotoGalleryViewController.m
//  WAI NZ
//
//  Created by Melby Ruarus on 12/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import "WASubmissionPhotoGalleryViewController.h"
#import "WASubmission.h"
#import "UINavigationBar+Animation.h"

static const CGFloat photoSpacer = 20;
#define PHOTO_PAN_MAX (self.view.bounds.size.width + photoSpacer)

@interface WASubmissionPhotoGalleryViewController ()

@end

@implementation WASubmissionPhotoGalleryViewController

- (id)initWithSubmission:(WASubmission *)_submission {
	self = [self init];
	if(self) {
		// Set up
		submission = _submission;
        
		self.navigationItem.title = @"Photos";
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete"
																				  style:UIBarButtonItemStyleBordered
																				 target:self
																				 action:@selector(deleteCurrentPhoto:)];
        
	}
   
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	leftView = view1;
	centerView = view2;
	rightView = view3;
	
	centerView.frame = self.subviewFrame;
	[self.view addSubview:centerView];
	centerView.image = [submission submissionPhotoAtIndex:currentPhoto].image;
}

- (void)viewDidUnload {
    view2 = nil;
	view1 = nil;
	view3 = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}

- (void)viewWillAppear:(BOOL)animated {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:animated];
    oldBarStyle = self.navigationController.navigationBar.barStyle;
	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent animated:animated];
	
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    [self.navigationController.navigationBar setBarStyle:oldBarStyle animated:animated];
	
	[super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (CGRect)subviewFrame {
	// TODO: other orrientations, etc
	CGRect bounds = self.view.bounds;
	bounds.origin.y = -20;
	bounds.size.height += 20;
	return bounds;
}

- (void)_setOffset:(CGFloat)offset {
	// Set frames of left, center, right views
	CGRect bounds = self.subviewFrame;
	
	CGRect leftFrame = bounds;
	leftFrame.origin.x = -leftFrame.size.width + offset - photoSpacer;
	leftView.frame = leftFrame;
	
	CGRect centerFrame = bounds;
	centerFrame.origin.x = 0 + offset;
	centerView.frame = centerFrame;
	
	CGRect rightFrame = bounds;
	rightFrame.origin.x = +rightFrame.size.width + offset + photoSpacer;
	rightView.frame = rightFrame;
}

- (IBAction)deleteCurrentPhoto:(id)sender{
	[submission removeSubmissionPhotoAtIndex:currentPhoto
							withConfirmation:^(int photoIndex) {
								CGFloat edge = 0;
								__unsafe_unretained UIImageView **viewToShift = &rightView;
								if(photoIndex == submission.numberOfSubmissionPhotos) {
									edge = self.view.bounds.size.width;
									viewToShift = &leftView;
									currentPhoto--;
								}
								
								CGPoint oldCenter = centerView.center;
								[self _setOffset:0];
								(*viewToShift).image = [submission submissionPhotoAtIndex:currentPhoto].image;
								[self.view addSubview:(*viewToShift)];
								[UIView animateWithDuration:kAnimationDuration
												 animations:^{
													 centerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
													 centerView.center = CGPointMake(edge, self.view.bounds.size.height/2);
													 (*viewToShift).center = oldCenter;
												 }
												 completion:^(BOOL done) {
													 UIImageView *temp = centerView;
													 centerView = (*viewToShift);
													 (*viewToShift) = temp;
													 
													 [leftView removeFromSuperview];
													 [rightView removeFromSuperview];
													 leftView.image = nil;
													 rightView.image = nil;
													 
													 temp.transform = CGAffineTransformIdentity;
													 temp.center = oldCenter;
												 }];
							}];
}

- (IBAction)viewPanned:(UIPanGestureRecognizer *)sender {
	CGFloat offset = [sender translationInView:self.view].x;
	CGFloat velocity = [sender velocityInView:self.view].x;
	
	switch (sender.state) {
		case UIGestureRecognizerStateBegan: {
			[self hideBars];
			
			// Add side views and configure them
			[self _setOffset:0];
			
			canSwipeLeft = currentPhoto>0;
			canSwipeRight = currentPhoto<submission.numberOfSubmissionPhotos-1;
			
			if(canSwipeLeft){
				[self.view addSubview:leftView];
				leftView.image = [submission submissionPhotoAtIndex:currentPhoto-1].image;
			}
		
			if(canSwipeRight){
				[self.view addSubview:rightView];
				rightView.image = [submission submissionPhotoAtIndex:currentPhoto+1].image;
			}
			
			break;
		}
		case UIGestureRecognizerStateChanged: {
			if(!canSwipeLeft && offset>0){
				offset/=2.5;
			}
			if(!canSwipeRight && offset<0){
				offset/=2.5;
			}
			[self _setOffset:offset];
			break;
		}
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateEnded: {
			[UIView animateWithDuration:kAnimationDuration
							 animations:^{
								 if(canSwipeLeft && (offset>self.view.bounds.size.width/2 || velocity > kFlickVelocity)){
									 [self _setOffset:PHOTO_PAN_MAX];
									 UIImageView *temp = centerView;
									 centerView = leftView;
									 leftView = temp;
									 currentPhoto--;
								 }
								 else if (canSwipeRight && (offset<-self.view.bounds.size.width/2 || velocity < -kFlickVelocity)){
									 [self _setOffset:-PHOTO_PAN_MAX];
									 UIImageView *temp = centerView;
									 centerView = rightView;
									 rightView = temp;
									 currentPhoto++;
								 }
								 else {
									 [self _setOffset:0];
								 }
								 
								 sender.enabled = NO;
							 }
							 completion:^(BOOL done){
								 [leftView removeFromSuperview];
								 [rightView removeFromSuperview];
								 leftView.image = nil;
								 rightView.image = nil;
								 
								 sender.enabled = YES;
							 }];
			break;
		}
		default:
			break;
	}
}

- (void)showBars {
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
	[UIView animateWithDuration:kStatusbarFadeAnimationDuration
					 animations:^{
						 self.navigationController.navigationBar.alpha = 1;
					 }];
}

- (void)hideBars {
	[UIView animateWithDuration:kStatusbarFadeAnimationDuration
					 animations:^{
						 self.navigationController.navigationBar.alpha = 0;
					 }];
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)toggleBars {
	if ([UIApplication sharedApplication].statusBarHidden) {
		[self showBars];
	} else {
		[self hideBars];
	}
}

- (IBAction)tapOnView:(id)sender {
	[self toggleBars];
}

@end

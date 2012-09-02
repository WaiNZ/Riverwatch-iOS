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
#import "UIImageView+Layout.h"

static const CGFloat photoSpacer = 20;
#define PHOTO_PAN_MAX (self.view.bounds.size.width + photoSpacer)

@interface WASubmissionPhotoGalleryViewController ()

@end

@implementation WASubmissionPhotoGalleryViewController

- (id)initWithSubmission:(WASubmission *)_submission andPhotoIndex:(int)index {
	self = [self init];
	if(self) {
		// Set up
		submission = _submission;
        currentPhoto = index;
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
	
	leftView = view1;
	centerView = view2;
	rightView = view3;
	leftImageView = imageView1;
	centerImageView = imageView2;
	rightImageView = imageView3;
}

- (void)viewDidUnload {
    view2 = nil;
	view1 = nil;
	view3 = nil;
	
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// Change the status/navigation bar style
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:animated];
    oldBarStyle = self.navigationController.navigationBar.barStyle;
	oldBarTint = self.navigationController.navigationBar.tintColor;
	self.navigationController.navigationBar.tintColor = nil;
	[self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent animated:animated];
	
	centerView.frame = self.subviewFrame;
	[self.view addSubview:centerView];
	centerImageView.image = [submission submissionPhotoAtIndex:currentPhoto].image;
}

- (void)viewDidAppear:(BOOL)animated {
	[centerImageView fitToImage];
}

- (void)viewWillDisappear:(BOOL)animated {
	// Restore the status/navigation bar style
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
    [self.navigationController.navigationBar setBarStyle:oldBarStyle animated:animated];
	self.navigationController.navigationBar.tintColor = oldBarTint;
	
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
	// Try to remove the photo
	[submission removeSubmissionPhotoAtIndex:currentPhoto
							withConfirmation:^(int photoIndex) {
								// Figure out positions of view
								CGFloat edge = 0;
								__unsafe_unretained UIScrollView **viewToShift = &rightView;
								__unsafe_unretained UIImageView **imageViewToShift = &rightImageView;
								if(photoIndex == submission.numberOfSubmissionPhotos) {
									edge = self.view.bounds.size.width;
									viewToShift = &leftView;
									imageViewToShift = &leftImageView;
									currentPhoto--;
								}
								
								// Save view positions and set them to what is needed for animations
								CGPoint oldCenter = centerView.center;
								[self _setOffset:0];
								[(*imageViewToShift) setAndFitToImage:[submission submissionPhotoAtIndex:currentPhoto].image];
								[self.view addSubview:(*viewToShift)];
								
								[UIView animateWithDuration:kAnimationDuration
												 animations:^{
													 // Photo deletion
													 
													 // Scale the view
													 centerView.transform = CGAffineTransformMakeScale(0.01, 0.01);
													 // Reposition the two views
													 centerView.center = CGPointMake(edge, self.view.bounds.size.height/2);
													 (*viewToShift).center = oldCenter;
												 }
												 completion:^(BOOL done) {
													 // Reset view positions and swap left/right/center etc
													 UIView *oldCenterView = centerView;
													 SWAP(centerImageView, *imageViewToShift);
													 SWAP(centerView, *viewToShift);
													 
													 [leftView removeFromSuperview];
													 [rightView removeFromSuperview];
													 leftImageView.image = nil;
													 rightImageView.image = nil;
													 
													 oldCenterView.transform = CGAffineTransformIdentity;
													 oldCenterView.center = oldCenter;
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
				[leftImageView setAndFitToImage:[submission submissionPhotoAtIndex:currentPhoto-1].image];
			}
		
			if(canSwipeRight){
				[self.view addSubview:rightView];
				[rightImageView setAndFitToImage:[submission submissionPhotoAtIndex:currentPhoto+1].image];
			}
			
			break;
		}
		case UIGestureRecognizerStateChanged: {
			// If there are no photos left/right scrolling is less
			if(!canSwipeLeft && offset>0){
				offset/=2.5;
			}
			if(!canSwipeRight && offset<0){
				offset/=2.5;
			}
			
			// Move the views
			[self _setOffset:offset];
			break;
		}
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateEnded: {
			// Do the flollowing animated
			[UIView animateWithDuration:kAnimationDuration
							 animations:^{
								 if(canSwipeLeft && (offset>self.view.bounds.size.width/2 || velocity > kFlickVelocity)) {
									 // Move the views
									 [self _setOffset:PHOTO_PAN_MAX];
									 
									 // Swap views
									 SWAP(centerView, leftView);
									 SWAP(centerImageView, leftImageView);
									 currentPhoto--;
								 }
								 else if (canSwipeRight && (offset<-self.view.bounds.size.width/2 || velocity < -kFlickVelocity)) {
									 // Move the views
									 [self _setOffset:-PHOTO_PAN_MAX];
									 
									 // Swap views
									 SWAP(centerView, rightView);
									 SWAP(centerImageView, rightImageView);
									 currentPhoto++;
								 }
								 else {
									 // Bounce back
									 [self _setOffset:0];
								 }
								 
								 // Disable the swipe during animation
								 sender.enabled = NO;
							 }
							 completion:^(BOOL done) {
								 // Remove the offscreen views
								 [leftView removeFromSuperview];
								 [rightView removeFromSuperview];
								 leftImageView.image = nil;
								 rightImageView.image = nil;
								 
								 // Reenable swipe
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

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {	
	if(scrollView == centerView) {
		return centerImageView;
	}
	
	return nil;
}

- (void)centerScrollViewContents {
	// From http://www.raywenderlich.com/10518/how-to-use-uiscrollview-to-scroll-and-zoom-content
    CGSize boundsSize = centerView.bounds.size;
    CGRect contentsFrame = centerImageView.frame;
	
    if(contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
	
    if(contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
	
    centerImageView.frame = contentsFrame;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
	[self centerScrollViewContents];
}
@end

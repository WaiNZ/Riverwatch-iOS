//
//  WASubmissionPhotoGalleryViewController.h
//  WAI NZ
//
//  Created by Melby Ruarus on 12/08/12.
//  Copyright (c) 2012 Water Action Initiative New Zealand. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WASubmission;

/**
 This controller manages the gallery view for viewing the photos
 attached to a WAI NZ submission. From this controller it is possible
 for the user to delete photos from the submission as well.
 
 Instances of WASubmissionPhotoGalleryViewController must be created
 using the -initWithSubmission: constructor.
 */
@interface WASubmissionPhotoGalleryViewController : UIViewController <UIScrollViewDelegate> {
	
    IBOutlet UITapGestureRecognizer *singleTap;
	IBOutlet UIScrollView *view2;
	IBOutlet UIScrollView *view3;
	IBOutlet UIScrollView *view1;
	
	__unsafe_unretained IBOutlet UIImageView *imageView1;
	__unsafe_unretained IBOutlet UIImageView *imageView2;
	__unsafe_unretained IBOutlet UIImageView *imageView3;
	
	__unsafe_unretained UIScrollView *leftView;
	__unsafe_unretained UIScrollView *centerView;
	__unsafe_unretained UIScrollView *rightView;
	
	__unsafe_unretained UIImageView *leftImageView;
	__unsafe_unretained UIImageView *centerImageView;
	__unsafe_unretained UIImageView *rightImageView;
	
	WASubmission *submission;
	int currentPhoto;
	
	BOOL canSwipeLeft;
	BOOL canSwipeRight;
	
	UIBarStyle oldBarStyle;
	UIColor *oldBarTint;
}

/**
 Initilize this WASubmissionPhotoGalleryViewController with the specified
 submission and selected photo.
 
 @param _submission the submission to view and edit the photos of
 @param index the id of the photo to display
 */
- (id)initWithSubmission:(WASubmission *)_submission andPhotoIndex:(int)index;


@end

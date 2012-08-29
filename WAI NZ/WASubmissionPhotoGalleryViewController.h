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
 * This controller manages the gallery view for viewing the photos attached to a WAI NZ submission.
 */
@interface WASubmissionPhotoGalleryViewController : UIViewController{
	
	IBOutlet UIImageView *view2;
	
	IBOutlet UIImageView *view3;
	IBOutlet UIImageView *view1;
	
	__unsafe_unretained UIImageView *leftView;
	__unsafe_unretained UIImageView *centerView;
	__unsafe_unretained UIImageView *rightView;
	
	WASubmission *submission;
	int currentPhoto;
	
	BOOL canSwipeLeft;
	BOOL canSwipeRight;
	
}

- (id)initWithSubmission:(WASubmission *)_submission;


@end
